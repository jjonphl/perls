#!/usr/bin/perl

use Getopt::Std qw(getopts);

getopts('nt:k:', \%opts);

print "$opts{n}\n$opts{k}\n$opts{t}\n";
print "@ARGV\n";
