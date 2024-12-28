#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Deepcopy = 1;
open STDERR, '>&STDOUT';

my $test = 1;

open (FILE, "input.txt")        if ($test == 0);
#open (FILE, "input_test.txt")   if ($test == 1);
#open (FILE, "input_test-2.txt")   if ($test == 1);
#open (FILE, "input_test-3.txt")   if ($test == 1);
#open (FILE, "input_test-4.txt")   if ($test == 1);
open (FILE, "input_test-5.txt")   if ($test == 1);
chomp(my @input = reverse <FILE>);
close (FILE);

my @grid = ();
my $x = 0;
my $y = 0;

for (my $i = 0 ; $i < scalar @input ; $i++) {
    my @chars = split('', $input[$i]);

    push(@grid, \@chars);
}

printGrid(\@grid);

my %ant = ();

my %unique = ();

for (my $y = ((scalar @grid) - 1); $y >= 0; $y--) {
    for (my $x = 0; $x < scalar @{$grid[$y]}; $x++) {
        if ($grid[$y][$x] =~ /^[A-z0-9]$/o) {
            my $freq = $grid[$y][$x];

            #print "found antenna! '$freq' = ($y,$x)\n";

            if (! exists($ant{$freq}{'coord'}{"$y\_$x"})) {
                $ant{$freq}{'coord'}{"$y\_$x"} = 1;
            }

            #print Dumper \%ant;
            #print "\n";

            foreach my $node (sort keys %{$ant{$freq}{'coord'}}) {
                #print "node: |" , $node , "|\n";
                
                my ($b, $a) = $node =~ /^(\d+)_(\d+)$/io;

                if ($y == $b && $x == $a) {
                    #print "it's me .. skipping..\n";
                    
                    #my $gak = <>;

                    next;
                }

                #print "b: |" , $b , "|\n";
                #print "a: |" , $a , "|\n";

                #print "1-getting here..\n";

                if (
                    ! exists($ant{$freq}{'combo'}{"$y\_$x-$b\_$a"}) &&
                    ! exists($ant{$freq}{'combo'}{"$b\_$a-$y\_$x"})
                ) {
                    #print "2-getting here..\n";

                    my $antinode_1_y = undef;
                    my $antinode_1_x = undef;

                    my $antinode_2_y = undef;
                    my $antinode_2_x = undef;

                    # 3   X
                    # 2  A
                    # 1 B
                    # 0X
                    #  0123
                    if ($y > $b && $x > $a) {
                        #print "3-getting here..\n";

                        $antinode_1_y = $y + ($y - $b);
                        $antinode_1_x = $x + ($x - $a);

                        $antinode_2_y = $b - ($y - $b);
                        $antinode_2_x = $a - ($x - $a);
                    }

                    # 3X
                    # 2 A
                    # 1  B
                    # 0   X
                    #  0123
                    elsif ($y > $b && $x < $a) {
                        #print "4-getting here..\n";

                        $antinode_1_y = $y + ($y - $b);
                        $antinode_1_x = $x - ($a - $x);

                        $antinode_2_y = $b - ($y - $b);
                        $antinode_2_x = $a + ($a - $x);
                    }

                    # 3X
                    # 2 B
                    # 1  A
                    # 0   X
                    #  0123
                    elsif ($y < $b && $x > $a) {
                        #print "5-getting here..\n";

                        $antinode_1_y = $b + ($b - $y);
                        $antinode_1_x = $a - ($x - $a);

                        $antinode_2_y = $y - ($b - $y);
                        $antinode_2_x = $x + ($x - $a);
                    }

                    # 3   X
                    # 2  B
                    # 1 A
                    # 0X
                    #  0123
                    elsif ($y < $b && $x < $a) {
                        #print "6-getting here..\n";

                        $antinode_1_y = $b + ($b - $y);
                        $antinode_1_x = $a + ($a - $x);

                        $antinode_2_y = $y - ($b - $y);
                        $antinode_2_x = $x - ($a - $x);
                    }

                    # 3 X
                    # 2 A
                    # 1 B
                    # 0 X
                    #  0123
                    elsif ($y > $b && $x == $a) {
                        #print "7-getting here..\n";

                        $antinode_1_y = $y + ($y - $b);
                        $antinode_1_x = $x;

                        $antinode_2_y = $b - ($y - $b);
                        $antinode_2_x = $x;
                    }

                    # 3 X
                    # 2 B
                    # 1 A
                    # 0 X
                    #  0123
                    elsif ($y < $b && $x == $a) {
                        #print "8-getting here..\n";

                        $antinode_1_y = $b + ($b - $y);
                        $antinode_1_x = $x;

                        $antinode_2_y = $y - ($b - $y);
                        $antinode_2_x = $x;
                    }

                    # 3
                    # 2
                    # 1XABX
                    # 0
                    #  0123
                    elsif ($y == $b && $x < $a) {
                        #print "9-getting here..\n";

                        $antinode_1_y = $y;
                        $antinode_1_x = $x - ($a - $x);

                        $antinode_2_y = $y;
                        $antinode_2_x = $a + ($a - $x);
                    }

                    # 3
                    # 2
                    # 1XBAX
                    # 0
                    #  0123
                    elsif ($y == $b && $x > $a) {
                        #print "10-getting here..\n";

                        $antinode_1_y = $y;
                        $antinode_1_x = $a - ($x - $a);

                        $antinode_2_y = $y;
                        $antinode_2_x = $x + ($x - $a);
                    }

                    $ant{$freq}{'combo'}{"$y\_$x-$b\_$a"} = {
                        'antinode_1_y' => $antinode_1_y, 
                        'antinode_1_x' => $antinode_1_x, 

                        'antinode_2_y' => $antinode_2_y,
                        'antinode_2_x' => $antinode_2_x,
                    };

                    if (
                        ($antinode_1_y >= 0 && $antinode_1_x >= 0) &&
                        ($antinode_1_y <= ((scalar @grid) - 1) && $antinode_1_x <= ((scalar @{$grid[0]}) - 1))
                    ) {
                        $unique{"[$antinode_1_y][$antinode_1_x]"} = 1;
                        $unique{"[$y][$x]"} = 1;
                        $unique{"[$b][$a]"} = 1;

                        if ($grid[$antinode_1_y][$antinode_1_x] eq '.') {
                            $grid[$antinode_1_y][$antinode_1_x] = '#';
                        }
                    }

                    if (
                        ($antinode_2_y >= 0 && $antinode_2_x >= 0) &&
                        ($antinode_2_y <= ((scalar @grid) - 1) && $antinode_2_x <= ((scalar @{$grid[0]}) - 1))
                    ) {
                        $unique{"[$antinode_2_y][$antinode_2_x]"} = 1;
                        $unique{"[$y][$x]"} = 1;
                        $unique{"[$b][$a]"} = 1;

                        if ($grid[$antinode_2_y][$antinode_2_x] eq '.') {
                            $grid[$antinode_2_y][$antinode_2_x] = '#';
                        }
                    }
                }

                #print Dumper \%ant;
                #print "\n";

                #printGrid(\@grid);

                #my $gak = <>;
            }

            #print Dumper \%ant;
            #print "\n";

            #printGrid(\@grid);

            #my $gak = <>;
        }
    }
}

print Dumper \%ant;
print "\n";

printGrid(\@grid);

print "unique: |" . scalar(keys %unique) . "|\n";

sub printGrid {
    my ($array) = @_;

    for (my $y = ((scalar @{$array}) - 1); $y >= 0; $y--) {
        printf('  %2s', $y);

        for (my $x = 0; $x < scalar @{$array->[$y]}; $x++) {
            if (! defined($array->[$y][$x])) {
                print " ";
            }
            else {
                print $array->[$y][$x];
            }
        }
        print "\n";
    }

    print "    ";
    for (my $x = 0; $x < scalar @{$array->[0]}; $x++) {
        print $x;
    }
    print "\n";

    print "\n";
}

