#!/usr/bin/perl

# acts as a "sink" for tcp clients. simply writes whatever it gets
# from the client to a file.

$usage = "usage: tcpsink port";

die "$usage" unless ($#ARGV == 0);

use IO::Socket;
use Socket;

$server = new IO::Socket::INET(LocalPort => $ARGV[0],
			       Type => SOCK_STREAM,
			       Reuse => 1,
			       Listen => 10);

while ($client = $server->accept) {
    $fname = $client->peerhost . "." . time;
    open OUT, ">$fname";
    while ($client->read($buf, 1024)) {
	print "writing...\n";
	syswrite OUT, $buf, length($buf);
    }
    close(OUT);
}
