#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

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

my $cnt = 0;
for (my $y = 0; $y < scalar @plot; $y++) {
    if (defined($plot[$y])) {
        for (my $x = 0; $x < scalar @{$plot[$y]}; $x++) {
            if (defined($plot[$y][$x])) {
                for (my $z = 0; $z < scalar @{$plot[$y][$x]}; $z++) {
                    #print "\$plot[$y][$x][$z]: |" . ($plot[$y][$x][$z] || '') . "|\n";
                    if (defined($plot[$y][$x][$z])) {
                        if (! defined($plot[$y+1][$x][$z])) {
                            $cnt++;
                        }
                        if (! defined($plot[$y-1][$x][$z])) {
                            $cnt++;
                        }
                        if (! defined($plot[$y][$x+1][$z])) {
                            $cnt++;
                        }
                        if (! defined($plot[$y][$x-1][$z])) {
                            $cnt++;
                        }
                        if (! defined($plot[$y][$x][$z+1])) {
                            $cnt++;
                        }
                        if (! defined($plot[$y][$x][$z-1])) {
                            $cnt++;
                        }
                    }
                }
            }
        }
    }
}

print "cnt: |" , $cnt , "|\n";
