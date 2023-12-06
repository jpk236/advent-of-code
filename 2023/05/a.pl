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

my @seeds = ();
my %mappings = ();

for (my $i = 0 ; $i < scalar @input ; $i++) {
    my $line = $input[$i];

    #print "line: |" , $line , "|\n";

    if ($line =~ /^seeds: /io) {
        @seeds = split(' ', $line);
        shift(@seeds);
    }
    elsif ($line =~ /^(\w+)-to-(\w+) map:/io) {
        my ($src, $dst) = $line =~ /^(\w+)-to-(\w+) map:/io;

        $i++;
        while ($input[$i] !~ /^\s*$/io) {
            #print "line-a: |" , $input[$i] , "|\n";

            my ($start_dst, $start_src, $range) = $input[$i] =~ /^(\d+)\s+(\d+)\s+(\d+)$/io;

            my %row = (
                'start_src' => $start_src,
                'start_dst' => $start_dst,
                'range' => $range,
            );

            push(@{$mappings{$src}{$dst}}, \%row);

            $i++;
        }
    }

    #print Dumper \@seeds;
    #print "\n";
    #print Dumper \%mappings;
    #print "\n";

    #my $gak = <>;
}

#print Dumper \@seeds;
#print "\n";
#print Dumper \%mappings;
#print "\n";

my @locations = ();
foreach my $seed (@seeds) {
    print "seed: |" , $seed , "|\n";

    #seed2soil
    my $soil = findMapping($seed, 'seed', 'soil');
    print "\tsoil: |" , $soil , "|\n";

    #soil2fertilizer
    my $fertilizer = findMapping($soil, 'soil', 'fertilizer');
    print "\tfertilizer: |" , $fertilizer , "|\n";

    #fertilizer2water
    my $water = findMapping($fertilizer, 'fertilizer', 'water');
    print "\twater: |" , $water , "|\n";

    #water2light
    my $light = findMapping($water, 'water', 'light');
    print "\tlight: |" , $light , "|\n";

    #light2temperature
    my $temperature = findMapping($light, 'light', 'temperature');
    print "\ttemperature: |" , $temperature , "|\n";

    #temperature2humidity
    my $humidity = findMapping($temperature, 'temperature', 'humidity');
    print "\thumidity: |" , $humidity , "|\n";

    #humidity2location
    my $location = findMapping($humidity, 'humidity', 'location');
    print "\tlocation: |" , $location , "|\n";

    push (@locations, $location);

    #my $gak = <>;
}

print "lowest location: |" . (sort {$a <=> $b } @locations)[0] . "|\n";

sub findMapping {
    my ($src, $srcKey, $dstKey) = @_;

    my $dst;

    #print Dumper \%mappings;
    #print "\n";

    foreach my $mapping (@{$mappings{$srcKey}{$dstKey}}) {
        my $range   = $mapping->{'range'};
        my $start_src = $mapping->{'start_src'};
        my $start_dst = $mapping->{'start_dst'};
        my $end_src = $start_src + $range;
        my $end_dst = $start_dst + $range;

        #print "range: |" , $range , "|\n";
        #print "start: |" , $start_src , "->" , $end_src , "|\n";
        #print "end: |" , $start_dst , "->" , $end_dst , "|\n";

        my $in = inRange($src, $start_src, ($start_src + $range));
        #print "in: |" , $in , "|\n";

        if ($in) {
            my $offset = ($src - $start_src);
            $dst = $start_dst + $offset;

            last;
        }

        #my $gak = <>;
    }

    if (! $dst) {
        $dst = $src;
    }

    return $dst;
}

sub inRange {
    my ($x, $low, $high) = @_;

    return (($x-$high)*($x-$low) <= 0);
}

