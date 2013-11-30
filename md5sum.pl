#! /usr/bin/perl
#

use Digest::MD5;

for ($i = 0; $i <= $#ARGV; $i++) {
    $ctx = new Digest::MD5();
    if (! open(F, "$ARGV[$i]")) {
        print "No such file: $ARGV[$i]\n";
	next;
    }
    binmode(F);
    $ctx->addfile(*F);
    $digest = $ctx->hexdigest;
    print "$digest    $ARGV[$i]\n";
}

