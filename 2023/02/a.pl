#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my %limit = (
    'red'   => 12,
    'green' => 13,
    'blue'  => 14,
);

my $total = 0;

foreach my $line (@input) {
    my $possible = 1;
    my %cube = ();

    #print "line: |" , $line , "|\n";
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

            if ($num > $limit{$color}) {
                $possible = 0;
            }

            #$cube{$color} += $num;
        }
    }

    #print Dumper \%cube;
    #print "\n";

    #foreach my $color (sort keys %cube) {
    #    if ($cube{$color} > $limit{$color}) {
    #        $possible = 0;
    #    }
    #}

    if ($possible) {
        #print "possible!\n";
        $total += $game;
    }
    #print "total: |" , $total , "|\n";

    #my $gak = <>;
}

print "total: |" , $total , "|\n";
