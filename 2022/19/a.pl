#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 1;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my @blueprints = ();

# load blueprints
foreach my $line (@input) {
    #print "line: |" , $line , "|\n";

    my ($id, $ore_r_ore, $clay_r_ore, $obsidian_r_ore, $obsidian_r_clay, $geode_r_ore, $geode_r_obsidian) = $line =~ /^Blueprint (\d+): Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian\.$/io;

    print "id: |" , $id , "|\n";
    print "ore_r_ore: |" , $ore_r_ore , "|\n";
    print "clay_r_ore: |" , $clay_r_ore , "|\n";
    print "obsidian_r_ore: |" , $obsidian_r_ore , "|\n";
    print "obsidian_r_clay: |" , $obsidian_r_clay , "|\n";
    print "geode_r_ore: |" , $geode_r_ore , "|\n";
    print "geode_r_obsidian: |" , $geode_r_obsidian , "|\n";

    my %hash = (
        'ore_robot_cost' => {
            'ore' => $ore_r_ore,
            'clay' => 0,
            'obsidian' => 0,
        },
        'clay_robot_cost' => {
            'ore' => $clay_r_ore,
            'clay' => 0,
            'obsidian' => 0,
        },
        'obsidian_robot_cost' => {
            'ore' => $obsidian_r_ore,
            'clay' => $obsidian_r_clay,
            'obsidian' => 0,
        },
        'geode_robot_cost' => {
            'ore' => $geode_r_ore,
            'clay' => 0,
            'obsidian' => $geode_r_obsidian,
        },
    );

    push(@blueprints, \%hash);

    my $gak = <>;
}

print Dumper \@blueprints;
print "\n";

my %blueprint_geodes = ();

foreach my $blueprint (@blueprints) {
    my $ore_r = 1;
    my $clay_r = 0;
    my $obsidian_r = 0;

    my $ore = 0;
    my $clay = 0;
    my $obsidian = 0;

    foreach my $minute (1..24) {
        # spend to build
        
        # collect
        
        # finish build
    }
}

