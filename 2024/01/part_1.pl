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

my @left = ();
my @right = ();

foreach my $line (@input) {
    my ($l, $r) = split(/\s+/o, $line);

    push (@left, $l);
    push (@right, $r);
}

@left = sort {$a <=> $b} (@left);
@right = sort {$a <=> $b} (@right);

my $distance = 0;

for (my $i = 0 ; $i < scalar @left ; $i++) {
    $distance += abs($left[$i] - $right[$i]);
}

print "distance: |" , $distance , "|\n";

