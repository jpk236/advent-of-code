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
    #print "line: |" , $line , "\n";

    my @moves = split("", $line);

    my $level = 0;
    my $found = 0;
    for (my $i = 0; $i < scalar @moves; $i++) {
        if ($moves[$i] eq '(') {
            $level++;
        }
        elsif ($moves[$i] eq ')') {
            $level--;
        }

        if ($level == -1) {
            $found = ($i+1);
            last;
        }
    }

    print "Level = $level found at $found\n";

    #my $gak = <>;
}
