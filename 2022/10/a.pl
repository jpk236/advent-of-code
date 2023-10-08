#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my $cycle = 0;
my $x = 1;
my $signal = 0;

foreach my $line (@input) {
    #print "line: |" , $line , "|\n";

    if ($line =~ /^noop/) {
        $cycle++;

        checkCycle();
    }
    elsif ($line =~/^addx/) {
        $cycle++;

        my ($num) = $line =~ /^addx (.*)/;

        checkCycle();

        $cycle++;

        checkCycle();

        $x += $num;
    }

    last if ($cycle == 220);
}

print "Total Signal: |" , $signal , "|\n";

sub checkCycle {
    if ($cycle =~ /^(20|60|100|140|180|220)$/) {
        print "checking Cycle=$cycle x=$x\n";

        $signal += ($x * $cycle);
    }
}
