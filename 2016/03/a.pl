#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test_a.txt") if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my $possible = 0;

foreach my $line (@input) {
    my ($s1, $s2, $s3) = $line =~ /^\s+(\d+)\s+(\d+)\s+(\d+)$/io; 

    if (
        (($s1 + $s2) > $s3) && 
        (($s2 + $s3) > $s1) &&
        (($s1 + $s3) > $s2)
        ) {
        $possible++;
    }

    #my $gak = <>;
}

print "possible = $possible\n";
