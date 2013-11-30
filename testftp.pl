#! /usr/bin/perl

# test if ftp client works with ms ftp servers...

use Net::FTP;

$hostname = "partner-test.accenture.com";
$username = "PM-Team";
$password = "Put.It.Here";

$ftp = Net::FTP->new($hostname);         # construct object
$ftp->login($username, $password);       # log in

print $ftp->ls(".");