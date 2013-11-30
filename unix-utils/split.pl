#! /usr/bin/perl
#

$usage = 
"usage: split [-a <suffix_length>] <-b <bytes> | -l <lines>> file [ prefix ]
        -b <bytes> : number of bytes per output file or can be suffix-ed with
                     b for 512 byte multiple, k for 1kb and m for 1mb
        -l <lines> : number of lines per output file
        prefix     : prefix of file, default is 'x' (i.e. files produced
                     are named as [prefix]aa, [prefix]ab, ...
";

use Getopt::Std qw(getopts);

getopts("a:b:l:", \%opts);

die $usage if ($#ARGV < 0 || (!$opts{b} && !$opts{l}));
die "${usage}Only one of -b and -l can be used\n" if ($opts{b} && $opts{l});

open IN, "$ARGV[0]" || die "Can't open $ARGV[0]\n";

$prefix = "x";
$prefix = $ARGV[1] if ($#ARGV == 1);
$opts{a} = 2 unless $opts{a};
$filename = "a" x $opts{a};

# consistent with split, filenames are "numbered" with aa, ab, ac, .. zz
# i made the "initiative" to make aaa the number after zz
sub nextfilename {
    local $curname = shift;
    local $idx = -1;
    local $char;
    local $ret;
    local $len = length($curname);

    # find first non 'z' character
    $char = substr($curname, $idx, 1);
    while ( $char eq 'z' && -$idx <= $len) {
	$idx--;
	$char = substr($curname, $idx, 1);
    }

    # 
    if (-$idx <= length($curname)) {
	$char = chr(ord($char)+1);
	$ret = substr($curname, 0, ($len+$idx)) . $char . 
	    ("a" x abs($idx+1));
    } else {
	$ret = "a" x ($len+1);
    }
    return $ret;
}

if ($opts{b}) { # binary
    $opts{b} =~ /^(\d+)([bkm]?)$/ || 
	die "Can't parse number of bytes: $opts{b}\n";
    $bytes = $1;
    if ($2 eq 'b') { $bytes *= 512; }
    elsif ($2 eq 'k') { $bytes *= 1024; }
    elsif ($2 eq 'm') { $bytes *= 1024 * 1024; }

    $bufsz = 2048;
    $bufsz = $bytes if ($bytes < $bufsz);     
    # not efficient if $bytes not a power of 2, but heck

    binmode IN;
    
    my $readbytes = 1;
    while ($readbytes) {
	$filebytes = 0;
	$readsz = $bufsz;
	open OUT, ">$prefix$filename" || 
	    die "Can't open $prefix$filename\n";
        binmode OUT;
        
	while ($filebytes < $bytes) {
            $readbytes = read IN, $buf, $readsz;
	    last unless $readbytes; # eof
            
	    $filebytes += $readbytes;
	    $remaining = $bytes - $filebytes;
	    $readsz = ($remaining > $bufsz) ? $bufsz : $remaining;
            
            print OUT $buf;
	}

	close OUT;
	print "file: $prefix$filename\n";
	$filename = nextfilename($filename);
    }
} else { #text file
    $lines = $opts{l};
    @buf = ();

    while ( <IN> ) {
        # fill buf
	push @buf, $_;
	next if ($#buf < $lines-1);
       
        # write buf
	open OUT, ">$prefix$filename" || 
	    die "Can't open $prefix$filename\n";
	for ($i = 0; $i < $lines; $i++) {
	    print OUT $buf[$i];
	}
	close OUT;
	@buf = ();
	$filename = nextfilename($filename);
    }

    # write whatever's left in @buf
    if ($#buf > 0) {
	open OUT, ">$prefix$filename" || 
	    die "Can't open $prefix$filename\n";
	for ($i = 0; $i < $lines; $i++) {
	    print OUT $buf[$i];
	}
	close OUT;
    }
}
