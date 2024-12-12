#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Deepcopy = 1;
open STDERR, '>&STDOUT';

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my @lines = ();

foreach my $line (@input) {
    my @x = ();
    @x = split('', $line);

    push (@lines, \@x);
}

my $xmas = 0;

for (my $y = 0 ; $y < scalar @lines; $y++) {
    for (my $x = 0 ; $x < scalar @{$lines[$y]}; $x++) {
        if ($lines[$y][$x] eq 'X') {
            # Forwards
            if (defined($lines[$y][$x+1]) && $lines[$y][$x+1] eq 'M') {
                if (defined ($lines[$y][$x+2]) && $lines[$y][$x+2] eq 'A') {
                    if (defined($lines[$y][$x+3]) && $lines[$y][$x+3] eq 'S') {
                        $xmas++;
                    }
                }
            }

            # Backwards
            if (defined($lines[$y][$x-1]) && (($x-1) >= 0) && $lines[$y][$x-1] eq 'M') {
                if (defined($lines[$y][$x-2]) && (($x-2) >= 0) && $lines[$y][$x-2] eq 'A') {
                    if (defined($lines[$y][$x-3]) && (($x-3) >= 0) && $lines[$y][$x-3] eq 'S') {
                        $xmas++;
                    }
                }
            }

            # Up
            if (defined($lines[$y+1][$x]) && $lines[$y+1][$x] eq 'M') {
                if (defined($lines[$y+2][$x]) && $lines[$y+2][$x] eq 'A') {
                    if (defined($lines[$y+3][$x]) && $lines[$y+3][$x] eq 'S') {
                        $xmas++;
                    }
                }
            }

            # Down
            if (defined($lines[$y-1][$x]) && (($y-1) >= 0) && $lines[$y-1][$x] eq 'M') {
                if (defined($lines[$y-2][$x]) && (($y-2) >= 0) && $lines[$y-2][$x] eq 'A') {
                    if (defined($lines[$y-3][$x]) && (($y-3) >= 0) && $lines[$y-3][$x] eq 'S') {
                        $xmas++;
                    }
                }
            }

            # Up-Left Diagonal
            if (defined($lines[$y+1][$x-1]) && (($x-1) >= 0) && $lines[$y+1][$x-1] eq 'M') {
                if (defined($lines[$y+2][$x-2]) && (($x-2) >= 0) && $lines[$y+2][$x-2] eq 'A') {
                    if (defined($lines[$y+3][$x-3]) && (($x-3) >= 0) && $lines[$y+3][$x-3] eq 'S') {
                        $xmas++;
                    }
                }
            }

            # Up-Right Diagonal
            if (defined($lines[$y+1][$x+1]) && $lines[$y+1][$x+1] eq 'M') {
                if (defined($lines[$y+2][$x+2]) && $lines[$y+2][$x+2] eq 'A') {
                    if (defined($lines[$y+3][$x+3]) && $lines[$y+3][$x+3] eq 'S') {
                        $xmas++;
                    }
                }
            }

            # Down-Left Diagonal
            if (defined($lines[$y-1][$x-1]) && (($y-1) >= 0) && (($x-1) >= 0) && $lines[$y-1][$x-1] eq 'M') {
                if (defined($lines[$y-2][$x-2]) && (($y-2) >= 0) && (($x-2) >= 0) && $lines[$y-2][$x-2] eq 'A') {
                    if (defined($lines[$y-3][$x-3]) && (($y-2) >= 0) && (($x-3) >= 0) && $lines[$y-3][$x-3] eq 'S') {
                        $xmas++;
                    }
                }
            }

            # Down-Right Diagonal
            if (defined($lines[$y-1][$x+1]) && (($y-1) >= 0) && $lines[$y-1][$x+1] eq 'M') {
                if (defined($lines[$y-2][$x+2]) && (($y-2) >= 0) && $lines[$y-2][$x+2] eq 'A') {
                    if (defined($lines[$y-3][$x+3]) && (($y-3) >= 0) && $lines[$y-3][$x+3] eq 'S') {
                        $xmas++;
                    }
                }
            }
        }
    }
}

print "xmas: |" , $xmas , "|\n";
