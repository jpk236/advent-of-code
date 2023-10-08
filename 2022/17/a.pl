#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my @shapes = (
    [
        ['@','@','@','@']
    ],
    [
        [undef,'@',undef],
        ['@','@','@'],
        [undef,'@',undef]
    ],
    [
        [undef,undef,'@'],
        [undef,undef,'@'],
        ['@','@','@']
    ],
    [
        ['@'],
        ['@'],
        ['@'],
        ['@']
    ],
    [
        ['@','@'],
        ['@','@']
    ]
);

my $minX = 0;
my $maxX = 7;

#print Dumper \@shapes;
#print "\n";

my @moves = ();
foreach my $line (@input) {
    @moves = split('', $line);
}

my @grid = (
    [undef,undef,undef,undef,undef,undef,undef]
);

my $move_cnt = 0;
my $shape_cnt = 0;
my $total_rocks = 0;
my $height = 0;

ROCK:
while (1) {
    my $shape = $shapes[$shape_cnt];

    my $x_pos = 2;
    my $y_pos = findHighestRock(\@grid);
    $height = $y_pos;

    if ($total_rocks == 2022) {
        last;
    }

    if (($shape_cnt > 0) && $shape_cnt % (scalar(@shapes) - 1) == 0) {
        $shape_cnt = 0;
    }
    else {
        $shape_cnt++;
    }

    for (my $y = $y_pos; $y <= ($y_pos + 3); $y++) {
        if (! defined($grid[$y])) {
            push(@grid, [undef,undef,undef,undef,undef,undef,undef]);
        }
    }

    $total_rocks++;

    my $sY = 0;
    my $sX = 0;
    for (my $y = ($y_pos + (scalar(@{$shape}) - 1) + 3); $y >= ($y_pos + 3); $y--) {
        for (my $x = $x_pos; $x < (scalar @{$shape->[$sY]} + $x_pos); $x++) {
            #if (defined($shape->[$sY]->[$sX])) {
            #    print "\tdrawing \$shape->[$sY]->[$sX] '".$shape->[$sY]->[$sX]."' at ($y,$x)\n";
            #}
            #else {
            #    print "\tdrawing \$shape->[$sY]->[$sX] '.' at ($y,$x)\n";
            #}

            $grid[$y][$x] = $shape->[$sY]->[$sX];

            $sX++;
        }
        $sY++;
        $sX = 0;
    }

    MOVE:
    while (1) {
        my $move = $moves[$move_cnt];

        #print "move = $move\n";

        if (($move_cnt > 0) && $move_cnt % (scalar(@moves) - 1) == 0) {
            $move_cnt = 0;
        }
        else {
            $move_cnt++;
        }

        my $hit_lr = 0;
        my $hit_d = 0;
        if ($move eq '>') {
            $hit_lr = checkBoundaryRight(\@grid, $shape, $y_pos, $x_pos);
            $hit_d = checkBoundaryDown(\@grid, $shape, $y_pos, ($x_pos+1));

            if ($hit_lr == 0) {
                shiftRight(\@grid, $shape, \$y_pos, \$x_pos);
            }
            else {
                $hit_d = checkBoundaryDown(\@grid, $shape, $y_pos, $x_pos);
            }

            if ($hit_d == 0) {
                shiftDown(\@grid, $shape, \$y_pos, \$x_pos);

                next MOVE;
            }
        }
        elsif ($move eq '<') {
            $hit_lr = checkBoundaryLeft(\@grid, $shape, $y_pos, $x_pos);
            $hit_d = checkBoundaryDown(\@grid, $shape, $y_pos, ($x_pos-1));

            if ($hit_lr == 0) {
                shiftLeft(\@grid, $shape, \$y_pos, \$x_pos);
            }
            else {
                $hit_d = checkBoundaryDown(\@grid, $shape, $y_pos, $x_pos);
            }

            if ($hit_d == 0) {
                shiftDown(\@grid, $shape, \$y_pos, \$x_pos);

                next MOVE;
            }
        }

        if ($hit_lr != 0 || $hit_d != 0) {
            settleRock(\@grid, $shape, \$y_pos, \$x_pos);

            next ROCK;
        }

        shiftDown(\@grid, $shape, \$y_pos, \$x_pos);
    }
}

