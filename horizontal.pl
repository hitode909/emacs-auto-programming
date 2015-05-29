#! /usr/bin/env perl
use strict;
use warnings;

sub trim ($) {
    my ($str) = @_;
    $str =~ s{^\s*}{}r =~ s{\s*$}{}r;
}

my $query = trim(join ' ', @ARGV);

my @lines = `git grep --fixed-strings -h @{[ quotemeta($query) ]}`;

unless (@lines) {
    exit 1;
}

my $counts = {};

for my $line (@lines) {
    my $candidate = trim($line);
    next unless length $candidate;
    next if $candidate eq $query;
    next unless $candidate =~ qr{^\Q$query};
    $counts->{$candidate} ||= 0;
    $counts->{$candidate}++;
}

my @sorted = sort { $counts->{$b} <=> $counts->{$a}; } keys %$counts;

for (@sorted) {
    print $_ . "\n";
}
