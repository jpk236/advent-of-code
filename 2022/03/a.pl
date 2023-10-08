#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my %priority = ();
my $i = 0;
foreach ("a".."z") {
    $i++;
    $priority{$_} = $i;
}
foreach ("A".."Z") {
    $i++;
    $priority{$_} = $i;
}

my $total = 0;

foreach my $line (@input) {
    my $len = length($line);

    if ($len % 2 != 0) {
        print "ERROR: line is not even?\n";
        my $gak = <>;
    }

    my $c1 = substr($line, 0, ($len / 2));
    my $c2 = substr($line, ($len / 2));

    my @c1_items = split('', $c1);
    my @c2_items = split('', $c2);

    OUTER:
    foreach my $c1_item (@c1_items) {
        foreach my $c2_item (@c2_items) {
            if ($c1_item eq $c2_item) {
                $total += $priority{$c1_item};
    
                # error is "exactly one item type per rucksack"
                last OUTER;
            }
        }
    }
}

print "Total: $total\n";
