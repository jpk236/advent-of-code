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
chomp(my @input = reverse <FILE>);
close (FILE);

my @grid = ();
my $x = 0;
my $y = 0;

for (my $i = 0 ; $i < scalar @input ; $i++) {
    my @chars = split('', $input[$i]);

    my ($pos) = grep { $chars[$_] eq '^' } 0 .. $#chars;

    if (defined($pos)) {
        $y = $i;
        $x = $pos;
    }

    push(@grid, \@chars);
}

# guard
my $dir = '^';
my %pos = (
    "($y,$x)" => 1,
);
my $guard_y = $y;
my $guard_x = $x;

# obstruction
my %obstruction = ();
my $test_y = 0;
my $test_x = 0;
$grid[$test_y][$test_x] = 0;

while (1) {
    if ($dir eq '^') {
        if (($y+1) >= (scalar @grid)) {
            ($dir, $y, $x) = resetGrid($dir, $y, $x);

            next;
        }
        elsif ($grid[$y+1][$x] eq '.') {
            $grid[$y+1][$x] = $dir;
            $grid[$y][$x]   = '.';

            $y++;
        }
        elsif ($grid[$y+1][$x] =~ /^(#|0)$/io) {
            if ($grid[$y][$x+1] =~ /^(#|0)$/io) {
                $dir = 'v';

                $grid[$y-1][$x] = $dir;
                $grid[$y][$x]   = '.';

                $y--;
            }
            else {
                $dir = '>';

                $grid[$y][$x+1] = $dir;
                $grid[$y][$x]   = '.';

                $x++;
            }
        }
    }
    elsif ($dir eq '>') {
        if (($x+1) >= (scalar @{$grid[$y]})) {
            ($dir, $y, $x) = resetGrid($dir, $y, $x);

            next;
        }
        elsif ($grid[$y][$x+1] eq '.') {
            $grid[$y][$x+1] = $dir;
            $grid[$y][$x]   = '.';

            $x++;
        }
        elsif ($grid[$y][$x+1] =~ /^(#|0)$/io) {
            if ($grid[$y-1][$x] =~ /^(#|0)$/io) {
                $dir = '<';

                $grid[$y][$x-1] = $dir;
                $grid[$y][$x]   = '.';

                $x--;
            }
            else {
                $dir = 'v';

                $grid[$y-1][$x] = $dir;
                $grid[$y][$x]   = '.';

                $y--;
            }
        }
    }
    elsif ($dir eq 'v') {
        if (($y-1) < 0) {
            ($dir, $y, $x) = resetGrid($dir, $y, $x);

            next;
        }
        elsif ($grid[$y-1][$x] eq '.') {
            $grid[$y-1][$x] = $dir;
            $grid[$y][$x]   = '.';

            $y--;
        }
        elsif ($grid[$y-1][$x] =~ /^(#|0)$/io) {
            if ($grid[$y][$x-1] =~ /^(#|0)$/io) {
                $dir = '^';

                $grid[$y+1][$x] = $dir;
                $grid[$y][$x]   = '.';

                $y++;
            }
            else {
                $dir = '<';

                $grid[$y][$x-1] = $dir;
                $grid[$y][$x]   = '.';

                $x--;
            }
        }
    }
    elsif ($dir eq '<') {
        if (($x-1) < 0) {
            ($dir, $y, $x) = resetGrid($dir, $y, $x);

            next;
        }
        elsif ($grid[$y][$x-1] eq '.') {
            $grid[$y][$x-1] = $dir;
            $grid[$y][$x]   = '.';

            $x--;
        }
        elsif ($grid[$y][$x-1] =~ /^(#|0)$/io) {
            if ($grid[$y+1][$x] =~ /^(#|0)$/io) {
                $dir = '>';

                $grid[$y][$x+1] = $dir;
                $grid[$y][$x]   = '.';

                $x++;
            }
            else {
                $dir = '^';

                $grid[$y+1][$x] = $dir;
                $grid[$y][$x]   = '.';

                $y++;
            }
        }
    }

    $pos{"($y,$x)"}++;

    if ($test_y > ((scalar @grid) - 1)) {
        last;
    }

    # High number of revists is a good
    # indication we're in a loop
    if ($pos{"($y,$x)"} > 1000) {
        $obstruction{"($test_y,$test_x)"} = 1;

        ($dir, $y, $x) = resetGrid($dir, $y, $x);

        next;
    }
}

print "distinct obstructions: |" , scalar keys %obstruction , "|\n";

sub printGrid {
    my ($array) = @_;

    for (my $y = ((scalar @{$array}) - 1); $y >= 0; $y--) {
        printf('%2s', $y);

        for (my $x = 0; $x < scalar @{$array->[$y]}; $x++) {
            if (! defined($array->[$y][$x])) {
                print " ";
            }
            else {
                print $array->[$y][$x];
            }
        }
        print "\n";
    }

    print "  ";
    for (my $x = 0; $x < scalar @{$array->[0]}; $x++) {
        print $x;
    }
    print "\n";

    print "\n";
}

sub resetGrid {
    my ($dir, $y, $x) = @_;

    $dir = '^';
    $grid[$y][$x] = '.';
    $y = $guard_y;
    $x = $guard_x;
    $grid[$y][$x] = $dir;

    %pos = (
        "($guard_y,$guard_x)" => 1,
    );

    $grid[$test_y][$test_x] = '.';
    while (1) {
        if (($test_x+1) > ((scalar @{$grid[$test_y]}) - 1)) {
            $test_y++;
            $test_x = 0;

            if ($test_y > ((scalar @grid) - 1)) {
                last;
            }

            if ($grid[$test_y][$test_x] ne '#') {
                $grid[$test_y][$test_x] = 0;

                last;
            }
        }
        else {
            $test_x++;

            if ($grid[$test_y][$test_x] !~ /^(#|\^)$/) {
                $grid[$test_y][$test_x] = 0;

                last;
            }
        }
    }

    return ($dir, $y, $x);
}

