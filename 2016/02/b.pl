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
    [undef, undef,  'D',    undef,  undef],
    [undef, 'A',    'B',    'C',    undef],
    [5,     6,      7,      8,      9],
    [undef, 2,      3,      4,      undef],
    [undef, undef,  '1',    undef,  undef],
);
my $y = 2;
my $x = 0;

#print "starting at ($y,$x) at number '".$keypad[$y][$x]."'\n";

foreach my $line (@input) {
    my @moves = split('', $line);

    foreach my $move (@moves) {
        #print "moving '$move'\n";

        if ($move eq 'U') {
            if ($y != (scalar(@keypad) - 1) && defined($keypad[$y+1][$x])) {
                $y++;
            }
        }
        elsif ($move eq 'D') {
            if ($y != 0 && defined($keypad[$y-1][$x])) {
                $y--;
            }
        }
        elsif ($move eq 'L') {
            if ($x != 0 && defined($keypad[$y][$x-1])) {
                $x--;
            }
        }
        elsif ($move eq 'R') {
            if ($x != (scalar(@{$keypad[$y]}) - 1) && defined($keypad[$y][$x+1])) {
                $x++;
            }
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
