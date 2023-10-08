#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 1;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

@input = reverse @input;

my %a2n = (
    'a' =>  1, 'b' =>  2, 'c' =>  3, 'd' =>  4,
    'e' =>  5, 'f' =>  6, 'g' =>  7, 'h' =>  8,
    'i' =>  9, 'j' => 10, 'k' => 11, 'l' => 12, 
    'm' => 13, 'n' => 14, 'o' => 15, 'p' => 16,
    'q' => 17, 'r' => 18, 's' => 19, 't' => 20,
    'u' => 21, 'v' => 22, 'w' => 23, 'x' => 24,
    'y' => 25, 'z' => 26,
    'S' =>  0, 'E' => 27,
);

my @grid = ();

my $startX = 0;
my $startY = 0;

my $targetX = 0;
my $targetY = 0;

for (my $y = 0; $y < scalar @input; $y++) {
    #print "line: |" , $input[$y] , "|\n";

    my @chars = split('', $input[$y]);
    #print Dumper \@chars;
    #print "\n";

    for (my $x = 0; $x < scalar @chars; $x++) {
        my %hash = (
            'value' => $a2n{$chars[$x]},
            'deadend' => 0,
            'visited' => 0,
        );

        if ($chars[$x] eq 'S') {
            $hash{'visited'} = 1;

            $startY = $y;
            $startX = $x;
        }
        elsif ($chars[$x] eq 'E') {
            $targetY = $y;
            $targetX = $x;
        }

        $grid[$y][$x] = \%hash;
    }

    #my $gak = <>;
}

#print Dumper \@grid;
#print "\n";

my $y = $startY;
my $x = $startX;
my $steps = 0;

while (1) {
    $steps++;

    #print "start ($y,$x) = \n";
    #print Dumper $grid[$y][$x];
    #print "\n";

    if ($grid[$y][$x]->{'value'} == 27) {
        print "reached desintation 'E' in $steps steps\n";

        $x = $startX;
        $y = $startY;
        $steps = 0;

        last;
        #next;
    }

    if (
        defined($grid[$y][$x-1]) && 
        ( 
            ($grid[$y][$x-1]->{'value'} == 27)
            || (
                ! $grid[$y][$x-1]->{'deadend'} && ! $grid[$y][$x-1]->{'visited'}
                && ($grid[$y][$x-1]->{'value'} - $grid[$y][$x]->{'value'} <= 1)
            )
        )
    ) { # Left
        #print "going left..\n";

        #print "destination ($y,".($x-1).") = \n";
        #print Dumper $grid[$y][$x-1];
        #print "\n";

        $grid[$y][$x-1]->{'visited'} = 1;

        $x = $x-1;
        $y = $y;
    }
    elsif (
        defined($grid[$y-1][$x]) && 
        ( 
            ($grid[$y-1][$x]->{'value'} == 27)
            || (
                ! $grid[$y-1][$x]->{'deadend'} && ! $grid[$y-1][$x]->{'visited'}
                && ($grid[$y-1][$x]->{'value'} - $grid[$y][$x]->{'value'} <= 1)
            )
        )
    ) { # Down
        #print "going down..\n";

        #print "destination (".($y-1).",$x) = \n";
        #print Dumper $grid[$y-1][$x];
        #print "\n";

        $grid[$y-1][$x]->{'visited'} = 1;

        $x = $x;
        $y = $y-1;
    }
    elsif (
        defined($grid[$y+1][$x]) && 
        ( 
            ($grid[$y+1][$x]->{'value'} == 27)
            || (
                ! $grid[$y+1][$x]->{'deadend'} && ! $grid[$y+1][$x]->{'visited'}
                && ($grid[$y+1][$x]->{'value'} - $grid[$y][$x]->{'value'} <= 1)
            )
        )
    ) { # Up
        #print "going up..\n";

        #print "destination (".($y+1).",$x) = \n";
        #print Dumper $grid[$y+1][$x];
        #print "\n";

        $grid[$y+1][$x]->{'visited'} = 1;

        $x = $x;
        $y = $y+1;
    }
    if (
        defined($grid[$y][$x+1]) &&
        ( 
            ($grid[$y][$x+1]->{'value'} == 27)
            || (
                ! $grid[$y][$x+1]->{'deadend'} && ! $grid[$y][$x+1]->{'visited'}
                && ($grid[$y][$x+1]->{'value'} - $grid[$y][$x]->{'value'} <= 1)
            )   
        )
    ) { # Right
        #print "going right..\n";

        #print "destination ($y,".($x+1).") = \n";
        #print Dumper $grid[$y][$x+1];
        #print "\n";

        $grid[$y][$x+1]->{'visited'} = 1;

        $x = $x+1;
        $y = $y;
    }
    else { # Deadend
        print "reached deadend at ($y,$x) in $steps steps:\n";

        $grid[$y][$x]->{'deadend'} = 1;

        # Reset
        for (my $y = 0; $y < scalar @grid; $y++) {
            for (my $x = 0; $x < scalar @{$grid[$y]}; $x++) {
                if ($grid[$y][$x]->{'value'} != 0 && $grid[$y][$x]->{'value'} != 27) {
                    $grid[$y][$x]->{'visited'} = 0;
                }
            }
        }

        $x = $startX;
        $y = $startY;
        $steps = 0;
    }

    my $gak =<>;
}

#print Dumper \@grid;
#print "\n";

print "Steps: |" , $steps , "|\n";
