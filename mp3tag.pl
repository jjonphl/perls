#!/usr/bin/perl

use MP3::Tag;

if (@ARGV == 0) {
    @files = glob('*.mp3');
} else {
    @files = @ARGV;
}

foreach $i (@files) {    
    $mp3 = MP3::Tag->new($i);
    $mp3->get_tags;    
    
    if (exists $mp3->{ID3v1}) {
        $idv3 = $mp3->{ID3v1};
        ($song, $artist, $album, $year, $comment, $track, $genre) = $idv3->all;
        print "Album: $album; Artist: $artist; Track: $track; Song: $song\n";
    }
    
    if (exists $mp3->{ID3v2}) {
        print "ID3v2: $i\n";
    }
    
    $mp3->close;
}