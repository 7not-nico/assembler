#!/usr/bin/env perl
# strip-inline-bold.pl — strip markdown bold from bullets in SKILL.md, fence-aware
# Action (write): removes ** markers from bullet labels and mid-line bold
# Converts: - **Label** — text → - Label — text; mid-line **x** → x
# Skips: fenced code blocks
# Usage: perl strip-inline-bold.pl {file...}

use strict;
use warnings;

for my $file (@ARGV) {
    open my $fh, '<', $file or die "open $file: $!";
    my @lines = <$fh>;
    close $fh;

    my $in_code = 0;
    my $changed = 0;
    for my $line (@lines) {
        if ($line =~ /^```/) {
            $in_code = !$in_code;
            next;
        }
        next if $in_code;
        # leading bold label in a bullet: - **Label** — text
        if ($line =~ s/^-\s*\*\*(.+?)\*\*\s*[-—:]?\s*/ - $1 — /) {
            $changed++;
            next;
        }
        # mid-line bold markers: **x** → x
        if ($line =~ s/\*\*([^*]+)\*\*/$1/g) {
            $changed++;
        }
    }

    if ($changed) {
        open my $out, '>', $file or die "write $file: $!";
        print {$out} @lines;
        close $out;
        print "$changed changed: $file\n";
    }
}
