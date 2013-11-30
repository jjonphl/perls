#! /usr/bin/perl

# usage: pingscan ip/netmask
# e.g. : pingscan 192.168.1.0/24

$usage = "usage: pingscan ip/netmask [bind_addr]\n";

die $usage if ($#ARGV < 0 || $#ARGV > 1);

@parts = split /\//, $ARGV[0];
die $usage if ($#parts != 1 || 
               $parts[1] !~ /\d+/ ||
               $parts[0] !~ /^(\d{1,3}\.){3}\d{1,3}$/ ||
               $parts[1] > 32 || $parts[1] < 1);

@octet = split /\./, $parts[0];
@octet_add = (0,0,0,0);
$hosts = 2 ** (32 - $parts[1]);

# mask octet
if ($parts[1] < 32) {
    $idx = 3;
    while ($parts[1] < $idx*8) { $idx--; }    
    
    $bits = 32 - $parts[1];
    
    for ( ; $idx < 4; $idx++) {
        $mask = $bits - (3-$idx)*8; # mask left to right        
        for ($i = 0; $i < $mask; $i++) {
            $octet[$idx] &= (255 ^ (2 ** $i));
        }
        $bits = $bits - $mask;
    }
}
    
sub or_octet {
    my $o1 = shift;
    my $o2 = shift;
    my $i;
    my @octet = (0,0,0,0);    
    for ($i = 0; $i < 4; $i++) {
        $octet[$i] = $$o1[$i] + $$o2[$i];
    }        
    return @octet;
}

use Net::Ping;

$ping = new Net::Ping("icmp");
$ping->bind($ARGV[1]) if ($#ARGV == 1);

for ($i = 0; $i < $hosts; $i++) {    
    $oct_str = join '.', or_octet(\@octet, \@octet_add);
    print "$oct_str\n" if $ping->ping($oct_str, 2);
    $octet_add[3]++;
    if ($octet_add[3] > 255) {
        $octet_add[3] = 0;
        $octet_add[2]++;
        if ($octet_add[2] > 255) {
            $octet_add[2] = 0;
            $octet_add[1]++;
            if ($octet_add[1] > 255) {
                $octet_add[1] = 0;
                $octet_add[0]++;
            }
        }
    }
}
    
