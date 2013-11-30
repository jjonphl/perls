#!/usr/bin/perl

# interactive tagger

use MP3::Tag;
use Getopt::Std;
use Term::ReadLine;

getopts('AFt:a:l:y:g:c:k:',\%opts);

sub createID3v1Tagger {
    my ($opts, %opt_funcs);
    $opts = shift @_;
        
    $opt_funcs{Artist} = sub { $_[0]->artist($_[1]) } if ($opts->{a});
    $opt_funcs{Title} = sub { $_[0]->song($_[1]) } if ($opts->{t});
    $opt_funcs{Album} = sub { $_[0]->album($_[1]) } if ($opts->{l});
    $opt_funcs{Track} = sub { $_[0]->track($_[1]) } if ($opts->{k});
    $opt_funcs{Year} = sub { $_[0]->year($_[1]) } if ($opts->{y});
    $opt_funcs{Comment} = sub { $_[0]->comment($_[1]) } if ($opts->{c});
    $opt_funcs{Genre} = sub { $_[0]->genre($_[1]) } if ($opts->{g});
    
    return sub {
        my ($id3v1, $term) = @_;
        my $i;
        foreach $i (keys(%opt_funcs)) { 
            $opt_funcs{$i}->($id3v1, $term->readline($i . ': '))
        }
        $id3v1->write_tag;
    }
}

if ($^O == 'MSWin32') {
    @list = map { glob($_) } @ARGV;
} else {
    @list = @ARGV;
}
push @list, glob('*.mp3') if $opts{A};

$tagger = createID3v1Tagger(\%opts);
$term = Term::ReadLine->new('itagger');

foreach (@list) {
    $mp3 = MP3::Tag->new($_);
    $mp3->get_tags;
    $mp3->new_tag('ID3v1') if !exists $mp3->{ID3v1};
    print "File: $_\n";
    $tagger->($mp3->{ID3v1}, $term);
    $mp3->close;
}
