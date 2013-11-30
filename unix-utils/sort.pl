#!/usr/bin/perl

$usage = 
"sort [-t sep] [-k fieldnum] [-n] < sortme
        -t sep      : sep as separator. by default a line is taken as a string
                      if -k or -n is not specified, else defaults to
                      [\\t\\n ] as the separator for split().
        -k fieldnum : sort using fieldnum'th field as key. if -t 
                      is specified defaults fieldnum to 0.
        -n          : numeric sort, default is string sort
        -h          : display this help page
";

use Getopt::Std qw(getopts);

getopts('nt:k:h', \%opts);

die $usage if ($opts{h});

# get all lines
@lines = <>;

if (! ($opts{t}||$opts{k}||$opts{n})) {
    @sorted = sort @lines;
} else {
    $opts{k} = 0 if (!$opts{k});
    $opts{t} = '[\n\t ]' if (!$opts{t});

    sub nth {
	local $str = shift;
	local @tmp;
	@tmp = split /$opts{t}/, $str;
	return $tmp[$opts{k}];
    }

    # precompute, because sort() may need to compute the key
    # for each line several times. stolen from 'Perl Cookbook'
    # note that [...] in map() returns array references and not
    # arrays, therefore @precompute is an array of array references
    @precompute = map { [nth($_),$_] } @lines;

    if ($opts{n}) {
	@sorted_precompute = sort { $a->[0] <=> $b->[0] } @precompute;
    } else {
	@sorted_precompute = sort { $a->[0] cmp $b->[0] } @precompute;
    }

    @sorted = map { $_->[1] } @sorted_precompute;

    # simpler version
#    if ($opts{n}) {
#	@sorted = sort { nth($a) <=> nth($b) } @lines;
#    } else {
#	@sorted = sort { nth($a) cmp nth($b) } @lines;
#    }
}

foreach (@sorted) { print; }

