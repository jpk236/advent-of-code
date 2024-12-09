#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Deepcopy = 1;
open STDERR, '>&STDOUT';

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test_1.txt") if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my $result = 0;

foreach my $line (@input) {
    my (@instructions) = $line =~ /mul\(\d{1,3},\d{1,3}\)/go;

    foreach my $instruction (@instructions) {
        my ($x, $y) = $instruction =~ /mul\((\d+),(\d+)\)/o;

        $result += ($x * $y);
    }
}

print "result: |" , $result , "|\n";
