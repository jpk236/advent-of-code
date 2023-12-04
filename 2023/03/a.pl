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

my @schematic = ();

for (my $y = 0 ; $y < scalar @input; $y++) {
    #print "line: |" , $input[$y] , "|\n";

    my @chars = split('', $input[$y]);

    #print "length: |" . scalar @chars . "|\n";

    my $start = undef;
    my $end = undef;

    for (my $x = 0 ; $x < scalar @chars; $x++) {
        #print "x: |" , $x , "|\n";
        #print "char: |" , $chars[$x] , "|\n";

        if (! defined $start && $chars[$x] =~ /^\d+$/io) {
            $start = $x;
            #print "setting start: $start\n";
        }
        elsif (($x+1) == scalar @chars) {
            if (defined $start) {
                $end = $x;
                #print "setting end: $end\n";

                # Add identified part# on previous indexes
                #print "start: |" , $start , "|\n";
                #print "end: |" , $end , "|\n";

                for ($start..$end) {
                    my %part = (
                        'start' => $start,
                        'end' => $end,
                        'type' => 'part',
                        'val' => $chars[$_],
                        'partNum' => join('', @chars[$start..$end]),
                    );

                    push (@{$schematic[$y]}, \%part);
                }

                $start = undef;
                $end = undef;
            }
        }
        elsif ($chars[$x] !~ /^\d+$/io) {
            if (defined $start) {
                $end = $x-1;
                #print "setting end: $end\n";

                # Add identified part# on previous indexes
                #print "start: |" , $start , "|\n";
                #print "end: |" , $end , "|\n";

                for ($start..$end) {
                    my %part = (
                        'start' => $start,
                        'end' => $end,
                        'type' => 'part',
                        'val' => $chars[$_],
                        'partNum' => join('', @chars[$start..$end]),
                    );

                    push (@{$schematic[$y]}, \%part);
                }

                $start = undef;
                $end = undef;
            }

            # Add sym on current index
            my %sym = (
                'start' => $x,
                'end' => $x,
                'type' => ($chars[$x] eq '.') ? 'skip' : 'sym',
                'val' => $chars[$x],
                'partNum' => undef,
            );
            push (@{$schematic[$y]}, \%sym);
        }

        #print Dumper \@schematic;
        #print "\n";

        #my $gak = <>;
    }

    #print Dumper \@schematic;
    #print "\n";

    #my $gak = <>;
}

my $total = 0;

for (my $y = 0 ; $y < scalar @schematic; $y++) {
    #print "line-[".($y-1)."]-before: |" , $input[$y-1] , "|\n" if ($y != 0);
    #print "line-[".($y)."]-target: |" , $input[$y] , "|\n";
    #print "line-[".($y+1)."]-after : |" , $input[$y+1] , "|\n" if (defined $input[$y+1]);

    for (my $x = 0 ; $x < scalar @{$schematic[$y]}; $x++) {
        #print "line-[".($y-1)."]-before: |" , $input[$y-1] , "|\n" if ($y != 0);
        #print "line-[".($y)."]-target: |" , $input[$y] , "|\n";
        #print "line-[".($y+1)."]-after : |" , $input[$y+1] , "|\n" if (defined $input[$y+1]);

        #print Dumper \%{$schematic[$y][$x]};
        #print "\n";

        if ($schematic[$y][$x]->{'type'} eq 'part') {
            # Search perimeter for symbols
            INSPECT:
            for (my $py = $y-1 ; $py <= $y+1; $py++) {
                next if ($py < 0);
                next if ($py >= scalar @schematic);

                for (my $px = ($schematic[$y][$x]->{'start'}-1) ; $px <= ($schematic[$y][$x]->{'end'}+1); $px++) {
                    next if ($px < 0);
                    next if ($px >= scalar @{$schematic[$y]});

                    #print "inspect[$py,$px]: \n";
                    #print Dumper \%{$schematic[$py][$px]};
                    #print "\n";

                    if ($schematic[$py][$px]->{'type'} eq 'sym') {
                        $total += $schematic[$y][$x]->{'partNum'};

                        #print "symbol ".$schematic[$py][$px]->{'val'}." found on ". $schematic[$y][$x]->{'partNum'} ."'s perimeter at [$py,$px] \t total = $total\n";

                        last INSPECT;
                    }

                    #my $gak = <>;
                }
            }

            # Skip ahead to next component
            $x = $schematic[$y][$x]->{'end'};
        }

        #my $gak = <>;
    }

    #my $gak = <>;
}

print "total: |" , $total , "|\n";
