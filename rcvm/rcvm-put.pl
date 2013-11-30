#!/usr/bin/perl

# translate perl -npe 's/\\/\\\\/g;' -e 's/\$/\\\$/g;'  < rcvm-put.pl
use MIME::Base64 qw(decode_base64);
use Digest::MD5;

$boundary = '';
@files = ();
%files = {};
$TO = '';

# get boundary string
while ( <> ) {
    if (/^Content-Type: multipart\/\w+; boundary=\"([^\"]+)\"/) {
	$boundary = "--$1";
    } elsif (/^From: ([!\n]+)/i) {
	$TO = $1;
    } elsif (/^$boundary\s+$/) { last; }
}

# get filenames 
while ( <> ) { last if /^\s+$/; } # eat headers
while ( <> ) { # get filenames
    last if /^\s+$/;
    chomp;
    push @files, ($_);
}
while ( <> ) { last if /^$boundary\s+$/; } # get to next part

# get attachments
while (@files > 0) {
    $is_text = 0;
    while ( <> ) { # eat headers and figure if attachment is text or binary
	if (/^\s+$/) { last; }
	elsif (/^Content-Type: text/) { $is_text = 1; }
    } 

    $filename = shift @files;
    open F, ">$filename";
    binmode F if (!$is_text) ;

    $_ = <>;
    while (! /^$boundary(\s|--)\s*$/o) {
	if ($is_text) { print F; }
	else { print F decode_base64($_) unless /^\s+$/o; }
	$_ = <>;
    }
    close F;

# get attachment md5
    $ctx = new Digest::MD5();
    open(F, "$filename");
    binmode(F);
    $ctx->addfile(*F);
    $files_md5{$filename} = $ctx->hexdigest;
}

foreach $k (keys %files_md5) {
    print "$files_md5{$k}        $k\n";
}

use Net::SMTP;

$RELAY = "smtp.up.edu.ph";
$FROM = "jon\@math.upd.edu.ph";

$smtp = new Net::SMTP($host);
$smtp->mail($FROM);
$smtp->to($TO);
$smtp->data;
$smtp->datasend("From: $FROM\nTo: $TO\n");
$smtp->datasend("Subject: RCVM-PUT ACK\n\n")
foreach $k (keys %files_md5) {
    $smtp->datasend("$files_md5{$k}    $k\n");
}
$smtp->dataend;
$smtp->quit;
