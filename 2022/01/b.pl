#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

open (FILE, "input.txt");
chomp(my @input = <FILE>);
close (FILE);

my %elves = ();
my $numElf = 1;

foreach my $line (@input) {
    if ($line eq '') {
        $numElf++;
        next;
    }

    $elves{$numElf} += $line;
}

my $max = 0;
foreach my $elf (sort keys %elves) {
    my $calories = $elves{$elf};

    if ($calories >= $max) {
        $max = $calories;

        print "Elf #$elf has the most calories with $calories\n";
    }
}

my $stop = 3;
my $i = 0;
my $total = 0;
foreach my $elf (sort { $elves{$b} <=> $elves{$a} } keys %elves) {
    my $calories = $elves{$elf};

    printf "%s %s\n", $elf, $calories;

    $total += $calories;
    $i++;

    last if ($i == $stop);
}

print "Total = $total\n";
