#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my @crt = ([],[],[],[],[],[]);
my @sprite = ('#','#','#');
my $cycle = 0;
my $x = 1;
my $y = 5;
my $tier = 0;
my $signal = 0;

printSprite(\@sprite);
print "\n";
printGrid(\@crt);
#my $gak = <>;

foreach my $line (@input) {
    #print "line: |" , $line , "|\n";

    if ($line =~ /^noop/) {
        $cycle++;

        #print "x: |" , $x , "|\n";
        #print "y: |" , $y , "|\n";
        #print "cycle: |" , $cycle , "|\n";
        #print "tier: |" , $tier , "|\n";
        #print "placement: |" , ($cycle-$tier) , "|\n";

        if (defined($sprite[$cycle-$tier-1]) && $sprite[$cycle-$tier-1] eq '#') {
            $crt[$y][$cycle-$tier-1] = '#';
        }
        else {
            $crt[$y][$cycle-$tier-1] = ' ';
        }

        checkCycle();
    }
    elsif ($line =~/^addx/) {
        my ($num) = $line =~ /^addx (.*)/;

        for (1..2) {
            $cycle++;

            #print "x: |" , $x , "|\n";
            #print "y: |" , $y , "|\n";
            #print "cycle: |" , $cycle , "|\n";
            #print "tier: |" , $tier , "|\n";
            #print "placement: |" , ($cycle-$tier) , "|\n";

            if (defined($sprite[$cycle-$tier-1]) && $sprite[$cycle-$tier-1] eq '#') {
                $crt[$y][$cycle-$tier-1] = '#';
            }
            else {
                $crt[$y][$cycle-$tier-1] = ' ';
            }

            checkCycle();
        }

        for (1..abs($num)) {
            if ($num > 0) {
                if ($sprite[0] eq '#' && 
                    (! defined($sprite[1]) || $sprite[1] ne '#')
                ) {
                    unshift(@sprite, '#');
                }
                elsif ($sprite[1] eq '#' && 
                    (! defined($sprite[2]) || $sprite[2] ne '#')
                ) {
                    unshift(@sprite, '#');
                }
                else {
                    unshift(@sprite, '.');
                }
                 
                $x++;
            }
            else {
                shift(@sprite);

                $x--;
            }
        }
    }

    printSprite(\@sprite);
    print "\n";
    printGrid(\@crt);

    last if ($cycle == 240);

    #my $gak = <>;
}

sub checkCycle {
    if (   ($cycle == 40)
        || ($cycle == 80)
        || ($cycle == 120)
        || ($cycle == 160)
        || ($cycle == 200)
    ) {
        $y--;
        #@sprite = ('#','#','#');
        $tier = $cycle;
    }
}

sub printSprite {
    my ($array) = @_;

    my @grid = @{$array};

    for (my $x = 0; $x < 40; $x++) {
        if (! defined($grid[$x])) {
            print '.';
        }
        else {
            print $grid[$x];
        }
    }
    print "\n";
}

sub printGrid {
    my ($array) = @_;

    my @grid = @{$array};

    for (my $y = ((scalar @grid) - 1); $y >= 0; $y--) {
        for (my $x = 0; $x < 40; $x++) {
            if (! defined($grid[$y][$x])) {
                print 'X';
            }
            else {
                print $grid[$y][$x];
            }
        }
        print "\n";
    }
    print "\n";
}
