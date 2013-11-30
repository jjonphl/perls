#!/usr/bin/perl

use ExtUtils::Installed;

$inst = ExtUtils::Installed->new;
#print join("\n", $inst->modules);
print join("\n", $inst->files('Term::ReadLine'));