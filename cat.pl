#!/usr/bin/perl -w

# verified
#
for ($i = 0; $i <= $#ARGV; $i++) {    
    open(F, $ARGV[$i]) || next;
    while ( <F> ) { syswrite STDIN, $_, length($_) }
}
