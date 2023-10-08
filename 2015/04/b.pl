#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;
use Digest::MD5 qw(md5 md5_hex md5_base64);

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

foreach my $line (@input) {
    my $salt = $line;

    print "salt: |" , $line , "|\n";

    my $num = 0;
    my $i = 1;
    for (;;) {
        my $hash = md5_hex($salt.$i);
    
        #print $hash . "\n";
    
        if ($hash =~ /^000000/) {
            $num = $i;

            last;
        }

        $i++;

        #my $gak = <>;
    }

    print "Num = $num\n";

    #my $gak = <>;
}
