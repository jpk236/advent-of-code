#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test_a.txt") if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my $totalID = 0;

foreach my $line (@input) {
    my ($name, $id, $sum) = $line =~ /^([^\d]+)(\d+)\[(\w+)\]/io;
    chop($name);
    
    my %letters = ();
    foreach my $letter (split('', $name)) {
        if ($letter ne '-') {
            $letters{$letter}++;
        }
    }

    my %grouping = ();
    foreach my $letter (keys %letters) {
        push(@{$grouping{$letters{$letter}}}, $letter);
    }

    my @code = ();
    foreach my $group (sort { $b <=> $a } keys %grouping) {
        foreach my $letter (sort @{$grouping{$group}}) {
            push(@code, $letter);
        }
    }

    my $check = join('',@code[0..4]);

    if ($check eq $sum) {
        $totalID += $id;
    }
}

print "total = $totalID\n";
