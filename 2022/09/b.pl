#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;
my $debug = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test_b.txt") if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my @knots = (
    { 'y' => 0, 'x' => 0 },	# 0 (H)
    { 'y' => 0, 'x' => 0 }, # 1
    { 'y' => 0, 'x' => 0 }, # 2
    { 'y' => 0, 'x' => 0 }, # 3
    { 'y' => 0, 'x' => 0 }, # 4 
    { 'y' => 0, 'x' => 0 }, # 5 
    { 'y' => 0, 'x' => 0 }, # 6
    { 'y' => 0, 'x' => 0 }, # 7
    { 'y' => 0, 'x' => 0 }, # 8
    { 'y' => 0, 'x' => 0 }, # 9 (T)
);

my @hVisits = ();
my @tVisits = ();
my $h = \$knots[0];
my $t = \$knots[-1];
$hVisits[$$h->{'y'}][$$h->{'x'}] = '#';
$tVisits[$$t->{'y'}][$$t->{'x'}] = '#';

my $y = 0;
my $x = 0;

my @grid = ();
$grid[$y][$x] = 'H';

for my $knot (0..((scalar @knots)-1)) {
    if ($knot == 0) {
        printf ("H (%d,%d) \t ", $$h->{'y'}, $$h->{'x'});
    }
    elsif ($knot == ((scalar @knots) - 1)) {
        printf ("T (%d,%d)\n", $$t->{'y'}, $$t->{'x'});
    }
    else {
        printf ("$knot (%d,%d) \t ", $knots[$knot]->{'y'}, $knots[$knot]->{'x'});
    }
}
#printGrid(\@grid) if ($debug);

#my $gak = <> if ($debug);

foreach my $line (@input) {
    print "line: |" , $line , "|\n";

    if ($line eq 'DEBUG') {
        $debug = 1;
        next;
    }

    my ($dir, $cnt) = split(' ', $line);

    for (1..$cnt) {
        #if ($grid[$y][$x] eq 'B') {
        #    $grid[$y][$x] = 'T';
        #}
        #else {
        #    $grid[$y][$x] = '.';
        #}

        if ($dir eq 'U') {     # U (y)
            $y++;;
        }
        elsif ($dir eq 'D') {  # D (y)
            $y--;
        }
        elsif ($dir eq 'R') {  # R (x)
            $x++;
        }
        elsif ($dir eq 'L') {  # L (x)
            $x--;
        }

        # Advance head knot
        $$h->{'x'} = $x;
        $$h->{'y'} = $y;
        #$hVisits[$$h->{'y'}][$$h->{'x'}] = '#';

        # Advance other knots
        my $knotAhead = $h;
        for my $knot (1..((scalar @knots) - 1)) {
            #print "\t knot: $knot\n" if ($debug);
            moveKnot($knotAhead, \$knots[$knot], $knot);
            #print "\n" if ($debug);

            $knotAhead = \$knots[$knot];

            #my $gak = <> if ($debug);
        }

        #if (defined($grid[$y][$x]) && $grid[$y][$x] eq 'T') {
        #    $grid[$y][$x] = 'B';
        #}
        #else {
        #    #$grid[$y][$x] = 'H';
        #}

        # mark visit of last knot
        # #TODO
        #$tVisits[$$t->{'y'}][$$t->{'x'}] = '#';

        #print Dumper \@grid;
        #print "\n";

        for my $knot (0..((scalar @knots)-1)) {
            if ($knot == 0) {
                printf ("H (%d,%d) \t ", $$h->{'y'}, $$h->{'x'});
            }
            elsif ($knot == ((scalar @knots) - 1)) {
                printf ("T (%d,%d)\n", $$t->{'y'}, $$t->{'x'});
            }
            else {
                printf ("$knot (%d,%d) \t ", $knots[$knot]->{'y'}, $knots[$knot]->{'x'});
            }
        }

        #printGrid(\@grid) if ($debug);

        #my $gak = <> if ($debug);
    }

    my $numVisits = 0;
    for (my $y = ((scalar @tVisits) - 1); $y >= 0; $y--) {
        for (my $x = 0; $x < scalar @{$tVisits[$y]}; $x++) {
            if (defined($tVisits[$y][$x]) && $tVisits[$y][$x] eq '#') {
                $numVisits++;
            }
        }
    }

    #print "numVisits: |" , $numVisits , "|\n";

    #my $gak = <> if ($debug);
}

