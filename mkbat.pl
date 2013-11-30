#! /usr/bin/perl

# makes an MS batch file given a perl script
# actually only does some prepending and appending 
# of bat tricks

use File::Basename qw(basename);

$usage = 
"usage: $ARGV[-1] perlscript1.pl perlscript2.pl...
    consider using pl2bat from the standard perl dist
    for windows
";

die "$usage\n" if ($#ARGV < 0);

$head = "\@rem = '--*-Perl-*--
\@echo off
if \"%OS%\" == \"Windows_NT\" goto WinNT
perl -x -S \"%0\" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto endofperl
:WinNT
perl -x -S %0 %*
if NOT \"%COMSPEC%\" == \"%SystemRoot%\\system32\\cmd.exe\" goto endofperl
if %errorlevel% == 9009 echo You do not have Perl in your PATH.
if errorlevel 1 goto script_failed_so_exit_with_non_zero_val 2>nul
goto endofperl
@rem ';
";

$tail = "__END__
:endofperl";

foreach $script (@ARGV) {
    $name = basename($script, ('.pl'));
    if (! open(IN,"$script")) {
        print "Can't open $script!\n";
        next;
    }
    open F, ">${name}.bat";
    print F $head;
    while ( <IN> ) {
        print F;
    }
    print F $tail;
    close(F);
    close(IN);
}