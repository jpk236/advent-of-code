#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my $test = 0;

open (FILE, "input.txt")        if ($test == 0);
open (FILE, "input_test.txt")   if ($test == 1);
chomp(my @input = <FILE>);
close (FILE);

my %files = ();
my $cwd = \%files;  # set reference to cwd pos
my $pwd = undef;    # set reference to pwd pos

foreach my $line (@input) {
    #print "line: |" , $line , "|\n";

    if ($line =~ /^\$ /io) {
        my ($cmd) = $line =~ /^\$ (.*)$/io;

        if ($cmd eq 'ls') {
            next;
        }
        elsif ($cmd =~ /^cd /io) {
            my ($dir) = $cmd =~ /^cd (.*)$/io;

            if ($dir eq '..') {
                $pwd = $cwd->{'parent'};
                $cwd = $pwd;

                next;
            }
            else {
                $pwd = $cwd if (! defined ($pwd));

                my %hash = (
                    'name' => $dir,
                    'type' => 'dir',
                    'parent' => $pwd,
                    'child' => {},
                );
  
                if (! scalar keys %files) {
                    %{$cwd->{$dir}} = (%hash);   # store dir details
                    $pwd = undef;                # set pwd dir
                    $cwd = $cwd->{$dir};         # advance cwd to new dir
                }
                else {
                    $pwd = $cwd->{'child'}->{$dir}->{'parent'}; # set pwd dir
                    %{$cwd->{'child'}->{$dir}} = (%hash);       # store dir details
                    $cwd = $cwd->{'child'}->{$dir};             # advance cwd to new dir
                }
            }
        }
        else {
            print "1-ERROR: unidentified line\n";
        }
    }
    elsif ($line =~ /^dir /io) {
        next;
    }
    elsif ($line =~ /^\d+ /io) {
        my ($size, $filename) = $line =~ /^(\d+) (.*)$/io;

        my %hash = (
            'name' => $filename,
            'type' => 'file',
            'size' => $size,
        );

        %{$cwd->{'child'}->{$filename}} = (%hash); # store dir details
    }
    else {
        print "2-ERROR: unidentified line\n";
    }

    #print Dumper \%files;
    #print "\n";

    #my $gak = <>;
}

#print Dumper \%files;
#print "\n";

my $usedSpace = 0;
$usedSpace = determineSize(1, \%files, $usedSpace);

my $totalDisk = 70000000;
my $requiredFree = 30000000;
my $neededSpace = $totalDisk - $requiredFree; 
my $needToDelete = $usedSpace - $neededSpace;

#print "totalDisk: |" , $totalDisk , "|\n";
#print "requiredFree: |" , $requiredFree , "|\n";
#print "usedSpace: |" , $usedSpace , "|\n";
#print "neededSpace: |" , $neededSpace , "|\n";
#print "needToDelete: |" , $needToDelete , "|\n";

$usedSpace = 0;
my $candidate = 0;
determineSize(2, \%files, $usedSpace);

print "candidateToDelete: |" , $candidate , "|\n";

sub determineSize {
    my ($run, $hash, $size) = @_;

    foreach my $file (keys %{$hash}) {
        my $name = $hash->{$file}->{'name'};
        my $type = $hash->{$file}->{'type'};

        #print "name: |" , $name , "|\n";
        #print "type: |" , $type , "|\n";

        if ($type eq 'file') {
            my $fileSize = $hash->{$file}->{'size'};

            #print "size: |" , $size , "|\n";

            $size += $fileSize;
        }
        elsif ($type eq 'dir') {
            my $dirSize = 0;

            my $child = $hash->{$file}->{'child'};

            #print "child: |" , $child , "|\n";

            if (scalar keys %{$hash->{$file}->{'child'}}) {
                $dirSize += determineSize($run, \%{$hash->{$file}->{'child'}}, $dirSize);

                print "'$name' dirSize: |" , $dirSize , "|\n";

                $size += $dirSize;

                if ($run == 2 && $dirSize >= $needToDelete) {
                    if (! $candidate || ($dirSize < $candidate)) {
                        $candidate = $dirSize;
                    }
                }
            }

        }

        #print "\n";
        #my $gak = <>;
    }

    return $size;
}

