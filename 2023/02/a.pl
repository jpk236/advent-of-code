#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 1;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

foreach my $line (@input) {

}
