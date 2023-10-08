#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;
use POSIX;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my @monkees = ();

my %monkey = ();
foreach my $line (@input) {
    if ($line =~ /^Monkey /o) {
        if (scalar keys %monkey) {
            push (@monkees, {%monkey});

            %monkey = ();
        }

        my ($num) = $line =~ /^Monkey (\d+):/o;

        $monkey{'monkey'} = $num;
        $monkey{'total'} = 0;
    }
    elsif ($line =~ /^  Starting items:/o) {
        my ($itemList) = $line =~ /^  Starting items: (.*)$/o;
        $itemList =~ s/\s//gio;

        my @items = split(',', $itemList); 

        $monkey{'items'} = \@items;
    }
    elsif ($line =~ /^  Operation:/o) {
        my ($oper) = $line =~ /^  Operation: new = (.*)$/o;

        $monkey{'oper'} = $oper;
    }
    elsif ($line =~ /^  Test:/o) {
        my ($test) = $line =~ /^  Test: divisible by (\d+)$/o;

        $monkey{'test'} = $test;
    }
    elsif ($line =~ /^    If true:/o) {
        my ($true) = $line =~ /^    If true: throw to monkey (\d+)$/o;

        $monkey{'true'} = $true;
    }
    elsif ($line =~ /^    If false/o) {
        my ($false) = $line =~ /^    If false: throw to monkey (\d+)$/o;

        $monkey{'false'} = $false;
    }
    elsif ($line =~ /^$/o) {
        next;
    }
}

# Push in the last monkey
push (@monkees, {%monkey});

#print Dumper \@monkees;
#print "\n";

# Round
my $round = 0;

do {
    $round++;

    # Turn
    foreach my $monkey (@monkees) {
        #print Dumper $monkey;
        #print "\n";

        my $oper = $monkey->{'oper'};
        my $test = $monkey->{'test'};
        my $true = $monkey->{'true'};
        my $false = $monkey->{'false'};

        while (scalar @{$monkey->{'items'}} > 0) {
            $monkey->{'total'}++;

            my $item = shift(@{$monkey->{'items'}});

            #print "worry: |" , $item , "|\n";

            my $cmd = $oper;
            $cmd =~ s/old/$item/go;

            #print "cmd: |" , $cmd , "|\n";
            my $worry = eval($cmd);
            # Modulus reduce based on the test #'s LCM
            # Since all test #'s are prime, we can just 
            #  multiple them all to get the LCM
            $worry = $worry % 9699690;

            if ($worry % $test == 0) {
                #print "sending $worry to monkey $true\n";
                push(@{$monkees[$true]->{'items'}}, $worry);
            }
            else {
                #print "sending $worry to monkey $false\n";
                push(@{$monkees[$false]->{'items'}}, $worry);
            }

            #my $gak = <>;
        }
    }

    #print Dumper \@monkees;
    #print "\n";

    print "Round $round:\n";
    foreach my $monkey (@monkees) {
        my $num = $monkey->{'monkey'};
        my @items = @{$monkey->{'items'}};

        print "Monkey $num: ";
        print join(',', @items);
        print "\n";
    }

    #my $gak = <>;
} until ($round == 10000);

print "\n";

my @totals = ();
foreach my $monkey (@monkees) {
    my $num = $monkey->{'monkey'};
    my $total = $monkey->{'total'};

    print "Monkey $num: $total\n";
    push (@totals, $total);
}

@totals = sort {$b <=> $a} @totals;

print "monkey business: |" . ($totals[0] * $totals[1]) . "|\n";

sub divisibility {
    my ($number, $test) = @_;

    my @chars = split('', $number);

    if ($test == 2) {
        if ($chars[-1] % 2 == 0) {
            return 1;
        }

        return 0;
    }
    elsif ($test == 3) {
        my $sum = 0;

        foreach my $char (@chars) {
            $sum += $char;
        }

        if ($sum % 3 == 0) {
            return 1;
        }

        return 0;
    }
    elsif ($test == 5) {
        if ($chars[-1] == 5 || $chars[-1] == 0) {
            return 1;
        }

        return 0;
    }
    elsif ($test == 7) {

    }
    elsif ($test == 11) {
    }
    elsif ($test == 13) {
        my $last = pop(@chars);

        $last *= 4;





    }
    elsif ($test == 17) {
    }
    elsif ($test == 19) {
    }
    return 0; 
}
