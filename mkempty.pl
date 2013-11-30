#!/usr/bin/perl

# program to make an empty file with a given length
# ala 'dd if=/dev/zero of=yourfile '

(@ARGV == 2) ||
die "usage: mkempty <outfile> <size>\n";

open(F, ">$ARGV[0]") ||
die "can't create file ($ARGV[0])\n";

($ARGV[1] =~ /(\d+)([kmg]?)/) || 
die "size format: <nnn>[k|m]\nk for kilobytes, m for megabytes, g for gigabytes\n";

$sz = $1;
if ($2 eq "k") { $sz = $sz * 1024; }
elsif ($2 eq "m") { $sz = $sz * (1024 * 1024);}
elsif ($2 eq "g") { $sz = $sz * (1024 * 1024 * 1024); }

print "size: $sz [$2]\n"; 

sysseek(F, $sz-1, 0) ||
die "can't seek!\n";

syswrite F, 0, 1;

close F;
