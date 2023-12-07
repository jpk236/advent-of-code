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

my %races = ();
my @durations = (); # milliseconds
my @records = ();   # millimeters

foreach my $line (@input) {
    #print "line: |" , $line , "|\n";

    if ($line =~ /^Time: /io) {
        @durations = split(/\s+/, $line);
        shift(@durations);
    }
    elsif ($line =~ /^Distance: /io) {
        @records = split(/\s+/, $line);
        shift(@records);
    }
}

for (my $i = 0 ; $i < scalar @durations ; $i++) {
    $races{$i+1} = {
        'duration' => $durations[$i],
        'record' => $records[$i],
    };
}

#print Dumper \%races;
#print "\n";

foreach my $race (sort { $a <=> $b } keys %races) {
    my $duration = $races{$race}{'duration'}; # milliseconds
    my $record = $races{$race}{'record'};     # millimeters
    my @winners = ();

    #print "race: |" , $race , "|\n";
    #print "duration: |" , $duration , "|\n";
    #print "record: |" , $record , "|\n";
    #print "\n";

    for (my $charge = 0 ; $charge <= $duration ; $charge++) {
        my $speed = $charge;  # mm/ms
        my $distance = 0;

        #print "charge: |" , $charge , "|\n";
        #print "speed: |" , $speed , "|\n";
        #print "\n";

        for (($charge+1)..$duration) {
            $distance += $speed;

            #print "turn: |" , $_ , "| \t |" , $distance , "|\n";
        }

        #print "distance: |" , $distance , "|\n";

        if ($distance > $record) {
            push (@{$races{$race}{'winners'}}, $charge);
        }

        #my $gak = <>;
    }

    #print Dumper \%races;
    #print "\n";
}

my $errorMargin = 1;

foreach my $race (sort { $a <=> $b } keys %races) {
    my @winners = @{$races{$race}{'winners'}};

    #print Dumper \@winners;
    #print "\n";

    $errorMargin *= scalar @winners;

    #my $gak = <>;
}

print "errorMargin: |" , $errorMargin , "|\n";

