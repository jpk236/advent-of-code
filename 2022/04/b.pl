#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my $totalFull = 0;
my $totalAny = 0;

foreach my $line (@input) {
    #print "line: |" , $line , "|\n";

    my ($elf1, $elf2) = split(',', $line);

    my ($elf1start, $elf1end) = split('-', $elf1);
    my ($elf2start, $elf2end) = split('-', $elf2);

    my %elf1sections = ();
    my %elf2sections = ();

    foreach my $section ($elf1start .. $elf1end) {
        $elf1sections{$section} = 1;
    }

    foreach my $section ($elf2start .. $elf2end) {
        $elf2sections{$section} = 1;
    }

    my $elf1NumSections = scalar keys %elf1sections;
    my $elf2NumSections = scalar keys %elf2sections;

    my $overlapFound = 0;

    if ($elf2NumSections > $elf1NumSections) {
        foreach my $section (keys %elf2sections) {
            if (exists($elf1sections{$section})) {
                $overlapFound = 1;
                delete($elf1sections{$section});
            }
        }
    
        $elf1NumSections = scalar keys %elf1sections;

        if ($elf1NumSections == 0) {
            $totalFull++;
        }
    }
    else {
        foreach my $section (keys %elf1sections) {
            if (exists($elf2sections{$section})) {
                $overlapFound = 1;
                delete($elf2sections{$section});
            }
        }
    
        $elf2NumSections = scalar keys %elf2sections;

        if ($elf2NumSections == 0) {
            $totalFull++;
        }
    }

    if ($overlapFound == 1) {
        $totalAny++;
    }
    
    #my $gak = <>;
}

print "Total Full = $totalFull\n";
print "Total Any = $totalAny\n";

