#!/usr/bin/perl

# console tagger

use MP3::Tag;
use Getopt::Std;

getopts('At:a:l:y:g:c:r:k:R',\%opts);

sub createID3v1Tagger {
    my ($opts, @opt_funcs);
    $opts = shift @_;
        
    push @opt_funcs, sub { $_[0]->artist($opts->{a}) } if ($opts->{a});
    if ($opts->{F}) {
        # filename as title
        push @opt_funcs, sub { $_[0]->song($_[2]) };
    } elsif ($opts->{t}) {
        # filename as specified
        push @opt_funcs, sub { $_[0]->song($_[1]) }
    }             
    push @opt_funcs, sub { $_[0]->album($opts->{l}) } if ($opts->{l});
    push @opt_funcs, sub { $_[0]->track($opts->{k}) } if ($opts->{k});
    push @opt_funcs, sub { $_[0]->year($opts->{y}) } if ($opts->{y});
    push @opt_funcs, sub { $_[0]->comment($opts->{c}) } if ($opts->{c});
    push @opt_funcs, sub { $_[0]->genre($opts->{g}) } if ($opts->{g});
    
    return sub {
        my ($id3v1, $filename) = @_;
        my $i;
        foreach $i (@opt_funcs) { $i->($id3v1,$filename); }
        $id3v1->write_tag;
    }
}

sub createID3v1Printer {
    my ($opts, @prints);
    $_ = shift @_;
        
    push @prints, sub { 'Title: ' . $_[0]->song } if /t/;
    push @prints, sub { 'Artist: ' . $_[0]->artist } if (/a/);
    push @prints, sub { 'Album: ' . $_[0]->album } if (/l/);
    push @prints, sub { 'Track: ' . $_[0]->track } if (/k/);
    push @prints, sub { 'Genre: ' . $_[0]->genre } if (/g/);
    push @prints, sub { 'Comment: ' . $_[0]->comment } if (/c/);
    push @prints, sub { 'Year: ' . $_[0]->year } if (/y/);
        
    return sub {
        my ($id3v1) = @_;
        my ($i, $s) = (0, '');
                
        foreach $i (@prints) { $s .= $i->($id3v1) . "\n" }
        return $s;
    }
}

if ($^O == 'MSWin32') {
    @list = map { glob($_) } @ARGV;
} else {
    @list = @ARGV;
}
push @list, glob('*.mp3') if $opts{A};

if (exists $opts{r} || $opts{R}) {
    if ($opts{r}) { $read = $opts{r}; } else { $read = 'talygck'; }
    $printer = createID3v1Printer($read);
    foreach (@list) {
        $mp3 = MP3::Tag->new($_);        
        $mp3->get_tags;
        print "File: $_\n";
        if (exists $mp3->{ID3v1}) {
            print $printer->($mp3->{ID3v1}) . "\n";
        } else { print "** File has no ID3v1 information! **\n\n"; }
            
        $mp3->close;
    }
} else {
    $tagger = createID3v1Tagger(\%opts);
    foreach (@list) {
        $mp3 = MP3::Tag->new($_);
        $mp3->get_tags;
        $mp3->new_tag('ID3v1') if !exists $mp3->{ID3v1};
        $tagger->($mp3->{ID3v1},$_);
        $mp3->close;
    }
}
