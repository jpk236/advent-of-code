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

    'X' => 'L',
    'Y' => 'D',
    'Z' => 'W',
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

    # Derive Shape
    my $oppShape = $mapping{$opp}; 
    my $meShape  = '';

    if ($oppShape eq 'Rock') {
        if ($mapping{$me} eq 'W') {
            $meShape = 'Paper';
        }
        elsif ($mapping{$me} eq 'L') {
            $meShape = 'Scissors';
        }
        elsif ($mapping{$me} eq 'D') {
            $meShape = 'Rock';
        }
    }
    elsif ($oppShape eq 'Paper') {
        if ($mapping{$me} eq 'W') {
            $meShape = 'Scissors';
        }
        elsif ($mapping{$me} eq 'L') {
            $meShape = 'Rock';
        }
        elsif ($mapping{$me} eq 'D') {
            $meShape = 'Paper';
        }
    }
    elsif ($oppShape eq 'Scissors') {
        if ($mapping{$me} eq 'W') {
            $meShape = 'Rock';
        }
        elsif ($mapping{$me} eq 'L') {
            $meShape = 'Paper';
        }
        elsif ($mapping{$me} eq 'D') {
            $meShape = 'Scissors';
        }
    }

    # Score for shape
    $oppScore += $shape{$oppShape}; 
    $meScore  += $shape{$meShape};

    # Score outcome (draw)
    if ($oppShape eq $meShape) {
        $oppScore += $outcome{'D'};
        $meScore  += $outcome{'D'};
    }

    # Score for outcome (win/lose)
    if ($oppShape eq 'Rock') {
        if ($meShape eq 'Paper') {
            $oppScore += $outcome{'L'};
            $meScore  += $outcome{'W'};
        }
        elsif ($meShape eq 'Scissors') {
            $oppScore += $outcome{'W'};
            $meScore  += $outcome{'L'};
        }
    }
    elsif ($oppShape eq 'Paper') {
        if ($meShape eq 'Rock') {
            $oppScore += $outcome{'W'};
            $meScore  += $outcome{'L'};
        }
        elsif ($meShape eq 'Scissors') {
            $oppScore += $outcome{'L'};
            $meScore  += $outcome{'W'};
        }
    }
    elsif ($oppShape eq 'Scissors') {
        if ($meShape eq 'Rock') {
            $oppScore += $outcome{'L'};
            $meScore  += $outcome{'W'};
        }
        elsif ($meShape eq 'Paper') {
            $oppScore += $outcome{'W'};
            $meScore  += $outcome{'L'};
        }
    }

    #print "me = |" , $me , "|\n";
    #print "oppShape = |" , $oppShape , "|\n";
    #print "meShape = |" , $meShape , "|\n";
    #print "Score (opp) = " , $oppScore , "\n";
    #print "Score (me)  = " , $meScore , "\n";

    #my $gak = <>;
}

print "Total Score (opp) = " , $oppScore , "\n";
print "Total Score (me)  = " , $meScore , "\n";
