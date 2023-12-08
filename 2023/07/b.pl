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
    #$line =~ s/J/W/g;
    $line =~ s/J/1/g; # Joker
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

    $hands{$hand}{'score'} = determineScore($hand, \@keys, \@vals);

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

sub determineScore {
    my ($hand, $keys, $vals) = @_;

    #print Dumper $keys;
    #print "\n";
    #print Dumper $vals;
    #print "\n";

    my $redo = 0;
    my $score = 0;

    if (scalar @{$vals} == 1 && $vals->[0] == 5) {
        # five of a kind
        $score = 7;
    }
    elsif (scalar @{$vals} == 2 && $vals->[0] == 4 && $vals->[1] == 1) {
        # four of a kind
        $score = 6;

        if ($hand =~ /1/) {
            $redo = 1;

            if ($keys->[0] eq 1) {
                $hand =~ s/1/$keys->[1]/g;
            }
            elsif ($keys->[1] eq 1) {
                $hand =~ s/1/$keys->[0]/g;
            }
        }
    }
    elsif (scalar @{$vals} == 2 && $vals->[0] == 3 && $vals->[1] == 2) {
        # full house
        $score = 5;

        if ($hand =~ /1/) {
            $redo = 1;

            if ($keys->[0] eq 1) {
                $hand =~ s/1/$keys->[1]/g;
            }
            elsif ($keys->[1] eq 1) {
                $hand =~ s/1/$keys->[0]/g;
            }
        }
    }
    elsif (scalar @{$vals} == 3 && $vals->[0] == 3 && $vals->[1] == 1 && $vals->[2] == 1) {
        # three of a kind
        $score = 4;

        if ($hand =~ /1/) {
            $redo = 1;

            if ($keys->[0] eq 1) {
                $hand =~ s/1/$keys->[1]/g;
            }
            elsif ($keys->[1] eq 1 || $keys->[2] eq 1) {
                $hand =~ s/1/$keys->[0]/g;
            }
        }
    }
    elsif (scalar @{$vals} == 3 && $vals->[0] == 2 && $vals->[1] == 2 && $vals->[2] == 1) {
        # two pair
        $score = 3;

        if ($hand =~ /1/) {
            $redo = 1;

            if ($keys->[0] eq 1) {
                $hand =~ s/1/$keys->[1]/g;
            }
            elsif ($keys->[1] eq 1 || $keys->[2] eq 1) {
                $hand =~ s/1/$keys->[0]/g;
            }
        }
    }
    elsif (scalar @{$vals} == 4 && $vals->[0] == 2 && $vals->[1] == 1 && $vals->[2] == 1 && $vals->[3] == 1) {
        # one pair
        $score = 2;

        if ($hand =~ /1/) {
            $redo = 1;

            if ($keys->[0] eq 1) {
                $hand =~ s/1/$keys->[1]/g;
            }
            elsif ($keys->[1] eq 1 || $keys->[2] eq 1 || $keys->[3] eq 1) {
                $hand =~ s/1/$keys->[0]/g;
            }
        }
    }
    elsif (scalar @{$vals} == 5 && $vals->[0] == 1) {
        # high card
        $score = 1;

        if ($hand =~ /1/) {
            $redo = 1;

            if ($keys->[0] eq 1) {
                $hand =~ s/1/$keys->[1]/g;
            }
            else {
                $hand =~ s/1/$keys->[0]/g;
            }
        }
    }
    else {
        print "ERROR: hand type not found for $hand\n";

        my $gak = <>;
    }

    if ($redo) {
        my %hash = ();
        my @cards = split('', $hand);

        foreach my $card (@cards) {
            $hash{'cards'}{$card}++;
        }

        my @keys  = sort { $hash{'cards'}{$b} <=> $hash{'cards'}{$a} } keys (%{$hash{'cards'}});
        my @vals = @{$hash{'cards'}}{@keys};

        $score = determineScore($hand, \@keys, \@vals);
    }

    return $score;
}
