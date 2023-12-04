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

my $total = 0;

foreach my $line (@input) {
    #print "line: |" , $line , "|\n";

    my ($card, $numbers) = split(/\s*:\s*/, $line);

    my ($cardNum, $winning, $num) = $line =~ /^Card\s*(\d+):([^|]+)\|([^\$]+)$/io;
    $winning =~ s/^\s*|\s*$//gio;
    $num =~ s/^\s*|\s*$//gio;

    my @winningNum = split(/\s+/io, $winning);
    my @numWeHave = split(/\s+/io, $num);

    my $match = 0;
    my $subTotal = 0;
    foreach my $win (@winningNum) {
        foreach my $check (@numWeHave) {
            #print "$win == $check?\n";

            if ($win == $check) {
                $match++;

                if ($match == 1) {
                    $subTotal += 1;
                }
                else {
                    $subTotal *= 2;
                }

                last;
            }
        }

        #print "$win subTotal: |" , $subTotal , "|\n";

        #my $gak = <>;
    }

    print "card $cardNum subTotal: |" , $subTotal , "|\n";

    #my $gak = <>;

    $total += $subTotal;
}

print "total: |" , $total , "|\n";

