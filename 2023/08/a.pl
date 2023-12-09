#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Deepcopy = 1;
open STDERR, '>&STDOUT';

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test-1.txt")   if ($test == 1);
open (FILE, "input_test-2.txt")   if ($test == 2);
chomp(my @input = <FILE>);
close (FILE);

my @instructions = split('', $input[0]);
my %network = ();
my @network = ();

for (my $i = 2; $i < scalar @input ; $i++) {
    #print "line: |" , $input[$i] , "|\n";

    my ($node, $L, $R) = $input[$i] =~ /^(\w+) = \((\w+), (\w+)\)$/io;

    $network{$node} = {
        'node' => $node,
        'L' => $L,
        'R' => $R,
    };
    #print Dumper \%network;
    #print "\n";

    #my $gak = <>;
}

my $current = 'AAA';
my $steps = 0;

do {
    my $instruction = shift(@instructions);

    #print "node: |" , $current , "|\n";

    $current = $network{$current}{$instruction};
    $steps++;

    #print "instruction: |" , $instruction , "|\n";
    #print "next: |" , $current , "|\n";

    push (@instructions, $instruction);

    #my $gak = <>;
} until ($current eq 'ZZZ');

print "steps: |" , $steps , "|\n";
