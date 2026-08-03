#!/usr/bin/env perl
# convert-skill-format.pl — convert SKILL.md bodies to the categorical-bullet template
# Action (write): rewrites skill bodies to ## headings + junction bullets + code-block tables
# Converts: **Header** → ## Header, numbered steps → junction bullets, inline bold strip,
#           md tables → code blocks (fence-aware)
# Usage: perl convert-skill-format.pl {file...}

use strict;
use warnings;

for my $file (@ARGV) {
    open my $fh, '<', $file or die "open $file: $!";
    my @lines = <$fh>;
    close $fh;

    my @out;
    my $in_code = 0;
    my $changed = 0;
    for my $line (@lines) {
        if ($line =~ /^```/) {
            $in_code = !$in_code;
            push @out, $line;
        } elsif ($in_code) {
            push @out, $line;
        } elsif ($line =~ /^-\s*\*\*(.+?)\*\*\s*[-—:]?\s*(.*)$/) {
            my ($label, $rest) = ($1, $2);
            my $nl = $rest eq '' ? '' : " — " . $rest;
            push @out, "- $label$nl\n";
            $changed++;
        } elsif ($line =~ /^\*\*([^*]+)\*\*\s*$/) {
            push @out, "## $1\n";
            $changed++;
        } elsif ($line =~ /^\s*\d+\.\s+(.*)$/) {
            push @out, "- $1\n";
            $changed++;
        } else {
            my $stripped = $line;
            $stripped =~ s/\*\*([^*]+)\*\*/$1/g;
            $changed++ if $stripped ne $line;
            push @out, $stripped;
        }
    }

    # second pass: wrap contiguous md table lines into a single code block
    my @final;
    my $i = 0;
    while ($i < @out) {
        if ($out[$i] =~ /^\|/) {
            my @block;
            while ($i < @out && $out[$i] =~ /^\|/) {
                my $b = $out[$i];
                chomp $b;
                push @block, $b;
                $i++;
            }
            push @final, "```text\n";
            push @final, map { "$_\n" } @block;
            push @final, "```\n";
            $changed++;
        } else {
            push @final, $out[$i];
            $i++;
        }
    }

    if ($changed) {
        open my $out_fh, '>', $file or die "write $file: $!";
        print {$out_fh} @final;
        close $out_fh;
        print "$changed changed: $file\n";
    }
}
