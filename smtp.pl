#!/usr/bin/perl -w

$usage = 
"usage: smtp.pl [port]
    a localhost smtp relayer (i think that's how it is described)";

use IO::Socket;

$port = ($#ARGV == 0) ? $ARGV[0] : 25;
$server = new IO::Socket::INET(LocalPort => $port,
			       Type => SOCK_STREAM,
			       Reuse => 1,
			       Listen => 10);

while ($client = $server->accept) {
    if (!($client->peerhost eq $client->sockhost)) {
	$client->print("421 only for localhost\n");
    } else {
	$client->print("220 open relay\n");
	@rcpt = ();
	@data = ();
	$state = "none";

	$fname = time;
	open LOG, ">$fname";
# commands:
#    a. helo <client name> : 250 <server name> (reset envelope)
#    b. rset : 250 Ok (reset envelope)
#    c. noop : 250 Ok
#    d. mail from: from@address : 250 Ok
#    e. rcpt to: to@address : 250 Ok (multiple)
#    f. data : 354 Go on
#    g. quit : 221 Bye
	while (!($state eq "quit")) {
	    $_ = $client->getline();            
	    print LOG;
	    if ($state eq "data") {
		$resp = 0;
		#print "data: $_";
		if (/^\.\r+\n$/) { 
		    $state = "none";
		    $resp = "250 ok\n";
		    $save_from = $rcpt[0];
		    for ($i = 1; $i <= $#rcpt; $i++) {
			$rcpt[$i] =~ /\@([\S!\>]+)\>/;
			print "look for mx $1\n";
			# look for mx
			# do Net::SMTP
		    }
		    @rcpt = ();
		    $rcpt[0] = $save_from;
		} else { push @data, ($_); }
		#print "state: $state\n";	    
	    } elsif (/^HELO/i || /^NOOP/i) {
		$resp = "250 localhost\n";
	    } elsif (/^QUIT/i) {
		$resp = "221 bye!\n";
		$state = "quit";
	    } elsif (/^RSET/i) {
		$resp = "250 ok\n";
		@rcpt = ();
		@data = ();
	    } elsif (/^MAIL\s+FROM:\s*(\S*)/i) {
		$resp = "250 ok\n";
		@rcpt = ();
		$rcpt[0] = $1;
	    } elsif (/^RCPT\s+TO:\s*(\S*)/i) {
		if (!$rcpt[0]) {
		    $resp = "503 need mail\n";
		} else {
		    push @rcpt, ($1);
		    print LOG "[$#rcpt] ($rcpt[0]) ($rcpt[1])\n";
		    $resp = "250 ok\n";
		}
	    } elsif (/^DATA/i) {
		if (!$rcpt[0]) {
		    $resp = "503 need mail\n";
		} elsif ($#rcpt == 0) {
		    $resp = "554 need rcpt\n";
		} else {
		    $resp = "354 go on\n";
		    $state = "data";
		}
	    } else {
		$resp = "502 not implemented\n";
	    }

	    if ($resp) {
		#print $resp;
		$client->print($resp);
		print LOG $resp;
	    } #else { print "NOTHING TO PRINT\n"; }
	}
	close LOG;
    }
    $client->close;
}
