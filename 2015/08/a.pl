#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $interpolated = 0;

open (FILE, "input.txt")        if ($interpolated == 0);
open (FILE, "input_test.txt")   if ($interpolated == 1);
chomp(my @input = <FILE>);
close (FILE);

my $total = 0;
my $totalLiteral = 0;
my $totalMemory = 0;

foreach my $line (@input) {
    my $literal = length($line);

    my $raw = $line;
    $raw =~ s/^"|"$//gio;

    my $interpolated = $raw;
    $interpolated =~ s#\\\\#^#g;
    $interpolated =~ s#\\"#^#g;
    $interpolated =~ s#\\x[a-fA-F0-9][a-fA-F0-9]#^#g;

    my $memory = length($interpolated);

    $totalLiteral += $literal;
    $totalMemory += $memory;
}

print "Calc: |" . ($totalLiteral - $totalMemory) . "|\n";

