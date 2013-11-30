#!/usr/bin/perl
#
# REMOTE CONTROL VIA MAIL

use Net::SMTP;
$FROM = $ENV{USER};

sub mail {
    my $host = shift;
    my $rcpt = shift;
    my $subject = shift;
    my $data = shift;

    print "from: $FROM\n";
    $smtp = new Net::SMTP($host);
    print "smtp: $host\n";
    $smtp->mail($ENV{USER});
    $smtp->to($rcpt);
    $smtp->data;
    $smtp->datasend("From: $FROM\nTo: $rcpt\@$host\nSubject: $subject\n\n");
    $smtp->datasend($data);
    $smtp->dataend;

    $smtp->quit;
    print "send ok! ($subject) [$rcpt@$host]\n";
}

$to = '';
$host = '';
$time = time();
$script = 0;

while ( <> ) {
    if ($script == 0) {
	if (/^From: (.*)/) {
	    $to = $1;
	    $to =~ /(\S+)@(\S+)/;
	    $to = $1;
	    $host = $2;
	    print "to: $to, host: $host\n";
	} elsif (/^Subject: RCVM (.*)/) {
	    $title = $1;
	} elsif (/^\#\!/) {
	    open(F, ">/tmp/script-$time");
	    print F;
	    $script = 1;
	}
    } elsif ($script == 1) {
	if (/^__END__\s+$/) {
	    close F;
	    $script = 2;
	} else { print F; }
    } else { last; }
}

# test the state
if ($script == 1) {
# implicit end of script if __END__ not found
    close F;
} elsif ($script != 2) {
# notify error
    mail($host, $to, "RCVM ERROR: No script found in $title!", "");
}

chmod 0500, "/tmp/script-$time";

$pid = fork();
if ($pid == 0) {
# child procees executes the script
    `/tmp/script-$time > /tmp/out-$time 2> /tmp/err-$time`;
    $ret = $?;
    unlink "/tmp/script-$time";
    exit($ret);
} elsif ($pid > 0) {
# first notify user that the script has started executing
    mail($host, $to, "RCVM STATUS: $title started", "");
# wait for the child process
    waitpid($pid, 0);
# mail the user again for results at out-$time and err-$time
# we'll do our mailing here, as out and err may be too big
    $smtp = new Net::SMTP($host);
    $smtp->mail($FROM);
    $smtp->to($to);
    $smtp->data;
    $smtp->datasend("From: $FROM\nTo: $to\n");
    $smtp->datasend("Subject: RCVM STATUS: $title finished [$?]\n\n");

    open(F, "/tmp/out-$time");
    $smtp->datasend("******************** STDOUT ********************\n");
    while ( <F> ) {
	$smtp->datasend($_);
    }

    open(F, "/tmp/err-$time");
    $smtp->datasend("******************** STDERR ********************\n");
    while ( <F> ) {
	$smtp->datasend($_);
    }

    $smtp->dataend;
    $smtp->quit;

    close F;
    unlink "/tmp/out-$time", "/tmp/err-$time";
} else {
# fork error, notify error
    mail($host, $to, "RCVM ERROR: fork error for $title\n");
}
