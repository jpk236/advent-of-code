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
    my $power = 0;

    my %cube = (
        'red'   => 0,
        'green' => 0,
        'blue'  => 0,
    );

    $line = lc($line);

    my ($game) = $line =~ /^game (\d+):/io;
    $line =~ s/^game \d+: //io;

    #print "game: |" , $game , "|\n";
    #print "line: |" , $line , "|\n";

    my @subsets = split(/\s*;\s*/, $line);

    foreach my $set (@subsets) {
        my @turns = split(/\s*,\s*/, $set);

        foreach my $turn (@turns) {
            my ($num, $color) = $turn =~ /^(\d+) (\w+)$/io;

            if ($num > $cube{$color}) {
                $cube{$color} = $num;
            }
        }
    }

    $power = $cube{'red'} * $cube{'green'} * $cube{'blue'};

    $total += $power;

    #my $gak = <>;
}

print "total: |" , $total , "|\n";
