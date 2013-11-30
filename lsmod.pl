#! /usr/bin/perl 

use File::Find;
#use File::Basename qw(fileparse, dirname);

$curpath = '';

sub wanted {
    my ($path, $mod);
    #print "${File::Find::dir}\n$curpath\n";
    #return;
    if (/\.pm$/) {
	$path = $File::Find::dir;
	if (length($path) > length($curpath)) {
	    $path =~ /${curpath}\/?(.*)/;
	    $path = $1 . '/';
	    return if (! $path =~ /^[A-Z]/ );
	    $path =~ s/\//::/g;
	} else { $path = ''; }
	$mod = $_;
	$mod =~ /(.*)\.pm$/;
	$mod = $1;
	print "${path}${mod}\n";
    }
}

foreach $curpath (@INC) {
    File::Find::find({wanted => \&wanted}, $curpath);
}
