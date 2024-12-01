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
    #print "line: |" , $line , "|\n";

    my ($l, $r) = split('   ', $line);

    #print "l: |" , $l , "|\n";
    #print "r: |" , $r , "|\n";

    push (@left, $l);
    push (@right, $r);

    #my $gak = <>;
}

@left = sort {$a <=> $b} (@left);
@right = sort {$a <=> $b} (@right);

#print Dumper \@left;
#print "\n";

#print Dumper \@right;
#print "\n";

my $distance = 0;

for (my $i = 0 ; $i < scalar @left ; $i++) {
    #print "l: |" , $left[$i] , "|\n";
    #print "r: |" , $right[$i] , "|\n";
    #print "diff: |" , abs($left[$i] - $right[$i]) , "|\n";

    $distance += abs($left[$i] - $right[$i]);

    #my $gak = <>;
}

print "distance: |" , $distance , "|\n";

