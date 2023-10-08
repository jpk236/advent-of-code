#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my @code = ();
my @keypad = (
    [7,8,9],
    [4,5,6],
    [1,2,3],
);
my $y = 1;
my $x = 1;

#print "starting at ($y,$x) at number '".$keypad[$y][$x]."'\n";

foreach my $line (@input) {
    my @moves = split('', $line);

    foreach my $move (@moves) {
        #print "moving '$move'\n";

        if ($move eq 'U') {
            $y++ if ($y != (scalar(@keypad) - 1));
        }
        elsif ($move eq 'D') {
            $y-- if ($y != 0);
        }
        elsif ($move eq 'L') {
            $x-- if ($x != 0);
        }
        elsif ($move eq 'R') {
            $x++ if ($x != (scalar(@{$keypad[$y]}) - 1));
        }

        #print "now at ($y,$x) at number '".$keypad[$y][$x]."'\n";

        #my $gak = <>;
    }

    push (@code, $keypad[$y][$x]);

    #print Dumper \@code;
    #print "\n";

    #my $gak = <>;
}

print "code = '".join('', @code)."'\n";
