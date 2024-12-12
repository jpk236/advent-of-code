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

my @rules = ();
my @updates = ();

foreach my $line (@input) {
    next if ($line eq '');

    if ($line =~ /^(\d+)\|(\d+)$/io) {
        my ($pg1, $pg2) = $line =~ /^(\d+)\|(\d+)$/io;

        my @rule = ($pg1, $pg2);

        push (@rules, \@rule);
    }
    else {
        my @update = split(',', $line);

        push(@updates, \@update);
    }
}

my $total = 0;

UPDATE:
foreach (@updates) {
    my @update = @{$_};

    foreach my $rule (@rules) {
        my $pg1 = $rule->[0]; 
        my $pg2 = $rule->[1]; 

        my ($pg1_pos) = grep { $update[$_] == $pg1 } (0 .. @update-1);
        my ($pg2_pos) = grep { $update[$_] == $pg2 } (0 .. @update-1);

        $pg1_pos++ if (defined($pg1_pos));
        $pg2_pos++ if (defined($pg2_pos));

        if ($pg1_pos && $pg2_pos) {
            if ($pg1_pos > $pg2_pos) {
                next UPDATE;
            }
        }
    }

    my $middle = floor((scalar @update) / 2);

    $total += $update[$middle];
}

print "total: |" , $total , "|\n";