printGrid(\@grid);

print "Height = $height\n";

sub printGrid {
    my ($grid) = @_;

    for (my $y = (scalar(@{$grid}) - 1); $y >= 0; $y--) {
    #for (my $y = (scalar(@{$grid}) - 1); $y >= (scalar(@{$grid}) - 20); $y--) {
        print "|";
        for (my $x = $minX; $x < $maxX; $x++) {
            if (defined($grid->[$y]->[$x])) {
                print $grid->[$y]->[$x];
            }
            else {
                print ".";
            }
        }
        #print "| $y\n";
        print "|\n";
    }
    print "+-------+\n";
}

sub shiftRight {
    my ($grid, $shape, $y_pos, $x_pos) = @_;

    my $sY = 0;
    my $sX = 0;
    for (my $y = (${$y_pos} + (scalar(@{$shape}) - 1) + 3); $y >= (${$y_pos} + 3); $y--) {
        for (my $x = ((scalar @{$shape->[$sY]} - 1) + ${$x_pos}); $x >= ${$x_pos}; $x--) {
            if (defined($grid[$y][$x]) && $grid->[$y]->[$x] eq '@') {
                #print "\tshifting right ($y,$x) -> ($y,".($x+1).")\n";
                $grid->[$y]->[$x+1] = $grid->[$y]->[$x];
                $grid->[$y]->[$x] = undef;
            }
            $sX++;
        }
        $sY++;
        $sX = 0;
    }

    ${$x_pos}++;

    #if ($height > 120) {
    #    print "height = $height\n";
    #    printGrid($grid);
    #    my $gak = <>;
    #}
}

sub shiftLeft {
    my ($grid, $shape, $y_pos, $x_pos) = @_;

    my $sY = 0;
    my $sX = 0;
    for (my $y = (${$y_pos} + (scalar(@{$shape}) - 1) + 3); $y >= (${$y_pos} + 3); $y--) {
        for (my $x = ${$x_pos}; $x <= ((scalar(@{$shape->[$sY]}) - 1) + ${$x_pos}); $x++) {
            if (defined($grid->[$y]->[$x]) && $grid->[$y]->[$x] eq '@') {
                #print "\tshifting left ($y,$x) -> ($y,".($x-1).")\n";
                $grid->[$y]->[$x-1] = $grid->[$y]->[$x];
                $grid->[$y]->[$x] = undef;
            }
            $sX++;
        }
        $sY++;
        $sX = 0;
    }

    ${$x_pos}--;

    #if ($height > 120) {
    #    print "height = $height\n";
    #    printGrid($grid);
    #    my $gak = <>;
    #}
}

sub shiftDown {
    my ($grid, $shape, $y_pos, $x_pos) = @_;

    my $sY = 0;
    my $sX = 0;
    for (my $y = (${$y_pos} + 3); $y <= (${$y_pos} + (scalar(@{$shape}) - 1) + 3); $y++) {
        for (my $x = ${$x_pos}; $x <= ((scalar(@{$shape->[$sY]}) - 1) + ${$x_pos}); $x++) {
            if (defined($grid->[$y]->[$x]) && $grid->[$y]->[$x] eq '@') {
                #print "\tshifting down ($y,$x) -> (".($y-1).",$x)\n";
                $grid->[$y-1]->[$x] = $grid->[$y]->[$x];
                $grid->[$y]->[$x] = undef;
            }
            $sX++;
        }
        $sY++;
        $sX = 0;
    }

    ${$y_pos}--;

    #if ($height > 120) {
    #    print "height = $height\n";
    #    printGrid($grid);
    #    my $gak = <>;
    #}
}

