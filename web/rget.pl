#!/usr/bin/perl

$usage = "usage: rget <url>";

die "$usage\n" unless ($#ARGV == 0);

use LWP::UserAgent;
use URI::URL;

$ua = new LWP::UserAgent();
$url = new URI::URL($ARGV[0]);
$req = new HTTP::Request(GET, $url);
$res = $ua->request($req);

sub printme {
    local $hdr = shift;
    local $val = shift;
    print "$hdr: $val\n";
}

if ($res->is_success) {
    $hdr = $res->headers;
    $hdr->scan(\&printme);
} else {
    print "Error!\n", $res->message;
}
