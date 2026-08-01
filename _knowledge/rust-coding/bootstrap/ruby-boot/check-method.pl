#!/usr/bin/env perl
# check ruby method names against SPEC.CODE.ELEMENT.NAME
# source: reference/element-name.md
# perl 5.40: signatures
# Logic flow: subject → object → action

use v5.40;
use strict;
use warnings;
use Cwd qw(abs_path);
use File::Basename qw(basename dirname);

my $selfdir = dirname(abs_path($0));
my $bootdir = dirname($selfdir);
my $root = dirname($bootdir);

# verb.txt — 97 verbs from reference/verbs.txt
my %verb;
{
    open my $fh, '<', "$bootdir/verb.txt" or die "verb.txt: $!";
    while (<$fh>) {
        chomp;
        next if /^\s*$/ || /^#/;
        $verb{$_} = 1;
    }
}

# built-in methods exempt from naming rules
my %builtin = map { $_ => 1 } qw(
    initialize new
    to_s to_i to_f to_a to_h to_sym to_str to_int
    respond_to? respond_to_missing? method_missing
    block_given? iterator?
    each each_with_index each_with_object each_key each_value
    map select reject inject reduce
    include extend prepend
    private public protected module_function
    attr_accessor attr_reader attr_writer
    alias_method
    class_eval module_eval instance_eval
    method_defined? private_method_defined? const_defined?
    puts print p pp printf sprintf
    require require_relative load autoload
    raise fail throw catch
    Integer Float String Array Hash
    at_exit exit abort!
    lambda proc
    loop sleep caller caller_locations
    gets chomp chop
    open close read write
    eval binding local_variables global_variables
    spawn fork exec system
    trap signal
    rand srand
    test
);

# helper — split camelCase into words
sub segment($name) {
    split /(?<=[a-z])(?=[A-Z])/, $name;
}

# predicate pack — agentive suffix rules, element-name.md lines 22-27
#   -er: parse→Parser, compile→Compiler, build→Builder
#   -or: validate→Validator, process→Processor
#   -ier: copy→Copier, amplify→Amplifier
sub agent($word) { $word =~ /(?:er|or|ier)$/i }
sub plural($word) { $word =~ /(?:ers|ors|iers)$/i }
sub gerund($word) { $word =~ /ing$/i && $word !~ /(?:string|thing|king|ring)$/i }
sub suffix($word) { $word =~ /(?:tion|sion|ment|ance|ence|ion|ity|ness)$/i }

# ─── subjects ────────────────────────────────────────────
# parse source text into method entry list

sub extract($raw) {
    my @out;
    while ($raw =~ /\bdef\s+(?:self\.)?(\w+(?:\?|!)?)/g) {
        my $name = $1;
        next if $builtin{$name};
        (my $stem = $name) =~ s/[?!]$//;
        my @parts = segment($stem);
        push @out, {
            name  => $name,
            stem  => $stem,
            parts => \@parts,
            count => scalar @parts,
        };
    }
    return @out;
}

# ─── objects (rules) ─────────────────────────────────────
# each rule: a predicate on a method entry → optional violation string

sub structural($m) {
    my @out;
    $m->{stem} =~ /_/ and push @out, 'uses snake case';
    $m->{count} >= 3 and push @out, 'has ' . $m->{count} . ' words (max 2)';
    $m->{stem} =~ /^the|^a(?:n)?/i and push @out, 'starts with article';
    return @out;
}

sub suffix_check($m) {
    my @out;
    gerund($m->{stem}) and push @out, 'gerund -ing';
    suffix($m->{stem}) and push @out, 'derived noun suffix';
    return @out;
}

sub agentive_check($m) {
    my @out;
    return @out if $m->{count} > 2;

    if ($m->{count} == 1) {
        my $s = $m->{stem};
        $verb{$s} && !agent($s) and push @out, 'bare imperative verb (add -er/-or)';
        !$verb{$s} && !agent($s) and push @out, 'missing agentive suffix -er/-or';
        plural($s) and push @out, 'plural agentive (use singular)';
    } elsif ($m->{count} == 2) {
        my $first = lc $m->{parts}[0];
        my $second = $m->{parts}[1];
        $verb{$first} and push @out, "imperative verb '$first'";
        !agent($second) and push @out, "'$second' missing -er/-or";
        gerund($second) and push @out, "'$second' gerund -ing";
        suffix($second) and push @out, "'$second' derived noun";
        plural($second) and push @out, "'$second' plural agentive (use singular)";
    }
    return @out;
}

# ─── action ──────────────────────────────────────────────
# method subject → rule object → violation action

sub audit($raw, $label, $lineno) {
    my @methods = extract($raw);
    my @out;
    for my $m (@methods) {
        my $tag = "$label:$lineno: method '$m->{name}'";
        for my $v (structural($m))      { push @out, "$tag $v" }
        for my $v (suffix_check($m))    { push @out, "$tag $v" }
        for my $v (agentive_check($m))  { push @out, "$tag $v" }
    }
    return @out;
}

# ─── scope scan ──────────────────────────────────────────

sub scan_scope($glob, $suffix = '') {
    for my $path (glob $glob) {
        my $label = basename($path, '.rb') . '.rb' . $suffix;
        open my $fh, '<', $path or next;
        my $raw = do { local $/; <$fh> };
        close $fh;
        for my $v (audit($raw, $label, 0)) {
            say $v;
        }
    }
}

scan_scope "$root/script/*.rb";
scan_scope "$bootdir/ruby-boot/*.rb", ' (self)';
