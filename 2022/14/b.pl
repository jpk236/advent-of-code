#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;
$Data::Dumper::Sortkeys = 1;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my @lines = ();
foreach my $line (@input) {
    my (@cords) = split(' -> ', $line);
    
    for (my $i = 0; $i < (scalar(@cords) - 1); $i++) {
        my %hash = (
            'start' => $cords[$i],
            'end'   => $cords[$i+1],
        );
        push(@lines, {%hash});
    }
}

my @grid = ();
$grid[0][500] = '+';
foreach my $line (@lines) {
    my $start = $line->{'start'};
    my $end = $line->{'end'};

    my ($startX, $startY) = split(',', $start);
    my ($endX, $endY) = split(',', $end);

    if ($startY == $endY) {
        my $y = $startY;

        if ($startX >= $endX) {
            for (my $x = $endX; $x <= $startX; $x++) {
                $grid[$y][$x] = '#';
            }
        }
        else {
            for (my $x = $startX; $x <= $endX; $x++) {
                $grid[$y][$x] = '#';
            }
        }
    }
    elsif ($startX == $endX) {
        my $x = $startX;

        if ($startY >= $endY) {
            for (my $y = $endY; $y <= $startY; $y++) {
                $grid[$y][$x] = '#';
            }
        }
        else {
            for (my $y = $startY; $y <= $endY; $y++) {
                $grid[$y][$x] = '#';
            }
        }
    }
    else {
        for (my $y = $startY; $y <= $endY; $y++) {
            for (my $x = $startX; $x <= $endX; $x++) {
                $grid[$y][$x] = '#';
            }
        }
    }
}

# Shrink & Size Grid
OUTER:
while (1) {
    for (my $y = 0; $y < scalar @grid; $y++) {
        if (defined($grid[$y][0])) {
            last OUTER;
        }
    }

    for (my $y = 0; $y < scalar @grid; $y++) {
        shift @{$grid[$y]};
    }
}

my $maxY = scalar @grid;
my $maxX = 0;
my $sandX = 0;
my $sandY = 0;
for (my $y = 0; $y < scalar @grid; $y++) {
    $maxX = scalar @{$grid[$y]} if (scalar @{$grid[$y]} > $maxX);

    for (my $x = 0; $x < scalar @{$grid[$y]}; $x++) {
        if (defined($grid[$y][$x]) && $grid[$y][$x] eq '+') {
            $sandX = $x;
            $sandY = $y;
        }
    }
}

for (my $x = 0; $x < $maxX; $x++) {
    $grid[$maxY][$x] = undef;
    $grid[$maxY+1][$x] = '#';
}
$maxY = scalar @grid;

# Falling Sand
my $y = $sandY;
my $x = $sandX;
my $sand = 0;
while (1) {
    if (($x-1) == -1) {
        for (my $y = 0; $y < scalar @grid; $y++) {
            unshift(@{$grid[$y]}, undef);
            unshift(@{$grid[$y]}, undef);
        }
        $grid[scalar(@grid)-1][0] = '#';
        $grid[scalar(@grid)-1][1] = '#';
        $maxX += 2;
        $sandX += 2;
        $x += 1;
    }
    elsif (($x+1) >= $maxX) {
        $grid[scalar(@grid)-1][$maxX++] = '#';
        $grid[scalar(@grid)-1][$maxX++] = '#';
    }

    if (! defined($grid[$y+1][$x])) {
        $grid[$y][$x] = undef if (defined($grid[$y][$x]) && $grid[$y][$x] ne '+');
        $grid[$y+1][$x] = 'o';
        $y += 1;
    }
    elsif (defined($grid[$y+1][$x]) && (! defined($grid[$y+1][$x-1]))) {
        $grid[$y][$x] = undef if (defined($grid[$y][$x]) && $grid[$y][$x] ne '+');
        $grid[$y+1][$x] = 'o';
        $grid[$y+1][$x-1] = 'o';
        $y += 1;
        $x -= 1;
    }
    elsif (defined($grid[$y+1][$x]) && (! defined($grid[$y+1][$x+1]))) {
        $grid[$y][$x] = undef if (defined($grid[$y][$x]) && $grid[$y][$x] ne '+');
        $grid[$y+1][$x+1] = 'o';
        $y += 1;
        $x += 1;
    }
    else {
        my $tmpX = $x;
        my $tmpY = $y;
        $sand++;
        $y = $sandY;
        $x = $sandX;
        if ($x == $tmpX && $y == $tmpY) {
            last;
        }
    }
}

printGrid(\@grid);
print "Sand: $sand\n";

sub printGrid {
    my ($grid) = @_;

    for (my $y = 0; $y < scalar @{$grid}; $y++) {
        for (my $x = 0; $x < $maxX; $x++) {
            if (defined($grid[$y][$x])) {
                print $grid[$y][$x];
            }
            else {
                print ".";
            }
        }
        print "\n";
    }
}
