#!/usr/bin/perl
#

use Net::SMTP;

$FROM="jon\@localhost.localdomain";
sub mail {
    my $host = shift;
    my $rcpt = shift;
    my $subject = shift;
    my $data = shift;

    print "1\n";
    $smtp = new Net::SMTP($host);
    print "2\n";
    $smtp->mail($rcpt);
    $smtp->to($rcpt);
    print "3\n";
    $smtp->data;
    print "4\n";
    $smtp->datasend("From: $FROM\nTo: $rcpt\nSubject: $subject\n\n");
    print "5\n";
    $smtp->datasend($data);
    print "6\n";
    $smtp->dataend;
    print "8\n";
    $smtp->quit;
}

mail('localhost', 'tux\@localhost.localdomain', 'hello with perl!', ' ');
