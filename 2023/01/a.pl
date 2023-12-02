#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")            if ($test == 0);
open (FILE, "input_test_a.txt")     if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my $sum = 0;
foreach my $line (@input) {
    #print "line: |" , $line , "|\n";

    my @chars = split('', $line);

    my $fst;
    foreach my $char (@chars) {
        if ($char =~ /^[0-9]$/o) {
            $fst = $char;

            last;
        }
    }

    my $lst;
    foreach my $char (reverse @chars) {
        if ($char =~ /^[0-9]$/o) {
            $lst = $char;

            last;
        }
    }

    my $val = $fst . $lst;

    $sum += $val;

    #print "fst: |" , $fst , "|\n";
    #print "lst: |" , $lst , "|\n";
    #print "val: |" , $val , "|\n";

    #my $gak = <>;
}

print "sum: |" , $sum , "|\n";