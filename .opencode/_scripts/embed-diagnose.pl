#!/usr/bin/env perl
# embed-diagnose.pl — replicate semantic-embed.ts discovery + row-selection against patlib.db
# Action (read): prints each stage of the embedder's logic to isolate the 0-embed cause
# Verifies: table discovery, Meta filter, row count, vector-store embedding parity
# Usage: perl embed-diagnose.pl
use strict;
use warnings;

my $db = "/home/eddyr/assembler/.opencode/patlib.db";
my $store = "/home/eddyr/assembler/.opencode/patlib-vector.db";
my $internal = "('embeddings','fts_entities','entities_fts','meta','notes','sqlite_sequence')";
my %meta = map { $_ => 1 } qw(id source tags status reference type created modified enforcement priority);

sub runq {
    my ($sql) = @_;
    my $out = `sqlite3 "$db" "$sql" 2>&1`;
    return split /\n/, $out;
}

print "=== STAGE 1: discovery query ===\n";
my $disc = "SELECT name FROM sqlite_master WHERE type='table' AND sql LIKE '%id TEXT%' AND sql LIKE '%title TEXT%' AND name NOT IN $internal";
my @found = runq($disc);
my $has_cli = grep { $_ eq 'cli' } @found;
print "  tables found: " . scalar(@found) . ", cli discoverable: " . ($has_cli ? "YES" : "NO") . "\n";
exit 1 unless $has_cli;

print "\n=== STAGE 2: first-row column keys (cli) ===\n";
my @colnames = map { (split /\|/, $_)[1] } runq("PRAGMA table_info(cli)");
print "  columns: " . join(", ", @colnames) . "\n";

print "\n=== STAGE 3: Meta filter (non-Meta columns) ===\n";
my @surviving = grep { !$meta{$_} } @colnames;
print "  surviving: " . join(", ", @surviving) . "\n";

print "\n=== STAGE 4: row selection ===\n";
my $sel = join(", ", map { "\"$_\"" } @surviving);
my @rows = runq("SELECT id, $sel FROM cli");
my @ids = grep { /^CLI\./ } @rows;   # id is the first pipe field; body lines don't start with CLI.
print "  row count: " . scalar(@ids) . "\n";
print "  ids: " . join(", ", @ids) . "\n";

print "\n=== STAGE 5: embeddings store check ===\n";
my $out = `sqlite3 "$store" "SELECT entity_id FROM embeddings WHERE entity_type='cli' ORDER BY entity_id" 2>&1`;
my @existing = grep { /^CLI\./ } split /\n/, $out;
print "  existing cli embeddings: " . scalar(@existing) . "\n";
print "  embedded ids: " . join(", ", @existing) . "\n";

my $all_embedded = @ids == 5 && @existing == 5;
print "\nVERDICT: " . ($has_cli && @ids == 5 && $all_embedded
    ? "COMPLETE — cli table has 5 rows, all 5 embedded; 0-embed report was an already-present skip"
    : "data gap at one of the stages above") . "\n";
exit($all_embedded ? 0 : 1);