#printGrid(\@hVisits);
#printGrid(\@tVisits);

my $numVisits = 0;
for (my $y = ((scalar @tVisits) - 1); $y >= 0; $y--) {
    for (my $x = 0; $x < scalar @{$tVisits[$y]}; $x++) {
        if (defined($tVisits[$y][$x]) && $tVisits[$y][$x] eq '#') {
            $numVisits++;
        }
    }
}

#print "numVisits: |" , $numVisits , "|\n";

sub printGrid {
    my ($array) = @_;

    my @grid = @{$array};

    for (my $y = ((scalar @grid) - 1); $y >= 0; $y--) {
        printf('%2sy', $y);

        for (my $x = 0; $x < scalar @{$grid[$y]}; $x++) {
            if (! defined($grid[$y][$x])) {
                print '.';
            }
            else {
                print $grid[$y][$x];
            }
        }
        print "\n";
    }
    print "\n";
}

# Move Knot as if each segment is its own mini head & tail
sub moveKnot {
    my ($h, $t, $num) = @_;

    printf ("\t\t Before: Ahead (%d,%d) \t $num (%d,%d)\n", $$h->{'y'}, $$h->{'x'}, $$t->{'y'}, $$t->{'x'}) if ($debug);

    print "abs(".$$h->{'x'}." - ".$$t->{'x'}.") = |".abs($$h->{'x'} - $$t->{'x'})."|\n" if ($debug);
    print "abs(".$$h->{'y'}." - ".$$t->{'y'}.") = |".abs($$h->{'y'} - $$t->{'y'})."|\n" if ($debug);
    print "abs(".$$t->{'x'}." - ".$$h->{'x'}.") = |".abs($$t->{'x'} - $$h->{'x'})."|\n" if ($debug);
    print "abs(".$$t->{'y'}." - ".$$h->{'y'}.") = |".abs($$t->{'y'} - $$h->{'y'})."|\n" if ($debug);
    if (abs($$h->{'x'} - $$t->{'x'}) == 2) { # Right
        print "Right..\n" if ($debug);
        $$t->{'x'}--;
        if (abs($$h->{'y'} - $$t->{'y'}) == 2) {
            $$t->{'y'}--;
        }
        else {
            $$t->{'y'} = $$h->{'y'} if ($$t->{'y'} != $$h->{'y'});
        }
    }
    elsif (abs($$h->{'y'} - $$t->{'y'}) == 2) { # Up
        print "Up..\n" if ($debug);
        $$t->{'y'}++;
        if (abs($$h->{'x'} - $$t->{'x'}) == 2) {
            $$t->{'x'}++;
        }
        else {
            $$t->{'x'} = $$h->{'x'} if ($$t->{'x'} != $$h->{'x'});
        }
    }
    elsif (abs($$t->{'x'} - $$h->{'x'}) == 2) { # Left
        print "Left..\n" if ($debug);
        $$t->{'x'}--;
        if (abs($$t->{'y'} - $$h->{'y'}) == 2) {
            $$t->{'y'}--;
        }
        else {
            $$t->{'y'} = $$h->{'y'} if ($$t->{'y'} != $$h->{'y'});
        }
    }
    elsif (abs($$t->{'y'} - $$h->{'y'}) == 2) { # Down
        print "Down..\n" if ($debug);
        $$t->{'y'}--;
        if (abs($$t->{'x'} - $$h->{'x'}) == 2) {
            $$t->{'x'}++;
        }
        else {
            $$t->{'x'} = $$h->{'x'} if ($$t->{'x'} != $$h->{'x'});
        }
    }

    printf ("\t\t After:  Ahead (%d,%d) \t $num (%d,%d)\n", $$h->{'y'}, $$h->{'x'}, $$t->{'y'}, $$t->{'x'}) if ($debug);
    my $gak = <> if ($debug);
}
