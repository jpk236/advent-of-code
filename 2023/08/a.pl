#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Deepcopy = 1;
open STDERR, '>&STDOUT';

my $test = 1;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test-1.txt")   if ($test == 1);
open (FILE, "input_test-2.txt")   if ($test == 2);
chomp(my @input = <FILE>);
close (FILE);

foreach my $line (@input) {
    print "line: |" , $line , "|\n";

    my $gak = <>;
}
