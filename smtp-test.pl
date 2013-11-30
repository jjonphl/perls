#!/usr/bin/perl

# dummy smtp server, log transaction

use Net::SMTP;

# yahoo: mx1.mail.yahoo.com
#$from = "jjonphl2\@yahoo.com";
#$to_host = "mail01.up.edu.ph";
#$to = "mrmanese\@up.edu.ph";

$from = "jjonphl2\@yahoo.com";
$to_host = "localhost";
$to = "jon";

$smtp = new Net::SMTP($to_host) || die "what!?\n";
$smtp->mail($from);
$smtp->to($to);
$smtp->data("From: $from
To: $to\nSubject: Testing Net::SMTP\n\nHello!");
$smtp->dataend();
$smtp->quit();
