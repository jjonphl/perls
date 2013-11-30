#! /usr/bin/perl

# usage: benchmark.pl times command [arg...]

use Benchmark;

die "usage: benchmark.pl times command\n" if ($#ARGV < 1);

$times = shift @ARGV;
timethis($times, "`@ARGV`");
