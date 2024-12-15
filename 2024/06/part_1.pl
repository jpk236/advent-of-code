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

my $dir = '^';
my %pos = (
    "($y,$x)" => 1,
);

while (1) {
    if ($dir eq '^') {
        if (($y+1) >= (scalar @grid)) {
            last;
        }
        elsif ($grid[$y+1][$x] eq '.') {
            $grid[$y+1][$x] = $dir;
            $grid[$y][$x]   = '.';

            $y++;
        }
        elsif ($grid[$y+1][$x] eq '#') {
            $dir = '>';

            $grid[$y][$x+1] = $dir;
            $grid[$y][$x]   = '.';

            $x++;
        }
    }
    elsif ($dir eq '>') {
        if (($x+1) >= (scalar @{$grid[$y]})) {
            last;
        }
        elsif ($grid[$y][$x+1] eq '.') {
            $grid[$y][$x+1] = $dir;
            $grid[$y][$x]   = '.';

            $x++;
        }
        elsif ($grid[$y][$x+1] eq '#') {
            $dir = 'v';

            $grid[$y-1][$x] = $dir;
            $grid[$y][$x]   = '.';

            $y--;
        }
    }
    elsif ($dir eq 'v') {
        if (($y-1) < 0) {
            last;
        }
        elsif ($grid[$y-1][$x] eq '.') {
            $grid[$y-1][$x] = $dir;
            $grid[$y][$x]   = '.';

            $y--;
        }
        elsif ($grid[$y-1][$x] eq '#') {
            $dir = '<';

            $grid[$y][$x-1] = $dir;
            $grid[$y][$x]   = '.';

            $x--;
        }
    }
    elsif ($dir eq '<') {
        if (($x-1) < 0) {
            last;
        }
        elsif ($grid[$y][$x-1] eq '.') {
            $grid[$y][$x-1] = $dir;
            $grid[$y][$x]   = '.';

            $x--;
        }
        elsif ($grid[$y][$x-1] eq '#') {
            $dir = '^';

            $grid[$y+1][$x] = $dir;
            $grid[$y][$x]   = '.';

            $y++;
        }
    }

    $pos{"($y,$x)"} = 1;
}

print "distinct pos: |" , scalar keys %pos , "|\n";

sub printGrid {
    my ($array) = @_;

    for (my $y = ((scalar @{$array}) - 1); $y >= 0; $y--) {
        printf('%2sy', $y);

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
}
