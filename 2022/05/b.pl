#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my @inventory = ();

foreach my $line (@input) {
    if ($line =~ /^ \d   \d/io) {
        last;
    }

    my (@chars) = split('', $line);

    my $crate = '';

    my $stack = 1;
    for (my $i = 1; $i <= scalar @chars; $i++) {
        $crate .= $chars[$i-1];

        if ($i != 0 && $i % 4 == 0) {
            $crate =~ s/\s|\[|\]//gio;

            if ($crate ne "") {
                unshift (@{$inventory[$stack]}, $crate);
            }

            $crate = '';
            $stack++;
        }
    }

    # Store the last stack
    $crate =~ s/\s|\[|\]//gio;
    if ($crate ne "") {
        unshift (@{$inventory[$stack]}, $crate);
    }
}

printGrid(\@inventory);
print "\n";

foreach my $line (@input) {
    next if ($line !~ /^move /io);
    
    print $line , "|\n";

    my ($qty, $src, $dst) = $line =~ /^move (\d+) from (\d+) to (\d+)$/io;

    my @bulk = ();
    foreach (1..$qty) {
        unshift(@bulk, pop(@{$inventory[$src]}));
    }

    push(@{$inventory[$dst]}, @bulk);

    printGrid(\@inventory);
}

my $code = "";

for (my $i = 1; $i < scalar @inventory; $i++) {
    $code .= $inventory[$i][-1];
}

print "Code: |" , $code , "|\n";

sub printGrid {
    my ($array) = @_;

    my @inventory = @{$array};

    #for (my $y = ((scalar @inventory) - 1); $y >= 0; $y--) {
    for (my $y = 1; $y < scalar @inventory; $y++) {
        print " " . $y . "\t=";
        for (my $x = 0; $x < scalar @{$inventory[$y]}; $x++) {
            if (! defined($inventory[$y][$x])) {
                print "  ";
            }
            elsif ($inventory[$y][$x] eq '') {
                print "  ";
            }
            else {
                print $inventory[$y][$x] . " ";
            }
        }
        print "\n";
    }
}
