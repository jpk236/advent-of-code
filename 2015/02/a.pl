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

    my $surfaceArea = (2*($l*$w)) + (2*($w*$h)) + (2*$h*$l);

    my @areas = ();
    push(@areas, ($l*$w));
    push(@areas, ($w*$h));
    push(@areas, ($h*$l));
    @areas = sort { $a <=> $b } @areas; 

    my $smallestArea = $areas[0];
    print "sub-total: |" . ($surfaceArea + $smallestArea) . "|\n";

    $total += $surfaceArea + $smallestArea;
}

print "Total: |" , $total , "|\n";
