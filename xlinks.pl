#!/usr/bin/perl

$usage= "xlinks file.html\nExtract links (href) from an html file.";
die $usage unless $#ARGV == 0;

use HTML::LinkExtor;

# this is copied shamelessly from HTML::LinkExtor POD

$p = HTML::LinkExtor->new(\&cb);
sub cb {
    my($tag, %links) = @_;
    #print "$tag: @{[%links]}\n";    
    print "$tag: $links{href}\n";
}
$p->parse_file($ARGV[0]);
