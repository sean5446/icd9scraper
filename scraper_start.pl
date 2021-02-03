#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Std;
use Data::Dumper;

my (%opts, $proxy);
my $max_downloaded = 999999;
Getopt::Std::getopts('x:m:', \%opts);
$proxy    = $opts{'x'} if (defined $opts{'x'});
$max_downloaded = $opts{'m'} if (defined $opts{'m'});

# icd9 high level codes
my @c = qw( 001-139 140-239 240-279 280-289 290-319 320-389 390-459 460-519 520-579 580-629 630-679 680-709 710-739 740-759 760-779 780-799 800-999 V01-V91 E000-E999 );

# proxy list
my @p = qw(
70.35.197.74:80
74.84.131.34:80
130.211.243.5:80
54.174.144.206:80
35.163.78.238:80
54.187.99.188:80
134.129.246.150:80
107.181.80.178:80
);

#run all scripts
for (0 .. 18) {
    my $cmd = "start perl scraper.pl -x ".$p[$_]." -c \"".$c[$_]."\" -o data/test/".$c[$_].".txt";
    #my $cmd = "start perl -e \"sleep 10; print 'hi'; sleep 1;\"";  # test terminals opening
    print "$cmd\n";
    system($cmd);
}
