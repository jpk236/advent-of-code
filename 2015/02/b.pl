#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my $total = 0;
foreach my $line (@input) {
    my ($l, $w, $h) = split('x', $line);

    my @sides = ();
    push(@sides, $l);
    push(@sides, $w);
    push(@sides, $h);
    @sides = sort { $a <=> $b } @sides; 

    # present
    my $perimeter = (2*$sides[0]) + (2*$sides[1]);

    # bow
    my $volume = $l * $w * $h;

    print "sub-total: |" . ($perimeter + $volume) . "|\n";

    $total += $perimeter + $volume; 
}

print "Total: |" , $total , "|\n";
