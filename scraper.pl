#!/usr/bin/perl

# This program requires cURL

# 1-2012 ICD-9-CM Volume 1 Diagnosis Codes.html
# 2-2012 ICD-9-CM Volume 1 Diagnosis Codes.html
# 3-2012 ICD-9-CM Codes 001-009 _ Intestinal Infectious Diseases.html
# 4-2012 ICD-9-CM Diagnosis Codes 001._ _ Cholera.html
# 4-2012 ICD-9-CM Diagnosis Codes 015._ _ Tuberculosis of bones and joints.html
#my $url = "1-2012 ICD-9-CM Volume 1 Diagnosis Codes.html";

use strict;
use warnings;
use Getopt::Std;
use Data::Dumper;
use URI;

my (%opts, $proxy, $category);
my $user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36";

my $base_url = "http://www.icd9data.com/";
my $url = $base_url."2012/Volume1/default.htm";

my $pages_downloaded = 0;
my $max_downloaded = 9999999;
my $out_file = 'data.txt';

getopts('x:c:m:o:', \%opts);
$proxy    = $opts{'x'} if (defined $opts{'x'});
$category = $opts{'c'} if (defined $opts{'c'});
$max_downloaded = $opts{'m'} if (defined $opts{'m'});
$out_file = $opts{'o'} if (defined $opts{'o'});

open(my $fh, '>', $out_file);

my @res = get_categories(get_html($url));
my $vol = $res[2];
get_categories(get_html($vol));

close($fh);

sub get_html {
    my ($uri) = @_;
    my $p = ''; $p = "-x $proxy" if (defined $proxy);
    my $cmd = "curl -A \"$user_agent\" $p \"$uri\" 2>NUL";
    #my $cmd = "cat \"$uri\"";
    my $html = '';
    foreach (`$cmd`) { $html .= $_; }
    
    if (defined $opts{'m'} && $pages_downloaded > $max_downloaded) {
        print "\n\npages downloaded: $pages_downloaded\n";
        exit;
    }
    $pages_downloaded++;
    
    return $html;
}

sub trim {
    my $str = shift;
    $str =~ s/^\s*//;
    $str =~ s/\s*$//;
    return $str;
}

sub get_categories {
    my $html = shift;

    foreach my $cat (split('<li>', $html)) {
        next if $cat !~ /class="identifier"/;
        next if $cat =~ /favicon/;
        
        $cat =~ /(.+?)<\/li>/;
        $cat = $1;
        
        my ($href, $code, $desc);
        $href = $code = $desc = '?';
        
        $cat =~ /href="(.+?)"/;
        $href = $1;
        
        $cat =~ /"identifier" \>(.+?)</;
        $code = $1;
        
        $desc = reverse($cat);
        $desc =~ /(.+?)>/;
        $desc = reverse(trim($1));
        
        # 1st page: return with only section we care about
        if (scalar(split(/\//, $href))-1 == 4 && $code eq $category) {
            print $fh "$code $desc\n";
            return ($code, $desc, $base_url . $href);
        }
        # not 1st page: keep going
        elsif(scalar(split(/\//, $href))-1 == 5) {
            print $fh "\t$code $desc\n";
            get_categories(get_html($base_url . $href));
        }
        elsif(scalar(split(/\//, $href))-1 == 6) {
            print $fh "\t\t$code $desc\n";
            get_categories(get_html($base_url . $href));
        }
        
        # the link we are about to visit is a leaf in the tree of codes
        my $leaf = (URI->new($href)->path_segments)[-2];
        
        # if looking at a code page, parse it differently
        if (defined($leaf) && length($leaf) == 3||defined($leaf) && length($leaf) == 4) {
            #print "$base_url . $href\n\n";
            get_codes(get_html($base_url . $href));
            next;
        }
    }
}

sub get_codes {
    my $html = shift;
    
    #print "$html\n\n\n";
    
    foreach my $code_html (split('hierarchyLine', $html)) {
        next if $code_html =~ /navbar/;
    
        #print "$code_html\n\n\n";
    
        my ($code, $desc);
        $code = $desc = '?';

        $code_html =~ /id="(\S+)"/;
        $code = $1;
        
        $code_html =~ /Description">(.+?)</;
        $desc = $1;
        
        print $fh "\t\t\t$code $desc\n";
    }
}

