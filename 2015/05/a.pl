#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test_a.txt") if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my @disallow = (
    'ab',
    'cd',
    'pq',
    'xy',
);

my @vowels = (
    'a',
    'e',
    'i',
    'o',
    'u',
);

my $naughty = 0;
my $nice = 0;

STRING:
foreach my $line (@input) {
    my $string = $line;
    my @chars = split('', $string);

    # Check #3
    foreach (@disallow) {
        if ($string =~ /$_/) {
            #print "Failed Test #3\n";
            $naughty++;

            next STRING;
        }
    }

    # Check #1
    my $vowels = 0;
    foreach my $char (@chars) {
        foreach my $vowel (@vowels) {
            if (lc($char) eq lc($vowel)) {
                $vowels++;
            }
        }
    }

    if ($vowels < 3) {
        #print "Failed Test #1: $vowels vowels\n";
        $naughty++;

        next STRING;
    }

    # Check #2
    my $repeat = 0;
    for (my $i = 0; $i < scalar @chars; $i++) {
        if (defined($chars[$i+1]) && $chars[$i] eq $chars[$i+1]) {
            $repeat++;
        }
    }

    if ($repeat == 0) {
        #print "Failed Test #2\n";
        $naughty++;
        
        next STRING;
    }

    # Tests complete
    #print "Passed all tests\n";
    $nice++;
}

print "naughty = $naughty\n";
print "nice: $nice\n";
