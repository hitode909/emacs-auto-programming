#! /usr/bin/env perl
use strict;
use warnings;

sub trim ($) {
    my ($str) = @_;
    $str =~ s{^\s*}{}r =~ s{\s*$}{}r;
}

my $query = trim(join ' ', @ARGV);

my @lines = `git grep -A1 --fixed-strings -h @{[ quotemeta($query) ]}`;

unless (@lines) {
    exit 1;
}

my $counts = {};

while (@lines) {
    next unless trim(shift @lines) eq '--';

    my $header = trim(shift @lines);
    next unless length $header;
    next unless $header eq $query;

    my $candidate = trim(shift @lines);
    $counts->{$candidate} ||= 0;
    $counts->{$candidate}++;
}

my @sorted = sort { $counts->{$b} <=> $counts->{$a}; } keys %$counts;

for (@sorted) {
    print $_ . "\n";
}