sub checkBoundaryLeft {
    my ($grid, $shape, $y_pos, $x_pos) = @_;

    my $sY = 0;
    my $sX = 0;
    for (my $y = ($y_pos + (scalar(@{$shape}) - 1) + 3); $y >= ($y_pos + 3); $y--) {
        for (my $x = $x_pos; $x <= ((scalar(@{$shape->[$sY]}) - 1) + $x_pos); $x++) {
            #print "\tchecking left boundary ($y,".($x-1).")\n";
            if (defined($shape->[$sY]->[$sX])) {
                if (($x-1) < $minX) {
                    return 1;
                }
                elsif (defined($grid->[$y]->[$x-1]) && $grid->[$y]->[$x-1] ne '@') {
                    return 2;
                }
            }
            $sX++;
        }
        $sY++;
        $sX = 0;
    }

    return 0;
}

sub checkBoundaryRight {
    my ($grid, $shape, $y_pos, $x_pos) = @_;

    my $sY = 0;
    my $sX = scalar(@{$shape->[0]}) - 1;
    for (my $y = ($y_pos + (scalar(@{$shape}) - 1) + 3); $y >= ($y_pos + 3); $y--) {
        for (my $x = ((scalar(@{$shape->[$sY]}) - 1) + $x_pos); $x >= $x_pos; $x--) {
            if (defined($shape->[$sY]->[$sX])) {
                if (($x+1) >= $maxX) {
                    return 1;
                }
                elsif (defined($grid->[$y]->[$x+1]) && $grid->[$y]->[$x+1] ne '@') {
                    return 2;
                }
            }
            $sX--;
        }
        $sY++;
        $sX = scalar(@{$shape->[0]}) - 1;
    }

    return 0;
}

sub checkBoundaryDown {
    my ($grid, $shape, $y_pos, $x_pos) = @_;

    my $sY = scalar(@{$shape}) - 1;
    my $sX = 0;
    for (my $y = ($y_pos + 3); $y <= ($y_pos + (scalar(@{$shape}) - 1) + 3); $y++) {
        for (my $x = $x_pos; $x <= ((scalar(@{$shape->[$sY]}) - 1) + $x_pos); $x++) {
            #print "\tchecking down boundary (".($y-1).",".($x).")\n";
            if (defined($shape->[$sY]->[$sX])) {
                if (($y-1) < 0) {
                    return 1;
                }
                elsif (defined($grid->[$y-1]->[$x]) && $grid->[$y-1]->[$x] ne '@') {
                    return 2;
                }
            }
            $sX++;
        }
        $sY--;
        $sX = 0;
    }

    return 0;
}

sub settleRock {
    my ($grid, $shape, $y_pos, $x_pos) = @_;

    my $sY = 0;
    my $sX = 0;
    for (my $y = (${$y_pos} + (scalar(@{$shape}) - 1) + 3); $y >= (${$y_pos} + 3); $y--) {
        for (my $x = ${$x_pos}; $x <= ((scalar(@{$shape->[$sY]}) - 1) + ${$x_pos}); $x++) {
            #print "\tsettling rock ($y,$x)\n";
            if (defined($grid->[$y]->[$x]) && $grid->[$y]->[$x] eq '@') {
                $grid->[$y]->[$x] = '#';
            }
            $sX++;
        }
        $sY++;
        $sX = 0;
    }

    #if ($height > 120) {
    #    print "height = $height\n";
    #    printGrid($grid);
    #    my $gak = <>;
    #}
}

sub findHighestRock {
    my ($grid) = @_;

    for (my $y = (scalar(@{$grid}) - 1); $y >= 0; $y--) {
        for (my $x = $minX; $x < $maxX; $x++) {
            if (defined($grid->[$y]->[$x])) {
                return ($y+1);
            }
        }
    }

    return 0;
}
