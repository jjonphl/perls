#! /usr/bin/perl

$usage = 
"tee [-a] outfile < infile\n
        -a : append to file
for a better perl tee, try tctee from 'Perl Cookbook.'

of course tee-ing to multiple files is equivalent to
$ cat infile | tee file1 | tee -a file2 | tee file3
";

die $usage if ($#ARGV < 0);

$openstr = ">" . $ARGV[$#ARGV];
$openstr = ">" . $openstr if ($#ARGV == 1 && $ARGV[0] eq "-a");
open F, $openstr || die "can't create/append ($openstr)\n";

while ( <STDIN> ) {
    print;
    print F;
}
