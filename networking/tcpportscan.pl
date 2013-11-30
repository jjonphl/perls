#!/usr/bin/perl

$usage = 
"usage: tcpportscan.pl host <port|port_range>+ [timeout_sec]
       port_range : port1-port2
       port : [1,2^16]
       timeout_sec : timeout in seconds, default is 1
 nmap inspiration: nmap [-sT] port_range";

die "$usage\n" if ($#ARGV < 1);

use Net::Ping;

$timeout = 1;
$timeout = $ARGV[2] if ($#ARGV == 2);
$p = new Net::Ping('tcp', $timeout);
$host = $ARGV[0];
@range = split(/-/,$ARGV[1]);

if (@range == 2) {
    @ports = $range[0] .. $range[1];
} else {
    @ports = @range;
}

foreach $i (@ports) {
    $p->{port_num} = $i;
    if ($p->ping($host)) {
	print "port $i replied\n";
    }
}
$p->close;
