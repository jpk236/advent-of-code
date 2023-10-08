#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

#my $test = 1;
#my $inspect = 10;
my $test = 0;
my $inspect = 2000000;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my %grid = ();

foreach my $line (@input) {
    #print "line: |" , $line , "|\n";

    my ($sX, $sY, $bX, $bY) = $line =~ /^Sensor at x=([^,]+), y=([^:]+): closest beacon is at x=([^,]+), y=([^\$]+)$/io;

    if (defined($grid{$sY}{$sX}) && $grid{$sY}{$sX} ne 'B') {
        print "ERROR: something is already here!\n";
        my $gak = <>;
    }
    if (defined($grid{$bY}{$bX}) && $grid{$bY}{$bX} ne 'B') {
        print "ERROR: something is already here!\n";
        my $gak = <>;
    }

    $grid{$bY}{$bX} = 'B';
    $grid{$sY}{$sX} = 'S';

    #my $gak = <>;
}

#print Dumper \%grid;
#print "\n";

my ($minY, $maxY, $minX, $maxX);
#my ($minY, $maxY, $minX, $maxX) = calcMax(\%grid);

#print "minY: |" , $minY , "|\n";
#print "maxY: |" , $maxY , "|\n";
#print "minX: |" , $minX , "|\n";
#print "maxX: |" , $maxX , "|\n";

#printGrid(\%grid);
#print "\n";

foreach my $line (@input) {
    #print "line: |" , $line , "|\n";

    my ($sX, $sY, $bX, $bY) = $line =~ /^Sensor at x=([^,]+), y=([^:]+): closest beacon is at x=([^,]+), y=([^\$]+)$/io;
    #$sY = 7; $bY = 10;
    #$sX = 8; $bX = 2;

    print "working on Sensor ($sY,$sX) & Beacon ($bY,$bX)\n";

    my $radius = 0;

    if ($bY > $sY) {
        my $x = $bX;
        my $y = $bY;
        do {
            $x -= 1 if ($bX <= $sX);
            $x += 1 if ($bX > $sX);
            $y -= 1;
            #$grid{$y}{$x} = '@' if (! defined($grid{$y}{$x}));
        } until ($y <= $sY);
        $radius = abs($sX - $x);
    }
    elsif ($bY < $sY) {
        my $x = $bX;
        my $y = $bY;
        do {
            $x -= 1 if ($bX <= $sX);
            $x += 1 if ($bX > $sX);
            $y += 1;
            #$grid{$y}{$x} = '%' if (! defined($grid{$y}{$x}));
        } until ($y >= $sY);
        $radius = abs($sX - $x);
    }
    elsif ($bY == $sY) {
        $radius = abs($bX - $sX);
    }

    print "Radius = $radius\n";

    (%grid) = fillGrid(\%grid, $sY, $sX, $radius);

    #($minY, $maxY, $minX, $maxX) = calcMax(\%grid);
    #printGrid(\%grid);
    #print "\n";

    #my $gak = <>;
}

#printGrid(\%grid);
#print "\n";

my $cnt = 0;
foreach my $x (keys %{$grid{$inspect}}) {
    #print "$x: ".$grid{$inspect}{$x}."\n";
    if (defined($grid{$inspect}{$x}) && $grid{$inspect}{$x} eq '#') {
        $cnt++;
    }
}

print "Count = $cnt\n";

sub fillGrid {
    my ($grid, $sY, $sX, $radius) = @_;

    my $start = $sX;
    my $diameter = 1;

    for (my $y = ($sY - $radius); $y <= ($sY + $radius); $y++) {
        my $x = $start;

        if ($y == $inspect) {
            for (1..$diameter) {
                #print "drawing '#' at ($y,$x)\n";
                $grid->{$y}->{$x} = '#' if (! defined($grid->{$y}->{$x}));
                $x++;
            }
        }

        if ($y < $sY) {
            $start -= 1;
            $diameter += 2;
        }
        else {
            $start += 1;
            $diameter -= 2;
        }

        #printGrid($grid);
        #print "\n";
        #my $gak = <>;
    }

    return (%{$grid});
}

sub calcMax {
    my ($grid) = @_;

    my $minY = (sort { $a <=> $b } keys %{$grid})[0];
    my $maxY = (sort { $a <=> $b } keys %{$grid})[-1];

    my ($minX, $maxX) = (0,0);
    foreach my $y (keys %{$grid}) {
        my $tmp_minX = (sort { $a <=> $b } keys %{$grid->{$y}})[0];
        my $tmp_maxX = (sort { $a <=> $b } keys %{$grid->{$y}})[-1];

        $minX = $tmp_minX if (defined($tmp_minX) && $tmp_minX < $minX);
        $maxX = $tmp_maxX if (defined($tmp_maxX) && $tmp_maxX > $maxX);
    }

    return ($minY, $maxY, $minX, $maxX);
}

sub printGrid {
    my ($grid) = @_;

    for (my $y = $minY; $y <= $maxY; $y++) {
        printf('%3d ', $y);
        for (my $x = $minX; $x <= $maxX; $x++) {
            if (defined($grid->{$y}->{$x})) {
                print $grid->{$y}->{$x};
            }
            else {
                print ".";
            }
        }
        print "\n";
    }
}
