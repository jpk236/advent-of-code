#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

foreach my $line (@input) {
    print "line: |" , $line , "|\n";

    for (my $i = 0; $i < length($line); $i++) {
        my $chunk = substr($line, $i, 4);

        #print "chunk: |" , $chunk , "|\n";

        my @chars = split('', $chunk);

        my %cnt = ();
        foreach my $char (@chars) {
            $cnt{$char}++;
        }

        my $unique = 1;
        foreach my $char (keys %cnt) {
            if ($cnt{$char} > 1) {
                $unique = 0;
                last;
            }
        }

        if ($unique == 1) {
            print "Found the start-of-packet!\n";
            print "Start = $chunk\n";
            print "Pos = ". ($i+4) . "\n";

            last;
        }

        #my $gak = <>;
    }

    #my $gak = <>;
}
