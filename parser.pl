#!/usr/bin/perl

use strict;
use warnings;

#  icd9 code #, icd9 code desp, vol, chap, cat, subcat

sub parse_records
{
    my ($file) = shift @_;
    my ($vol, $chap, $cat, $subcat, $repeat);
    $vol = $chap = $cat = $subcat = '';
    $repeat = 1;
    
    open (FILE, '<', $file) || die "$!: $file\n"; # print error

    while (my $line = <FILE>)
    {
        chomp($line);
        my $state = scalar(split("\t", $line));
        $line =~ s/\t//g; # remove tabs
        $line =~ s/,//g;  # remove commas
        $line =~ s/"//g;  # remove quotes
        
        if    ($state == 1) { $vol  = $line; }
        elsif ($state == 2) { $chap = $line; }
        elsif ($state == 3) { $cat  = $line; $repeat = 0}
        elsif ($state == 4) {
            $line =~ /(.+?) (.+)/;
            if ($repeat) {
                print "=\"$1\",\"$2\",\"$vol\",\"$chap\",\"$chap\"\n";
            } else {
                print "=\"$1\",\"$2\",\"$vol\",\"$chap\",\"$cat\"\n";
            }
        }
    }

    close FILE;
}

print "ICD9 Code,Diagnosis, Volume, Chapter, Category\n";

my @c = qw( 001-139 140-239 240-279 280-289 290-319 320-389 390-459 460-519 520-579 580-629 630-679 680-709 710-739 740-759 760-779 780-799 800-999 E000-E999 V01-V91 );

#run all scripts
for (@c) {
    parse_records("data/$_.txt");
}



