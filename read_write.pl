#!/usr/bin/perl
use v5.10;
use lib qw{lib};
use Data::Dumper qw{Dumper};
use RF::Antenna::Planet::MSI::Format;

my $antenna  = RF::Antenna::Planet::MSI::Format->new;
my $filename = shift or die;
$antenna->read($filename);

say Dumper $antenna;

say $antenna->write;
