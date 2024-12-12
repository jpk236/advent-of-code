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
chomp(my @input = <FILE>);
close (FILE);

my @lines = ();

foreach my $line (@input) {
    my @x = ();
    @x = split('', $line);

    push (@lines, \@x);
}

my $xmas = 0;

for (my $y = 0 ; $y < scalar @lines; $y++) {
    for (my $x = 0 ; $x < scalar @{$lines[$y]}; $x++) {
        if ($lines[$y][$x] eq 'A') {
            if (defined($lines[$y+1][$x-1]) && (($x-1) >= 0) && $lines[$y+1][$x-1] eq 'M') {
                if (defined($lines[$y-1][$x+1]) && (($y-1) >= 0) && $lines[$y-1][$x+1] eq 'S') {
                    if (
                        (defined($lines[$y+1][$x+1]) && $lines[$y+1][$x+1] eq 'M')
                        && (defined($lines[$y-1][$x-1]) && (($y-1) >= 0) && (($x-1) >= 0) && $lines[$y-1][$x-1] eq 'S')
                    ) {
                        $xmas++;
                    }
                    elsif (
                        (defined($lines[$y+1][$x+1]) && $lines[$y+1][$x+1] eq 'S')
                        && (defined($lines[$y-1][$x-1]) && (($y-1) >= 0) && (($x-1) >= 0) && $lines[$y-1][$x-1] eq 'M')
                    ) {
                        $xmas++;

                    }
                }
            }
            elsif (defined($lines[$y+1][$x-1]) && (($x-1) >= 0) && $lines[$y+1][$x-1] eq 'S') {
                if (defined($lines[$y-1][$x+1]) && (($y-1) >= 0) && $lines[$y-1][$x+1] eq 'M') {
                    if (
                        (defined($lines[$y+1][$x+1]) && $lines[$y+1][$x+1] eq 'S')
                        && (defined($lines[$y-1][$x-1]) && (($y-1) >= 0) && (($x-1) >= 0) && $lines[$y-1][$x-1] eq 'M')
                    ) {
                        $xmas++;

                    }
                    elsif (
                        (defined($lines[$y+1][$x+1]) && $lines[$y+1][$x+1] eq 'M')
                        && (defined($lines[$y-1][$x-1]) && (($y-1) >= 0) && (($x-1) >= 0) && $lines[$y-1][$x-1] eq 'S')
                    ) {
                        $xmas++;

                    }
                }
            }
        }
    }
}

print "xmas: |" , $xmas , "|\n";
