#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;
$Data::Dumper::Indent = 0;
use JSON::XS;

my $test = 0;
my $debug = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my $handle = JSON::XS->new();

my @packets = ();

my %hash = ();
foreach my $line (@input) {
    if ($line eq '') {
        push(@packets, {%hash});

        %hash = ();

        next;
    }

    if (! scalar keys %hash) {
        $hash{'left'} = $handle->decode($line);
    }
    else {
        $hash{'right'} = $handle->decode($line);
    }
}
push(@packets, {%hash});

my $indices = 0;
my @all = ();

for (my $i = 0; $i < scalar @packets; $i++) {
    my $left = $packets[$i]->{'left'};
    my $right = $packets[$i]->{'right'};

    if (scalar @{$left} == 0 && scalar @{$right} == 0) {
        print "ERROR, two empty packets\n";
        my $gak = <>;
    }

    push (@all, $left);
    push (@all, $right);

    if ($debug) {
        print Dumper $packets[$i];
        print "\n";
    }

    my $pass = processPacket($left, $right);
    print "\n" if ($debug);

    if ($pass == 1) {
        $indices += ($i+1);
        print "packet ".($i+1)." is in order\n";
    }
    else {
        print "packet ".($i+1)." is not in order\n";
    }

    my $gak = <> if ($debug);
}

print "Indices Sum: $indices\n";

push (@all, [[2]]);
push (@all, [[6]]);

my @sorted = sort { sortPackets($a, $b) || 0 } @all;

my $pos1 = 0;
my $pos2 = 0;

for (my $i = 0; $i < scalar @sorted; $i++) {
    if ($handle->encode($sorted[$i]) eq "[[[[2]]]]") { 
        $pos1 = ($i + 1);
    }
    elsif ($handle->encode($sorted[$i]) eq "[[[[6]]]]") { 
        $pos2 = ($i + 1);
    }
}

print "decoder ($pos1 * $pos2): |" . ($pos1 * $pos2) . "|\n";

sub sortPackets {
    my ($left, $right) = @_;

    return -1 if processPacket($left, $right);   # Is less
    return 1  if processPacket($right, $left);   # Is greater
    return 0;
}

sub processPacket {
    my ($left, $right) = @_;

    my $x;
    for ($x = 0; $x < scalar @{$right}; $x++) {
        # Left ran out first
        if (! defined($left->[$x])) {
            print "left ran out of elements first\n" if ($debug);
            return 1;
        }

        my $left_ref = ref($left->[$x]) || ref(\$left->[$x]);
        my $right_ref = ref($right->[$x]) || ref(\$right->[$x]);

        print "1-comparing L-".$left->[$x]." to R-".$right->[$x]."\n" if ($debug);
        if ($debug) {
            print Dumper $left->[$x];
            print "\n";
            print Dumper $right->[$x];
            print "\n";
        }

        if ( $right_ref eq 'ARRAY' && $left_ref eq 'SCALAR') {
            print "converting L-".$left->[$x]." to an array\n" if ($debug);
            my @array = ();
            push (@array, $left->[$x]);
            $left->[$x] = [@array];
            $x--;
        }
        elsif ($right_ref eq 'SCALAR' && $left_ref eq 'ARRAY') {
            print "converting R-".$right->[$x]." to an array\n" if ($debug);
            my @array = ();
            push (@array, $right->[$x]);
            $right->[$x] = [@array];
            $x--;
        }
        elsif ($right_ref eq 'SCALAR' && $left_ref eq 'SCALAR') {
            print "2-comparing L-".$left->[$x]." to R-".$right->[$x]."\n" if ($debug);
            if ($left->[$x] > $right->[$x]) {
                return 0;
            }
            elsif ($left->[$x] < $right->[$x]) {
                return 1;
            }
        }
        elsif ($right_ref eq 'ARRAY' && $left_ref eq 'ARRAY') {
            print "recursing into arrays\n" if ($debug);
            if ($debug) {
                print "Dumper START\n";
                print Dumper $left->[$x];
                print "\n";
                print Dumper $right->[$x];
                print "\n";
                print "Dumper END\n";
            }
            my $pass = processPacket($left->[$x], $right->[$x]);

            if ($pass ne "" && $pass == 0) {
                print "ending with recursive fail\n" if ($debug);
                return 0;
            }
            elsif ($pass == 1) {
                print "ending with recursive pass\n" if ($debug);
                return 1;
            }
        }
        else {
            print "ERROR unknown ref\n";
            my $gak = <>;
        }
    }

    # Right ran out first
    if (defined($left->[$x])) {
        print "right ran out of elements first\n" if ($debug);
        return 0;
    }
}
