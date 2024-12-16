#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;
use POSIX;

$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Deepcopy = 1;
open STDERR, '>&STDOUT';

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my @operators = ('+','*');
my $total = 0;

CALIBRATION:
foreach my $line (@input) {
    my ($goal, $lineNumbers) = $line =~ /^(\d+): (.*)$/io;

    my %permutations = ();

    my $cnt = 0;
    my $lineTotal = 0;

    $lineNumbers =~ s/ / X /go;

    # Find number of permutations
    while (1) {
        my $test = $lineNumbers;

        while ($test =~ /X/io) {
            my $random = $operators[floor(rand(scalar(@operators)))];

            $test =~ s/X/$random/;
        };

        if (! exists($permutations{"$test"})) {
            $permutations{"$test"} = 1;

            $cnt = 0;
        }
        else {
            $cnt++;
        }

        if ($cnt > 100000) {
            last;
        }
    }

    foreach my $equation (reverse sort keys %permutations) {
        my (@numbers) = split(' ', $equation);

        my $operator = '';
        my $result = 0;

        for (my $i = 0 ; $i < scalar @numbers ; $i++) {
            my ($index) = grep { $operators[$_] eq $numbers[$i] } 0 .. $#operators;

            if (defined($index)) {
                $operator = $operators[$index];

                next;
            }

            next if (! $operator);

            if ($result == 0) {
                $result = eval("$numbers[$i-2] $operator $numbers[$i]");
            }
            else {
                $result = eval("$result $operator $numbers[$i]");
            }
        }

        if ($result == $goal) {
            $total += $goal;

            next CALIBRATION;
        }
    }
}

print "total: |" , $total , "|\n";
