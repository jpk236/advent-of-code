#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;
use integer;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

# Ref: https://perldoc.perl.org/perlop#Bitwise-And
# Ref: https://perldoc.perl.org/perlop#Bitwise-Or-and-Exclusive-Or
# Ref: https://perldoc.perl.org/perlop#Symbolic-Unary-Operators
# Ref: https://perldoc.perl.org/perlop#Shift-Operators

my @circuit = ();

foreach my $line (@input) {
    my %hash = ();

    if ($line =~ /^\d+ ->/) {
        my ($value, $wire) = $line =~ /^(\d+) -> ([A-z]+)$/io;

        %hash = (
            "$wire" => [ 'SET', $value ],
        );
    }
    elsif ($line =~ /^[A-z]+ ->/) {
        my ($wire1, $wire) = $line =~ /^([A-z]+) -> ([A-z]+)$/io;

        %hash = (
            "$wire" => [ 'ASSIGN', $wire1 ],
        );
    }
    elsif ($line =~ / (AND|OR) /) {
        my ($wire1, $operator, $wire2, $wire) = $line =~ /^(\w+) (AND|OR) ([A-z]+) -> ([A-z]+)$/io;

        %hash = (
            "$wire" => [ $operator, $wire1, $wire2 ],
        );
    }
    elsif ($line =~ /^NOT /) {
        my ($wire1, $wire) = $line =~ /^NOT ([A-z]+) -> ([A-z]+)$/io;

        %hash = (
            "$wire" => [ 'NOT', $wire1 ],
        );
    }
    elsif ($line =~ / (LSHIFT|RSHIFT) /) {
        my ($wire1, $operator, $value, $wire) = $line =~ /^([A-z]+) (LSHIFT|RSHIFT) (\d+) -> ([A-z]+)$/io;

        %hash = (
            "$wire" => [ $operator, $wire1, $value ],
        );
    }
    else {
        print "ERROR: line not recognized\n";

        my $gak = <>;
    }

    push(@circuit, \%hash);
}

my $a = powerCircuit();

print "a: |" . $a . "|\n";

$a = powerCircuit($a);

print "a: |" . $a . "|\n";

sub powerCircuit {
    my ($override) = @_;

    my %values = ();

    for (;;) {
        foreach my $step (@circuit) {
            foreach my $wire (keys %{$step}) {
                my $operator = $step->{$wire}->[0]; # SET | ASSIGN | AND | OR | NOT | LSHIFT | RSHIFT

                if ($operator eq 'SET') {
                    my $value = $step->{$wire}->[1];

                    $values{$wire} = int($value);

                    $values{$wire} = $override if ($wire eq 'b' && defined($override));
                }
                elsif ($operator eq 'ASSIGN') {
                    my $wire1 = $step->{$wire}->[1];

                    my $value1;
                    if ($wire1 =~ /^[A-z]+$/) {
                        next if (! exists($values{$wire1}));
                        $value1 = $values{$wire1};
                    }
                    else {
                        $value1 = int($wire1);
                    }

                    $values{$wire} = $value1;

                    $values{$wire} = $override if ($wire eq 'b' && defined($override));
                }
                elsif ($operator eq 'AND') {
                    my $wire1 = $step->{$wire}->[1];
                    my $wire2 = $step->{$wire}->[2];

                    my $value1;
                    if ($wire1 =~ /^[A-z]+$/) {
                        next if (! exists($values{$wire1}));
                        $value1 = $values{$wire1};
                    }
                    else {
                        $value1 = int($wire1);
                    }

                    my $value2;
                    if ($wire2 =~ /^[A-z]+$/) {
                        next if (! exists($values{$wire2}));
                        $value2 = $values{$wire2};
                    }
                    else {
                        $value2 = int($wire2);
                    }

                    $values{$wire} = ($value1 & $value2);

                    $values{$wire} = $override if ($wire eq 'b' && defined($override));
                }
                elsif ($operator eq 'OR') {
                    my $wire1 = $step->{$wire}->[1];
                    my $wire2 = $step->{$wire}->[2];

                    my $value1;
                    if ($wire1 =~ /^[A-z]+$/) {
                        next if (! exists($values{$wire1}));
                        $value1 = $values{$wire1};
                    }
                    else {
                        $value1 = int($wire1);
                    }

                    my $value2;
                    if ($wire2 =~ /^[A-z]+$/) {
                        next if (! exists($values{$wire2}));
                        $value2 = $values{$wire2};
                    }
                    else {
                        $value2 = int($wire2);
                    }

                    $values{$wire} = ($value1 | $value2);

                    $values{$wire} = $override if ($wire eq 'b' && defined($override));
                }
                elsif ($operator eq 'NOT') {
                    my $wire1 = $step->{$wire}->[1];

                    my $value1;
                    if ($wire1 =~ /^[A-z]+$/) {
                        next if (! exists($values{$wire1}));
                        $value1 = $values{$wire1};
                    }
                    else {
                        $value1 = int($wire1);
                    }

                    $values{$wire} = 65535 - $value1;

                    $values{$wire} = $override if ($wire eq 'b' && defined($override));
                }
                elsif ($operator eq 'LSHIFT') {
                    my $wire1 = $step->{$wire}->[1];
                    my $value = $step->{$wire}->[2];

                    my $value1;
                    if ($wire1 =~ /^[A-z]+$/) {
                        next if (! exists($values{$wire1}));
                        $value1 = $values{$wire1};
                    }
                    else {
                        $value1 = int($wire1);
                    }

                    $values{$wire} = $value1 << int($value);

                    $values{$wire} = $override if ($wire eq 'b' && defined($override));
                }
                elsif ($operator eq 'RSHIFT') {
                    my $wire1 = $step->{$wire}->[1];
                    my $value = $step->{$wire}->[2];

                    my $value1;
                    if ($wire1 =~ /^[A-z]+$/) {
                        next if (! exists($values{$wire1}));
                        $value1 = $values{$wire1};
                    }
                    else {
                        $value1 = int($wire1);
                    }

                    $values{$wire} = $value1 >> int($value);

                    $values{$wire} = $override if ($wire eq 'b' && defined($override));
                }
                else {
                    print "ERROR: unidentified operator\n";

                    my $gak = <>;
                }
            }
        }

        last if (exists($values{'a'}));
    }

    return $values{'a'};
}
