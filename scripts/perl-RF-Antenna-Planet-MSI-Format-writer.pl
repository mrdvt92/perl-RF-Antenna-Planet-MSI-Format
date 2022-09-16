#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use RF::Antenna::Planet::MSI::Format;


my $filename = shift or die("Syntax: $0 filename\n");
my $antenna  = RF::Antenna::Planet::MSI::Format->new->read($filename);
$antenna->write(\my $blob);

print $blob;

__END__

=head1 NAME

perl-RF-Antenna-Planet-MSI-Format-writer.pl - Example Script to Write Antenna Pattern File

=cut
