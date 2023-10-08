#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test_a.txt") if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

foreach my $line (@input) {
    my @moves = split("", $line);

    my @houses = ();
    my $x = 0;
    my $y = 0;
    $houses[$y][$x]++;

    #printGrid(\@houses);
    #my $gak = <>;

    foreach my $move (@moves) {
        if ($move eq '^') {     # North (y)
            $y++;
        }
        elsif ($move eq 'v') {  # South (y)
            $y--;
        }
        elsif ($move eq '>') {  # East (x)
            $x++;
        }
        elsif ($move eq '<') {  # West (x)
            $x--;
        }

        if ($y == -1) {
            $y = 0;

            unshift(@houses, [0]);
        }
        elsif ($x == -1) {
            $x = 0;

            for (my $y = 0; $y < scalar @houses; $y++) {
                unshift(@{$houses[$y]}, 0);
            }
        }

        $houses[$y][$x]++;

        #printGrid(\@houses);
        #my $gak = <>;
    }

    printGrid(\@houses);

    my $numHouses = 0;

    for (my $y = 0; $y < scalar @houses; $y++) {
        for (my $x = 0; $x < scalar @{$houses[$y]}; $x++) {
            if (defined($houses[$y][$x]) && $houses[$y][$x] > 0) {
                $numHouses++;
            }
        }
    }

    print "Total = $numHouses\n";
}

sub printGrid {
    my ($array) = @_;

    my @houses = @{$array};

    for (my $y = ((scalar @houses) - 1); $y >= 0; $y--) {
        printf('%2sy', $y);

        for (my $x = 0; $x < scalar @{$houses[$y]}; $x++) {
            if (! defined($houses[$y][$x])) {
                print " ";
            }
            elsif ($houses[$y][$x] == 0) {
                print " ";
            }
            else {
                print $houses[$y][$x];
            }
        }
        print "\n";
    }
    print "   " . 'x' x 100 . "\n";
}
