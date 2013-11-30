#!/usr/bin/perl

use MIME::Base64 qw(decode_base64);

$part = -1;
$boundary = '';
$newpart = 0;
@files = ();
%files = {};

while ( <> ) {
    if (/^Content-Type: / && $part < 0) { 
# get 'boundary' string
	/boundary=\"([^\)]+)\"/;
	$boundary = $1;
    } elsif (/^\-{2}$boundary\s+$/) {
	$part++;
	$newpart = 1;
    } elsif ($part == 0 && $newpart) { # we are at the first part
	$newpart = 0;
	while ( <> ) {
	    print ;
# newline indicates end of header
	    if (/^\s?$/) { last; } 
	    elsif (/^\-{2}$boundary\s+$/) { 
		$part++; $newpart = 1; last; 
	    } else { push @files, ($_); }
	}
    } elsif ($part > 0 && $newpart && @files > 0) { 
# we are collecting attachments now
	$newpart = 0;

	$content = ''; 
	while ( !/^\s+$/ ) { # find content type and eat headers
	    if (/^Content-Type: (\w+\/\w+);/) {
		$content = $1;
	    }
	    $_ = <>;
	} 

	$filename = shift @files;
	print "file: $filename\n";
	open F, ">$filename";
	if ($content =~ /text/) { $content = 1; }
	else { binmode(F); $content = 0; }

	$_ = <>;
	while ( !/^\-{2}$boundary\s+$/ ) {
	    if ($content) { print F; }
	    else { print F decode_base64($_); }
	    $_ = <>;
	}
	close F;
	$newcontent = 1; $part++;
    }

}

print "[$part] $boundary\n";
