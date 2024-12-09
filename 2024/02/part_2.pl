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
    my @levels = split(' ', $line);

    my $status = check(\@levels);

    if ($status) {
        $safe++;
    }
    else {
        my $x = scalar @levels;
        $x--;

        while ($x >= 0) {
            my @tmp = ();

            for (my $i = 0 ; $i < scalar @levels ; $i++) {
                if ($x != $i) {
                    push (@tmp, $levels[$i]);
                }
            }

            my $status = check(\@tmp);

            if ($status) {
                $safe++;

                next REPORT;
            }

            $x--;
        }
    }
}

print "safe: |" , $safe , "|\n";

sub check {
    my ($levels) = @_;

    my $dir = 0;    # 1 = inc; 2 = dec

    for (my $i = 0 ; $i < scalar @{$levels} ; $i++) {
        my $a = $levels->[$i];
        my $b = $levels->[$i+1];

        last if (! $b);

        if ($a == $b) {
            return 0;
        }
        elsif ($a < $b) {
            return 0 if ($dir && $dir != 1);
            return 0 if (($b - $a) > 3);

            $dir = 1;
        }
        elsif ($a > $b) {
            return 0 if ($dir && $dir != 2);
            return 0 if (($a - $b) > 3);

            $dir = 2;
        }
    }

    return 1;
}
