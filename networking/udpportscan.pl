#!/usr/bin/perl

$usage = 
"usage: udpportscan.pl host <port|port_range>+ [timeout_sec]
       port_range : port1-port2
       port : [1,2^16]
       timeout_sec : timeout in seconds, default is 1
 nmap inspiration: nmap -sU port_range";

die "$usage\n" if ($#ARGV < 1);

use Net::Ping;

$timeout = 1;
$timeout = $ARGV[2] if ($#ARGV == 2);
$p = new Net::Ping('udp', $timeout);
$host = $ARGV[0];
@range = split(/-/,$ARGV[1]);

sub range {
    local $min = shift;
    local $max = shift;
    local @ret = ();
    local $i;
    for ($i = $min; $i <= $max; $i++) {
	push @ret, $i;
    }
    return @ret;
}

if ($#range > 0) {
    @ports = $range[0] .. $range[1];
    #@ports = range($range[0], $range[1]);
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
