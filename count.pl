#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Std;
use Data::Dumper;

my @c = qw( 001-139 140-239 240-279 280-289 290-319 320-389 390-459 460-519 520-579 580-629 630-679 680-709 710-739 740-759 760-779 780-799 800-999 V01-V91 E000-E999 );

# count codes or combine the files together
my $files = '';
for (@c) { $files .= "data/$_.txt " } 
##`cat $files > combined.txt`;  # write contents of all files to a single file
for (`cat $files | wc -l`) { print "$_"; }  # count lines of each file
exit;