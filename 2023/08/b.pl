#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Deepcopy = 1;
open STDERR, '>&STDOUT';

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test-b.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my @instructions = split('', $input[0]);
my %network = ();
my %ghosts = ();

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

    if ($node =~ /A$/) {
        $ghosts{$node} = {
            'current' => $node,
        };
    }

    #my $gak = <>;
}

#print Dumper \%ghosts;
#print "\n";

my $steps = 0;
my $end;

do {
    my $instruction = shift(@instructions);
    $end = 1;
    $steps++;

    foreach my $ghost (keys %ghosts) {
        #print "node: |" , $ghost , "|\n";

        $ghosts{$ghost}{'current'} = $network{$ghosts{$ghost}{'current'}}{$instruction};

        #print "instruction: |" , $instruction , "|\n";
        #print "next: |" , $ghosts{$ghost}{'current'} , "|\n";

        if ($ghosts{$ghost}{'current'} !~ /Z$/) {
            $end = 0;
        }
    }

    push (@instructions, $instruction);

    #my $gak = <>;
} until ($end);

print "steps: |" , $steps , "|\n";
