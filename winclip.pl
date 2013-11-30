#!/usr/bin/perl

use Win32::Clipboard;

# the clipboard can contain only three of the following:
# a. text -> e.g. copied from notepad (IsText())
# b. files -> e.g. copied from windows explorer (IsFiles())
# c. bitmap -> everything else (IsBitmap())
# how does ms office edit intra app docs? com!
$clip = Win32::Clipboard();
$cont = $clip->Get();
@files = $clip->GetFiles();
print "get: $cont\n";
print "files: $files\n" if $clip->IsFiles();
