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

my $safe = 0;

REPORT:
foreach my $line (@input) {
    my $dir = 0;    # 1 = inc; 2 = dec

    my @levels = split(' ', $line);

    for (my $i = 0 ; $i < scalar @levels ; $i++) {
        my $a = $levels[$i];
        my $b = $levels[$i+1];

        last if (! $b);

        if ($a == $b) {
            next REPORT;
        }
        elsif ($a < $b) {
            next REPORT if ($dir && $dir != 1);
            next REPORT if (($b - $a) > 3);

            $dir = 1;
        }
        elsif ($a > $b) {
            next REPORT if ($dir && $dir != 2);
            next REPORT if (($a - $b) > 3);

            $dir = 2;
        }
    }

    $safe++;
}

print "safe: |" , $safe , "|\n";
