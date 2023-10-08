#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my @forest = ();

for (my $y = 0; $y < scalar @input; $y++) {
    my @trees = split('', $input[$y]);

    for (my $x = 0; $x < scalar @trees; $x++) {
        $forest[$y][$x] = $trees[$x];
    }
}

my $maxVD = 0;

for (my $y = 0; $y < scalar @forest; $y++) {
    for (my $x = 0; $x < scalar @{$forest[$y]}; $x++) {
        my $tree = $forest[$y][$x];
        my $vd = 0;

        my $uVisible = 0;
        my $dVisible = 0;
        my $lVisible = 0;
        my $rVisible = 0;

        # Compare same vertical ( -> up)
        for (my $i = $y; $i >= 0; $i--) {
            # Skip itself
            next if ($i == $y);

            my $other = $forest[$i][$x];

            $uVisible++;

            if ($other >= $tree) {
                last;
            }
        }

        # Compare same vertical ( -> down)
        for (my $i = $y; $i < scalar @forest; $i++) {
            # Skip itself
            next if ($i == $y);

            my $other = $forest[$i][$x];

            $dVisible++;

            if ($other >= $tree) {
                last;
            }
        }

        # Compare same horizontal ( -> left)
        for (my $i = $x; $i >= 0; $i--) {
            # Skip itself
            next if ($i == $x);

            my $other = $forest[$y][$i];

            $lVisible++;

            if ($other >= $tree) {
                last;
            }
        }

        # Compare same horizontal ( -> right))
        for (my $i = $x; $i < @{$forest[$y]}; $i++) {
            # Skip itself
            next if ($i == $x);

            my $other = $forest[$y][$i];

            $rVisible++;

            if ($other >= $tree) {
                last;
            }
        }

        $vd = ($uVisible * $lVisible * $dVisible * $rVisible);
        $maxVD = $vd if ($vd > $maxVD);
    }
}

print "Max Viewing Distance = $maxVD\n";

