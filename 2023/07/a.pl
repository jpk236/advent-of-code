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

my %hands = ();
foreach my $line (@input) {
    #print "line: |" , $line , "|\n";

    # convert to aid in sorting
    $line =~ s/A/Z/g;
    $line =~ s/K/Y/g;
    $line =~ s/Q/X/g;
    $line =~ s/J/W/g;
    $line =~ s/T/V/g;

    #print "line: |" , $line , "|\n";

    my ($hand, $bid) = split(' ', $line);
    my @cards = split('', $hand);

    $hands{$hand}{'hand'} = $hand;
    $hands{$hand}{'bid'} = $bid;

    foreach my $card (@cards) {
        $hands{$hand}{'cards'}{$card}++;
    }

    my @keys  = sort { $hands{$hand}{'cards'}{$b} <=> $hands{$hand}{'cards'}{$a} } keys (%{$hands{$hand}{'cards'}});
    my @vals = @{$hands{$hand}{'cards'}}{@keys};

    if (scalar @vals == 1 && $vals[0] == 5) {
        # five of a kind
        $hands{$hand}{'score'} = 7;
    }
    elsif (scalar @vals == 2 && $vals[0] == 4 && $vals[1] == 1) {
        # four of a kind
        $hands{$hand}{'score'} = 6;
    }
    elsif (scalar @vals == 2 && $vals[0] == 3 && $vals[1] == 2) {
        # full house
        $hands{$hand}{'score'} = 5;
    }
    elsif (scalar @vals == 3 && $vals[0] == 3 && $vals[1] == 1 && $vals[2] == 1) {
        # three of a kind
        $hands{$hand}{'score'} = 4;
    }
    elsif (scalar @vals == 3 && $vals[0] == 2 && $vals[1] == 2 && $vals[2] == 1) {
        # two pair
        $hands{$hand}{'score'} = 3;
    }
    elsif (scalar @vals == 4 && $vals[0] == 2 && $vals[1] == 1 && $vals[2] == 1 && $vals[3] == 1) {
        # one pair
        $hands{$hand}{'score'} = 2;
    }
    elsif (scalar @vals == 5 && $vals[0] == 1) {
        # high card
        $hands{$hand}{'score'} = 1;
    }
    else {
        print "ERROR: hand type not found for $hand\n";

        my $gak = <>;
    }

    #print Dumper \%hands;
    #print "\n";

    #my $gak = <>;
}

my %scores = ();

foreach my $hand (sort { $hands{$b}{'score'} <=> $hands{$a}{'score'} } keys %hands) {
    #print "hand: |" , $hand , "|\n";

    my $score = $hands{$hand}{'score'};

    push(@{$scores{$score}{'hands'}}, $hand);

    #print Dumper \%scores;
    #print "\n";

    #my $gak = <>;
}

my @ranking = ();

foreach my $score (sort { $a <=> $b } keys %scores) {
    foreach my $hand (sort @{$scores{$score}{'hands'}} ) {
        push (@ranking, $hand);
    }
}

#print Dumper \@ranking;
#print "\n";

my $winnings = 0;

for (my $i = 0 ; $i < scalar @ranking ; $i++) {
    $winnings += ($hands{$ranking[$i]}{'bid'} * ($i+1));
}

print "winnings: |" , $winnings , "|\n";

