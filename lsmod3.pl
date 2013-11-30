#! /usr/bin/perl
#

# lists all available perl modules found in @INC
#

#BEGIN { use re; }
use re;

if ($^O eq 'MSWin32') { $sep = '\\'; }
else { $sep = '/'; }

sub find_pm {
    local $base = shift;
    local $path = shift;
    local $modpath = '';
    local @dirs = ();
	
    if (! $path == '') {
        $path =~ s/\/+/\//g;
        $path = $path . '/' unless ($path =~ /\/$/);
		
        $modpath = $path;
        $modpath =~ s/^\///;
        $modpath =~ s/\//::/g;
    }
    
    #print "modpath $modpath\n"; 
    #print "$base\n"; return;
    while (( $_ = glob("$base$path/*")) ) {
        /$base$path\/(.*)/;
        $file = $1;
        $g = $_;
        #print "globbed: $_, file: $file\n";
        
        if (-d "$_") {
            print "directory: $file\n";		
            push @dirs, "$file" if grep(/$g/, @INC) == 0;
        } elsif (/.*pm$/) {
            $curmod = $file;
            $curmod =~ s/\/?(.*)\.pm$/$1/;
            print "$modpath$curmod\n";
        }		
    }

    #print "dirs: @dirs\n";
    foreach $np (@dirs) {
        # print "np: $np\n";
        find_pm($base, "$path$np");
    }
}

foreach $i (@INC) {
    #print "$i\n";
    $i =~ s/ /\\ /g;
    find_pm($i, '');
}

