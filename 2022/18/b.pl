#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 1;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my @plot = ();

foreach my $line (@input) {
    my ($x, $y, $z) = split(',', $line);

    # Need to +1 to ensure we count the first & end sides
    $x++;
    $y++;
    $z++;
    #print "x: |" , $x , "|\n";
    #print "y: |" , $y , "|\n";
    #print "z: |" , $z , "|\n";

    $plot[$y][$x][$z] = "#";

    #my $gak = <>;
}

#print Dumper \@plot;
#print "\n";

my $maxY = 0;
my $maxX = 0;
my $maxZ = 0;
for (my $y = 0; $y < scalar @plot; $y++) {
    if (defined($plot[$y])) {
        for (my $x = 0; $x < scalar @{$plot[$y]}; $x++) {
            if (defined($plot[$y][$x])) {
                for (my $z = 0; $z < scalar @{$plot[$y][$x]}; $z++) {
                    if (defined($plot[$y][$x][$z])) {
                        $maxY = $y if ($y > $maxY);
                        $maxX = $x if ($x > $maxX);
                        $maxZ = $z if ($z > $maxZ);
                    }
                }
            }
        }
    }
}
$maxY++;
$maxX++;
$maxZ++;

print "maxY: |" , $maxY , "|\n";
print "maxX: |" , $maxX , "|\n";
print "maxZ: |" , $maxZ , "|\n";

my $cnt = 0;
for (my $y = 0; $y <= $maxY; $y++) {
    for (my $x = 0; $x <= $maxX; $x++) {
        for (my $z = 0; $z <= $maxZ; $z++) {
            if (! defined($plot[$y][$x][$z])) {
                next if (
                    defined($plot[$y+1][$x][$z]) &&
                    defined($plot[$y-1][$x][$z]) &&
                    defined($plot[$y][$x+1][$z]) &&
                    defined($plot[$y][$x-1][$z]) &&
                    defined($plot[$y][$x][$z+1]) &&
                    defined($plot[$y][$x][$z-1])
                );

                print "working on ($y,$x,$z) = |".($plot[$y][$x][$z] || '')."|";

                $plot[$y][$x][$z] = '@';

                $cnt++ if (
                    (defined($plot[$y+1][$x][$z]) && $plot[$y+1][$x][$z] eq '#') ||
                    (defined($plot[$y-1][$x][$z]) && $plot[$y-1][$x][$z] eq '#') ||
                    (defined($plot[$y][$x+1][$z]) && $plot[$y][$x+1][$z] eq '#') ||
                    (defined($plot[$y][$x-1][$z]) && $plot[$y][$x-1][$z] eq '#') ||
                    (defined($plot[$y][$x][$z+1]) && $plot[$y][$x][$z+1] eq '#') ||
                    (defined($plot[$y][$x][$z-1]) && $plot[$y][$x][$z-1] eq '#')
                );

                print "\t cnt: |" , $cnt , "|\n";
            }
        }
    }
}

for (my $y = 0; $y <= $maxY; $y++) {
    for (my $x = 0; $x <= $maxX; $x++) {
        for (my $z = 0; $z <= $maxZ; $z++) {
            print "\$grid[$y][$x][$z]: |" . ($plot[$y][$x][$z] || '') . "|\n";
        }
    }
}

print "cnt: |" , $cnt , "|\n";
