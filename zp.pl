#!/usr/local/bin/perl
use strict;
use warnings;

my $file = '/var/tmp/zpooliostat.info';
my %data;

my @categories = (
 'capacity', 'capacity',       # indices 0,1
 'operations', 'operations',   # indices 2,3
 'bandwidth', 'bandwidth',     # indices 4,5
 'total_wait', 'total_wait',   # indices 6,7
 'disk_wait', 'disk_wait',     # indices 8,9
 'syncq_wait', 'syncq_wait',   # indices 10,11
 'asyncq_wait', 'asyncq_wait', # indices 12,13
 'scrub',                      # index 14
 'trim',                       # index 15
 'rebuild'                     # index 16
);

my @types = (
 'alloc', # capacity
 'free', # capacity
 'read', # operation
 'write', # operation
 'read', # bandwidth
 'write', # bandwidth
 'read', # total_wait
 'write', # total_wait
 'read', # disk_wait
 'write', # disk_wait
 'read', # syncq_wait
 'write', # syncq_wait
 'read', # asyncq_wait
 'write', # asyncq_wait
 'wait', # scrub
 'wait', # trim
 'wait'  # rebuild
);

open(my $fh, '-|', 'zpool iostat -plvy 60') or die "Erreur exec zpool iostat: $!";

while (my $line = <$fh>) {
    chomp $line;

    next if $line =~ /^\s*$/ || $line =~ /^-+/;  # Ignore lignes vides

#    printf "DEBUG: $line\n";

    my @fields = split ' ', $line;
    my $pool = shift @fields;

    for (my $i = 0; $i < @fields; $i++) {

        my $category = $categories[ $i ];
        my $type = $types[ $i ];

        my $value = $fields[$i] eq '-' ? 0 : $fields[$i];
        $data{"$pool $category $type"} = $value;
    }

    # MAJ fichier lors de changement
    open(my $out, '>', "$file.new") or die "Erreur d'ouverture de $file.new: $!";
    foreach my $key (sort keys %data) {
        my ($p) = split ' ', $key;
        next if $p eq 'capacity' || $p eq 'pool';
        print $out "$key $data{$key}\n";

#        print "$key $data{$key}\n";
    }
    close($out);
    rename "$file.new", "$file.lines" or die "Erreur de mise à jour de $file: $!";

}
