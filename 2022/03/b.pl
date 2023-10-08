#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my %priority = ();
my $i = 0;
foreach ("a".."z") {
    $i++;
    $priority{$_} = $i;
}
foreach ("A".."Z") {
    $i++;
    $priority{$_} = $i;
}

# seperate into groups
my @groups = ();
my @rucksacks = ();
for (my $i = 0; $i < scalar @input; $i++) {
    push (@rucksacks, $input[$i]);

    if (($i+1) % 3 == 0) {
        push(@groups, [@rucksacks]);
        @rucksacks = ();
    }
}

my $total = 0;

foreach my $group (@groups) {
    my @rucksacks = @{$group};
    
    my %rucksackHits = ();

    OUTER:
    foreach my $rucksack (@rucksacks) {
        my @items = split('', $rucksack);

        my %itemHits = ();
        foreach my $item (@items) {
            $itemHits{$item} = 1;
        }

        foreach my $item (keys %itemHits) {
            $rucksackHits{$item}++;

            if ($rucksackHits{$item} == 3) {
                $total += $priority{$item};

                last OUTER;
            }
        }
    }
}

print "Total = |" , $total , "|\n";
