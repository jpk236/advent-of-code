#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test_b.txt") if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my @alpha = (
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
);

foreach my $line (@input) {
    my ($name, $id, $sum) = $line =~ /^([^\d]+)(\d+)\[(\w+)\]/io;
    chop($name);
    
    my %letters = ();
    foreach my $letter (split('', $name)) {
        if ($letter ne '-') {
            $letters{$letter}++;
        }
    }

    my %grouping = ();
    foreach my $letter (keys %letters) {
        push(@{$grouping{$letters{$letter}}}, $letter);
    }

    my @code = ();
    foreach my $group (sort { $b <=> $a } keys %grouping) {
        foreach my $letter (sort @{$grouping{$group}}) {
            push(@code, $letter);
        }
    }

    my $check = join('',@code[0..4]);

    if ($check eq $sum) {
        my $offset = $id - (int($id / 26) * 26);

        my @decrypted = ();
        foreach my $letter (split('', $name)) {
            if ($letter eq '-') {
                push (@decrypted, ' ');
            }
            else {
                my $pos = 0;
                for (my $i = 0; $i < scalar @alpha; $i++) {
                    if ($alpha[$i] eq $letter) {
                        $pos = $i;
                        last;
                    }
                }

                push(@decrypted, $alpha[($pos + $offset) - 26]);
            }

            #my $gak = <>;
        }

        print "$id: ".join('', @decrypted) . "\n";

        #my $gak = <>;
    }
}
