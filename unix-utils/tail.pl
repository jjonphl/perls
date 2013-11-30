#!/usr/bin/perl

$usage=
"tail [-n lines] < file
        -n lines : number of lines to print. default is 10
        -h       : display this help page
";

use Getopt::Std qw(getopts);

getopts('n:h', \%opts);

die $usage if ($opts{h});

$opts{n} = 10 if (! $opts{n});
$opts{n}--;
@rec = ();

while ( <> ) {
    shift @rec if ($#rec == $opts{n});
    push @rec, $_;
}

foreach (@rec) { print; }
