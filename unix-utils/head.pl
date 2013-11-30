#!/usr/bin/perl

$usage=
"head [-n lines] < file
        -n lines : number of lines to print. default is 10
        -h       : display this help page
";

use Getopt::Std qw(getopts);

getopts('n:h', \%opts);

die $usage if ($opts{h});

$opts{n} = 10 if (! $opts{n});
$i = 0;

while ( <> ) {
    last if ($i >= $opts{n});
    $i++;
    print;
}

