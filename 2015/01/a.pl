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
    #print "line: |" , $line , "\n";

    my @moves = split("", $line);

    my $level = 0;
    foreach my $move (@moves) {
        if ($move eq '(') {
            $level++;
        }
        elsif ($move eq ')') {
            $level--;
        }
    }

    print "Level = $level\n";

    #my $gak = <>;
}
