#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test_b.txt") if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

foreach my $line (@input) {
    my @moves = split("", $line);

    #TODO
    #modulus to determine odd/even for santa vs. robo-santa
    #create two hashes and two x/y's to keep track of their state seperately
    #don't forget the 2 packages to start with

    my @houses = ();
    my $santaX = 0;
    my $robotX = 0;
    my $santaY = 0;
    my $robotY = 0;
    $houses[$santaY][$santaX]++;  # Santa
    $houses[$robotY][$robotX]++;  # Robo Santa

    #printGrid(\@houses);
    #my $gak = <>;

    for (my $i = 0; $i < scalar @moves; $i++) {
        my $turn = "santa";
        if (($i+1) % 2 == 0) {
            $turn = "robot";
        }
        #print "move: |" . $moves[$i] . "|\n";
        #print "turn: |" , $turn , "|\n";
        #print "santa coords: $santaY,$santaX\n";
        #print "robot coords: $robotY,$robotX\n";

        if ($turn eq 'santa') {
            my $arr = [];
            ($arr, $santaX, $santaY, $robotX, $robotY) = processMove(\@houses, $moves[$i], $santaX, $santaY, $robotX, $robotY);

            @houses = @{$arr};
        }
        elsif ($turn eq 'robot') {
            my $arr = [];
            ($arr, $robotX, $robotY, $santaX, $santaY) = processMove(\@houses, $moves[$i], $robotX, $robotY, $santaX, $santaY);

            @houses = @{$arr};
        }

        #printGrid(\@houses);

        #print "santa coords: $santaY,$santaX\n";
        #print "robot coords: $robotY,$robotX\n";
        #print "\n";
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
    #print "   " . 'x' x 100 . "\n";
}

sub processMove {
    my ($data, $move, $x, $y, $a, $b) = @_;

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
        $b++;

        unshift(@{$data}, [0]);
    }
    elsif ($x == -1) {
        $x = 0;
        $a++;

        for (my $y = 0; $y < scalar @{$data}; $y++) {
            unshift(@{$data->[$y]}, 0);
        }
    }

    $data->[$y][$x]++;

    return ($data, $x, $y, $a, $b);
}
