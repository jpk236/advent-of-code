#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test_b.txt") if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my $possible = 0;

my @triangles = ();

# Repack
my @t1 = ();
my @t2 = ();
my @t3 = ();
for (my $i = 0; $i < scalar @input; $i++) {
    #print "\$input[$i]: |".$input[$i]."|\n";
    my ($s1, $s2, $s3) = $input[$i] =~ /^\s+?(\d+)\s+(\d+)\s+(\d+)$/io; 

    push (@t1, $s1);
    push (@t2, $s2);
    push (@t3, $s3);

    #print Dumper \@t1;
    #print "\n";
    #print Dumper \@t2;
    #print "\n";
    #print Dumper \@t3;
    #print "\n";

    if (($i+1) % 3 == 0) {
        push(@triangles, join(" ", @t1));
        push(@triangles, join(" ", @t2));
        push(@triangles, join(" ", @t3));

        #print Dumper \@triangles;
        #print "\n";

        @t1 = ();
        @t2 = ();
        @t3 = ();
    }

    #my $gak = <>;
}

#print Dumper \@triangles;
#print "\n";

foreach my $triangle (@triangles) {
    my ($s1, $s2, $s3) = $triangle =~ /^(\d+)\s+(\d+)\s+(\d+)$/io; 

    if (
        (($s1 + $s2) > $s3) && 
        (($s2 + $s3) > $s1) &&
        (($s1 + $s3) > $s2)
        ) {
        $possible++;
    }

    #my $gak = <>;
}

print "possible = $possible\n";
