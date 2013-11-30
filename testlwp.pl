#/usr/bin/perl

use LWP::UserAgent;
use URI::URL;

$hdrs = new HTTP::Headers(Accept => 'image/gif',
    User-Agent => 'MegaBrowser/1.0');
#$url = new URI::URL("http://www.ora.com/index.html");
$url = new URI::URL("http://www.google.com/images/logo.gif");
$req = new HTTP::Request(GET, $url, $hdrs);
$ua = new LWP::UserAgent();
$resp = $ua->request($req);

if ($resp->is_success) { 
    open F, ">logo.gif";
    syswrite F, $resp->content, length($resp->content);
    close F;
} else { print $resp->message; }