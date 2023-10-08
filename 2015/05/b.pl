#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test_b.txt") if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my @disallow = (
);

my $naughty = 0;
my $nice = 0;

STRING:
foreach my $line (@input) {
    #my $gak = <>;

    my $string = $line;
    my @chars = split('', $string);

    #print "string: |" , $string , "|\n";

    # Check #1
    my @possiblePairs = ();
    my @tmpChars = @chars;
    do {
        my $testStr = '';
        $testStr .= shift @tmpChars;
        $testStr .= shift @tmpChars;
        
        push (@possiblePairs, $testStr);
    } until (scalar @tmpChars < 2);

    @tmpChars = @chars;
    shift @tmpChars;
    do {
        my $testStr = '';
        $testStr .= shift @tmpChars;
        $testStr .= shift @tmpChars;
        
        push (@possiblePairs, $testStr);
    } until (scalar @tmpChars < 2);

    my $cnt = 0;
    foreach my $pair (@possiblePairs) {
        my @count = $string =~ /$pair/g;

        if (scalar @count > 1) {
            $cnt++;
        }
    }

    if ($cnt == 0) {
        #print "Failed Test #1\n";

        $naughty++;
        next STRING;
    }

    # Check #2
    my $repeat = 0;
    for (my $i = 0; $i < scalar @chars; $i++) {
        if (defined($chars[$i+2]) && $chars[$i] eq $chars[$i+2]) {
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
