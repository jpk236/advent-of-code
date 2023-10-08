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

# Seed with edges
my $totalVisible = 2 * (((scalar @forest) - 1) + ((scalar @{$forest[0]}) - 1));

for (my $y = 1; $y < (scalar @forest) - 1; $y++) {
    for (my $x = 1; $x < (scalar @{$forest[$y]}) - 1; $x++) {
        my $tree = $forest[$y][$x];

        my $uVisible = 1;
        my $dVisible = 1;
        my $lVisible = 1;
        my $rVisible = 1;

        # Compare same vertical ( -> up)
        for (my $i = $y; $i >= 0; $i--) {
            # Skip itself
            next if ($i == $y);

            my $other = $forest[$i][$x];

            if ($tree <= $other) {
                $uVisible = 0;
            }
        }

        # Compare same vertical ( -> down)
        for (my $i = $y; $i < scalar @forest; $i++) {
            # Skip itself
            next if ($i == $y);

            my $other = $forest[$i][$x];

            if ($tree <= $other) {
                $dVisible = 0;
            }
        }

        # Compare same horizontal ( -> left)
        for (my $i = $x; $i >= 0; $i--) {
            # Skip itself
            next if ($i == $x);

            my $other = $forest[$y][$i];

            if ($tree <= $other) {
                $lVisible = 0;
            }
        }

        # Compare same horizontal ( -> right))
        for (my $i = $x; $i < @{$forest[$y]}; $i++) {
            # Skip itself
            next if ($i == $x);

            my $other = $forest[$y][$i];

            if ($tree <= $other) {
                $rVisible = 0;
            }
        }

        if ($uVisible == 1 || $dVisible == 1 || $lVisible == 1 || $rVisible == 1) {
            $totalVisible++;
        }
    }
}

print "Total Visible = $totalVisible\n";

