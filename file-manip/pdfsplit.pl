#!/usr/bin/perl

use PDF::Extract;

die "usage: pdfsplit <infile> <range> [<outfile>]\n" unless (@ARGV >= 2);

$out = (@ARGV == 3) ? $ARGV[2] : "out-$ARGV[0]";

$pdf = new PDF::Extract(PDFDoc => $ARGV[0], 
            PDFPages => $ARGV[1], PDFSaveAs => $out);

$pdf->savePDFExtract;
#$out = $pdf->getPDFExtract;
#syswrite OUT, $out, length($out);
#close OUT;
