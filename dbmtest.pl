#!/usr/bin/perl
#

#use DB_File;
tie(%db, "testdbm") || die "can't tie!\n";

$db{ps1} = "Test";
$db{path} = "Mic";

__END__
dbmopen(%db, "testdbm", 0644);
#$db{ps1} = "Test";
#$db{path} = "Mic";
foreach $key (keys(%db)) {
	print $db{$key},"\n";
}
dbmclose(%db);
