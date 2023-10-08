#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test_a.txt") if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my @grid = ();
my @hVisits = ();
my @tVisits = ();

my $y = 0;
my $x = 0;

my $yH = 0;
my $xH = 0;

my $yT = 0;
my $xT = 0;

$grid[$y][$x] = 'B';
$hVisits[$yH][$xH] = '#';
$tVisits[$yT][$xT] = '#';

#print Dumper \@grid;
#print "\n";

#print "H ($yH,$xH) \t T ($yT,$xT)\n";
#printGrid(\@grid);

#my $gak = <>;

foreach my $line (@input) {
    #print "line: |" , $line , "|\n";

    my ($dir, $cnt) = split(' ', $line);

    for (1..$cnt) {
        if ($grid[$y][$x] eq 'B') {
            $grid[$y][$x] = 'T';
        }
        else {
            $grid[$y][$x] = '.';
        }

        if ($dir eq 'U') {     # U (y)
            $y++;;
        }
        elsif ($dir eq 'D') {  # D (y)
            $y--;
        }
        elsif ($dir eq 'R') {  # R (x)
            $x++;
        }
        elsif ($dir eq 'L') {  # L (x)
            $x--;
        }

        if ($y == -1) {
            $y = 0;

            unshift(@grid, ['.']);
            unshift(@hVisits, ['.']);
            unshift(@tVisits, ['.']);

            $yT++;
        }
        elsif ($x == -1) {
            $x = 0;

            for (my $y = 0; $y < scalar @grid; $y++) {
                unshift(@{$grid[$y]}, '.');
                unshift(@{$hVisits[$y]}, '.');
                unshift(@{$tVisits[$y]}, '.');
            }

            $xT++;
        }

        $xH = $x;
        $yH = $y;

        if (($xH - $xT) == 2) { # Right
            if (defined($grid[$yT][$xT]) && $grid[$yT][$xT] eq 'T') {
                $grid[$yT][$xT] = '.';
            }

            $xT++;
            $yT = $yH if ($yT != $yH);

            $grid[$yT][$xT] = 'T';
        }
        elsif (($yH - $yT) == 2) { # Up
            if (defined($grid[$yT][$xT]) && $grid[$yT][$xT] eq 'T') {
                $grid[$yT][$xT] = '.';
            }

            $yT++;
            $xT = $xH if ($xT != $xH);

            $grid[$yT][$xT] = 'T';
        }
        elsif (($xT - $xH) == 2) { # Left
            if (defined($grid[$yT][$xT]) && $grid[$yT][$xT] eq 'T') {
                $grid[$yT][$xT] = '.';
            }

            $xT--;
            $yT = $yH if ($yT != $yH);

            $grid[$yT][$xT] = 'T';
        }
        elsif (($yT - $yH) == 2) { # Down
            if (defined($grid[$yT][$xT]) && $grid[$yT][$xT] eq 'T') {
                $grid[$yT][$xT] = '.';
            }

            $yT--;
            $xT = $xH if ($xT != $xH);

            $grid[$yT][$xT] = 'T';
        }

        if (defined($grid[$y][$x]) && $grid[$y][$x] eq 'T') {
            $grid[$y][$x] = 'B';
        }
        else {
            $grid[$y][$x] = 'H';
        }

        #print Dumper \@grid;
        #print "\n";

        $hVisits[$yH][$xH] = '#';
        $tVisits[$yT][$xT] = '#';

        #print "H ($yH,$xH) \t T ($yT,$xT)\n";
        #printGrid(\@grid);

        #my $gak = <>;
    }
}

#printGrid(\@hVisits);
#printGrid(\@tVisits);

my $numVisits = 0;
for (my $y = ((scalar @tVisits) - 1); $y >= 0; $y--) {
    for (my $x = 0; $x < scalar @{$tVisits[$y]}; $x++) {
        if (defined($tVisits[$y][$x]) && $tVisits[$y][$x] eq '#') {
            $numVisits++;
        }
    }
}

print "numVisits: |" , $numVisits , "|\n";

sub printGrid {
    my ($array) = @_;

    my @grid = @{$array};

    for (my $y = ((scalar @grid) - 1); $y >= 0; $y--) {
        printf('%2sy', $y);

        for (my $x = 0; $x < scalar @{$grid[$y]}; $x++) {
            if (! defined($grid[$y][$x])) {
                print '.';
            }
            else {
                print $grid[$y][$x];
            }
        }
        print "\n";
    }
    print "\n";
}
