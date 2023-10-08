#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test_b.txt") if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my @lights = ();
for (my $y = 0; $y <= 999; $y++) {
    for (my $x = 0; $x <= 999; $x++) {
        $lights[$y][$x] = 0;
    }
}

foreach my $line (@input) {
    #print "line: |" , $line , "|\n";

    my $verb = "";
    my $start = "";
    my $end = "";

    if ($line =~ /^toggle /) {
        ($verb, $start, $end) = $line =~ /^(\w+) (\d+,\d+) through (\d+,\d+)/;
    }
    elsif ($line =~/^turn /io) {
        ($verb, $start, $end) = $line =~ /^turn (\w+) (\d+,\d+) through (\d+,\d+)/;
    }

    my ($startY, $startX) = split(',', $start);
    my ($endY, $endX) = split(',', $end);

    for (my $y = $startY; $y <= $endY; $y++) {
        for (my $x = $startX; $x <= $endX; $x++) {
            if ($verb eq "on") {
                $lights[$y][$x] += 1;
            }
            elsif ($verb eq "off") {
                $lights[$y][$x] -= 1;
                $lights[$y][$x] = 0 if ($lights[$y][$x] < 0);
            }
            elsif ($verb eq "toggle") {
                $lights[$y][$x] += 2;
            }
        }
    }

    #my $gak = <>;
}

my $brightness = 0;
for (my $y = 0; $y <= 999; $y++) {
    for (my $x = 0; $x <= 999; $x++) {
        $brightness += $lights[$y][$x];
    }
}

print "brightness: |" , $brightness , "|\n";
