#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test_a.txt") if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

foreach my $line (@input) {
    my $y = 0;
    my $x = 0;
    my $sX = $x;
    my $sY = $y;
    my $facing = "N";

    #print "now at ($y,$x)\n";

    my @moves = split(', ', $line);

    #print Dumper \@moves;
    #print "\n";

    foreach my $move (@moves) {
        #print "move: |" , $move , "|\n";

        my ($dir, $num) = $move =~ /^([A-Za-z])(\d+)$/io;

        #print "moving '$dir' for '$num' spots\n";

        if ($facing eq 'N') {
            if ($dir eq 'R') {
                $facing = 'E';

                foreach (1..$num) {
                    $x++;
                }
            }
            elsif ($dir eq 'L') {
                $facing = 'W';

                foreach (1..$num) {
                    $x--;
                }
            }
        }
        elsif ($facing eq 'S') {
            if ($dir eq 'R') {
                $facing = 'W';

                foreach (1..$num) {
                    $x--;
                }
            }
            elsif ($dir eq 'L') {
                $facing = 'E';

                foreach (1..$num) {
                    $x++;
                }
            }
        }
        elsif ($facing eq 'E') {
            if ($dir eq 'R') {
                $facing = 'S';

                foreach (1..$num) {
                    $y--;
                }
            }
            elsif ($dir eq 'L') {
                $facing = 'N';

                foreach (1..$num) {
                    $y++;
                }
            }
        }
        elsif ($facing eq 'W') {
            if ($dir eq 'R') {
                $facing = 'N';

                foreach (1..$num) {
                    $y++;
                }
            }
            elsif ($dir eq 'L') {
                $facing = 'S';

                foreach (1..$num) {
                    $y--;
                }
            }
        }

        #print "now at ($y,$x); facing '$facing'\n";

        #my $gak = <>;
    }

    # Taxicab geometry
    # https://en.wikipedia.org/wiki/Taxicab_geometry
    my $distance = abs($x - $sX) + abs($y - $sY);

    print "distance = $distance\n";

    #my $gak = <>;
}
