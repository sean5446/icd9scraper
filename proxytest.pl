#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Std;
use Data::Dumper;

my $base_url = "http://www.icd9data.com/";

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


for (@p) {
    print "$_\n";
    my $i = 0;
    for (`curl -x $_ $base_url 2>&1`) {
        $i++
    }
    print "$i\n\n";
}
