#!/usr/bin/perl

$usage=
"grep [-B|A n] [-c] [-v] [-i] [-l] [-L] [-h] pattern files...
        -B|A n   : display n lines before|after matching line.
        -c       : count only, don't display matches.
        -v       : display lines that does not match. with -v, display
                   number of lines that do not match.
        -i       : case insensitive.
        -l       : display only file names whose contents match the.
                   pattern at least once.
        -L       : opposite of -l.
        -h       : when matching several files, default is to print
                   filename before the matching line. this option disables
                   prepending of filename.
        pattern  : pattern to be used in matching, may be reg exp.
        files... : search these files.
";
