#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;
use feature qw(switch);

$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Deepcopy = 1;
open STDERR, '>&STDOUT';

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test_2.txt") if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my $result = 0;
my $enable = 1;

foreach my $line (@input) {
    my (@instructions) = $line =~ /(mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\))/go;

    foreach my $instruction (@instructions) {
        given ($instruction) {
            when("do()") {
                $enable = 1;
                next;
            }
            when("don't()") {
                $enable = 0;
                next;
            }
        }

        if ($enable) {
            my ($x, $y) = $instruction =~ /mul\((\d{1,3}),(\d{1,3})\)/o;

            $result += ($x * $y);
        }
    }
}

print "result: |" , $result , "|\n";
