#! perl

my $cur = time();
my $txtpath = "c:\\time.txt";
my $recpath = "c:\\rec.txt";

if ($#ARGV == -1) {
    (open F, "$txtpath" || ($prev = 0)) && ($prev = <F>);        
    ($sec, $min,$hr) = gmtime($cur-$prev);
    printf "%02d:%02d:%02d\n", ($hr, $min, $sec);    
} elsif ($ARGV[0] eq "start") {
    open F, ">$txtpath";
    print F "$cur";
    close F;    
} elsif ($ARGV[0] eq "rec") {
    (open F, "$txtpath" || ($prev = 0)) && ($prev = <F>);        
    ($sec,$min,$hr) = gmtime($cur-$prev);
    ($a,$b,$c,$day,$mon,$yr) = localtime($cur);
    open F, ">>$recpath";
    printf F "[%02d/%02d/%04d]: %02d:%02d:%02d\n",
        ($mon+1,$day,$yr+1900,$hr,$min,$sec);
}

