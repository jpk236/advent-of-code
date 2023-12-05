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

my %cards = ();
foreach my $line (@input) {
    my ($card, $numbers) = split(/\s*:\s*/, $line);

    my ($cardNum, $winning, $num) = $line =~ /^Card\s*(\d+):([^|]+)\|([^\$]+)$/io;
    $winning =~ s/^\s*|\s*$//gio;
    $num =~ s/^\s*|\s*$//gio;

    my @winningNum = split(/\s+/io, $winning);
    my @numWeHave = split(/\s+/io, $num);

    $cards{$cardNum} = {
        'cardNum'       => $cardNum,
        'winningNum'    => [@winningNum],
        'numWeHave'     => [@numWeHave],
        'copies'        => 1,
    };
}

foreach my $card (sort { $a <=> $b } keys %cards) {
    my $cardNum = $cards{$card}{'cardNum'};
    my $copies = $cards{$card}{'copies'};
    my @winningNum = @{$cards{$card}{'winningNum'}};
    my @numWeHave = @{$cards{$card}{'numWeHave'}};

    my $match = 0;
    foreach my $win (@winningNum) {
        foreach my $check (@numWeHave) {
            if ($win == $check) {
                $match++;
            }
        }
    }

    my $start = $card+1;
    my $end = (($card+$match) > scalar @input) ? scalar @input : ($card+$match);

    foreach my $range ($start..$end) {
        foreach (1..$copies) {
            $cards{$range}{'copies'}++;
        }
    }

    print "cardNum($cardNum): match($match)\n\n";

    foreach my $card (sort { $a <=> $b } keys %cards) {
        my $cardNum = $cards{$card}{'cardNum'};
        my $copies = $cards{$card}{'copies'};

        print "cardNum($cardNum) : $copies\n";
    }

    print "\n";

    #my $gak = <>;
}

my $total = 0;
foreach my $card (sort { $a <=> $b } keys %cards) {
    my $cardNum = $cards{$card}{'cardNum'};
    my $copies = $cards{$card}{'copies'};

    print "cardNum($cardNum) : $copies\n";

    $total += $copies;
}

print "total: |" , $total , "|\n";

