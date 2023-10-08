#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test_a.txt") if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my @lights = ();
for (my $y = 0; $y <= 999; $y++) {
    for (my $x = 0; $x <= 999; $x++) {
        $lights[$y][$x] = "";
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
                $lights[$y][$x] = "*";
            }
            elsif ($verb eq "off") {
                $lights[$y][$x] = "";
            }
            elsif ($verb eq "toggle") {
                if ($lights[$y][$x] eq "") {
                    $lights[$y][$x] = "*";
                }
                else {
                    $lights[$y][$x] = "";
                }
            }
        }
    }

    #printGrid(\@lights);

    #my $gak = <>;
}

my $lightsOn = 0;
for (my $y = 0; $y <= 999; $y++) {
    for (my $x = 0; $x <= 999; $x++) {
        if ($lights[$y][$x] eq "*") {
            $lightsOn++;
        }
    }
}

print "lightsOn: |" , $lightsOn , "|\n";

sub printGrid {
    my ($array) = @_;

    my @lights = @{$array};

    for (my $y = 0; $y < scalar @lights; $y++) {
        for (my $x = 0; $x < scalar @{$lights[$y]}; $x++) {
            if (! defined($lights[$y][$x])) {
                print " ";
            }
            elsif ($lights[$y][$x] eq "") {
                print " ";
            }
            else {
                print $lights[$y][$x];
            }
        }
        print "\n";
    }
}
