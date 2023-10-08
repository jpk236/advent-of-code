#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my %shape = (
    'Rock'      => 1,
    'Paper'     => 2,
    'Scissors'  => 3,
);

my %mapping = (
    'A' => 'Rock',
    'B' => 'Paper',
    'C' => 'Scissors',
    'X' => 'Rock',
    'Y' => 'Paper',
    'Z' => 'Scissors',
);

my %outcome = (
    'W' => 6,
    'L' => 0,
    'D' => 3,
);

my $oppScore = 0;
my $meScore = 0;

foreach my $line (@input) {
    my ($opp, $me) = split(' ', $line);

    # Score for shape
    $oppScore += $shape{$mapping{$opp}}; 
    $meScore  += $shape{$mapping{$me}};

    # Score outcome (draw)
    if ($mapping{$opp} eq $mapping{$me}) {
        $oppScore += $outcome{'D'};
        $meScore  += $outcome{'D'};
    }

    # Score for outcome (win/lose)
    if ($mapping{$opp} eq 'Rock') {
        if ($mapping{$me} eq 'Paper') {
            $oppScore += $outcome{'L'};
            $meScore  += $outcome{'W'};
        }
        elsif ($mapping{$me} eq 'Scissors') {
            $oppScore += $outcome{'W'};
            $meScore  += $outcome{'L'};
        }
    }
    elsif ($mapping{$opp} eq 'Paper') {
        if ($mapping{$me} eq 'Rock') {
            $oppScore += $outcome{'W'};
            $meScore  += $outcome{'L'};
        }
        elsif ($mapping{$me} eq 'Scissors') {
            $oppScore += $outcome{'L'};
            $meScore  += $outcome{'W'};
        }
    }
    elsif ($mapping{$opp} eq 'Scissors') {
        if ($mapping{$me} eq 'Rock') {
            $oppScore += $outcome{'L'};
            $meScore  += $outcome{'W'};
        }
        elsif ($mapping{$me} eq 'Paper') {
            $oppScore += $outcome{'W'};
            $meScore  += $outcome{'L'};
        }
    }

    #print "Score (opp) = " , $oppScore , "\n";
    #print "Score (me)  = " , $meScore , "\n";

    #my $gak = <>;
}

print "Total Score (opp) = " , $oppScore , "\n";
print "Total Score (me)  = " , $meScore , "\n";
