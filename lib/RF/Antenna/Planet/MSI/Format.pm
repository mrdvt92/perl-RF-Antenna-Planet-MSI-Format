package RF::Antenna::Planet::MSI::Format;
use strict;
use warnings;
use Tie::IxHash;
use Path::Class;
use parent qw{Package::New};

our $VERSION = '0.01';

=head1 NAME

RF::Antenna::Planet::MSI::Format - RF Antenna Pattern File Reader and Writer in Planet MSI Format

=head1 SYNOPSIS

  use RF::Antenna::Planet::MSI::Format;
  my $antenna = RF::Antenna::Planet::MSI::Format->new(%parameters);
  $antenna->name("Set Name");

  my $antenna = RF::Antenna::Planet::MSI::Format->new;
  $antenna->read($filename);

  my $file    = $antenna->write($filename);

=head1 DESCRIPTION

This package reads and writes antenna radiation patterns in Planet MSI antenna format.

Planet is a RF propagation simulation tool initially developed by MSI. Planet was a 2G radio planning tool which has set a standard in the early days of computer aided radio network design. The antenna pattern file and the format which is currently known as ".msi" format or .msi-file has become a standard.

=head1 CONSTRUCTORS

=head2 new

Creates a new blank object for creating files or loading data from other formats

  my $antenna = RF::Antenna::Planet::MSI::Format->new->read($filename);

  my $antenna = RF::Antenna::Planet::MSI::Format->new(
                                                      name          => "my antenna name",
                                                      make          => "my manufacturer name",
                                                      frequency     => "2437" || "2437 MHz" || "2.437 GHz",
                                                      gain          => "10.0" || "10.0 dBd" || "12.14 dBi",
                                                      comment       => "My comment"
                                                      horizontal    => [[0.00, 0.96], [1.00, 0.04], ..., [180.00, 31.10], ..., [359.00, 0.04]],
                                                      vertical      => [[0.00, 1.08], [1.00, 0.18], ..., [180.00, 31.23], ..., [359.00, 0.18]],
                                                     );

=head2 read

Reads an antenna pattern file and parses the data into the current object data structure.

  $antenna->read($filename);

=cut

sub read {
  my $self  = shift;
  my $file  = shift;
  my $blob  = Path::Class::file($file)->slurp;
  my @lines = split(/[\n\r]+/, $blob);
  while (1) {
    my $line = shift @lines;
    $line =~ s/\A\s*//; #ltrim
    $line =~ s/\s*\Z//; #rtrim
    next unless $line;
    my ($key, $value) = split /\s+/, $line, 2;
    printf "Key: $key, Value: $value\n";
    if ($key =~ m/\AHORIZONTAL\Z/i) {
      my @data = map {[split /\s+/, $_, 2]} splice @lines, 0, $value;
      die(sprintf('Error: HORIZONTAL records with %s records returned %s records', $value, scalar(@data))) unless scalar(@data) == $value;
      $self->horizontal(\@data);
    } elsif ($key =~ m/\AVERTICAL\Z/i) {
      my @data = map {[split /\s+/, $_, 2]} splice @lines, 0, $value;
      die unless @data == $value;
      die(sprintf('Error: VERTICAL records with %s records returned %s records', $value, scalar(@data))) unless scalar(@data) == $value;
      $self->vertical(\@data);
    } else {
      $self->header($key => $value);
    }
    last unless @lines;
  }
  return $self;
}

=head2 write

Writes the objects data to an antenna pattern file and returns a Path::Class file object of the written file.

  my $file     = $antenna->write($filename); #isa Path::Class::file
  my $tempfile = $antenna->write;            #isa Path::Class::file in temp directory

=cut

sub write {
  my $self     = shift;
  my $filename = shift;
  my $fh;
  my $file;
  if (length $filename) {
    $file            = Path::Class::file($filename);
    $fh              = $file->open('w') or die(qq{Error: Cannot open "$filename" for writing});
  } else {
    require File::Temp;
    ($fh, $filename) = File::Temp::tempfile('antenna_pattern_XXXXXXXX', TMPDIR => 1, SUFFIX => '.msi');
    $file            = Path::Class::file($filename);
  }

  sub _print_fh_key_value {
    my $fh    = shift;
    my $key   = shift;
    my $value = shift;
    print $fh "$key $value\n";
  }

  my $header = $self->header; #isa Tie::IxHash ordered hash
  foreach my $key (keys %$header) {
    my $value = $header->{$key};
    _print_fh_key_value($fh, $key, $value) if length $value;
  }

  sub _print_fh_key_array {
    my $fh    = shift;
    my $key   = shift;
    my $array = shift;
    if (@$array) {
      _print_fh_key_value($fh, $key, scalar(@$array));
      foreach my $row (@$array) {
        my $key   = $row->[0];
        my $value = $row->[1];
        _print_fh_key_value($fh, $key, $value);
      }
    }
  }

  _print_fh_key_array($fh, uc($_), $self->$_) foreach qw{horizontal vertical};

  close $fh;
  return $file;
}

=head1 METHODS

=head2 header

Returns a header

  my $header_href = $antenna->header; #isa HASH
  $antenna->header(NAME => $myname, MAKE => $mymake);

=cut

sub header {
  my $self = shift;
  die("Error: header method requires key value pairs") if @_ % 2;
  unless (defined $self->{'header'}) {
    my %data = ();
    tie(%data, 'Tie::IxHash');
    $self->{'header'} = \%data;
  }
  while (@_) {
    my $key   = shift;
    my $value = shift;
    $self->{'header'}->{uc($key)} = $value;
  }
  return $self->{'header'};
}

=head2 name

Name of the antenna

  my $name = $antenna->name;
  $antenna->name("My Antenna Name");

=cut

sub name {
  my $self = shift;
  $self->header(NAME => shift) if @_;
  return $self->header->{'NAME'};
}

=head2 make

Name of the manufacturer

  my $name = $antenna->name;
  $antenna->name("My Antenna Manufacturer");

=cut

sub make {
  my $self = shift;
  $self->header(MAKE => shift) if @_;
  return $self->header->{'MAKE'};
}

=head2 frequency

Frequency string as displayed in file

  my $name = $antenna->name;
  $antenna->name("My Antenna Name");

=cut

sub frequency {
  my $self = shift;
  $self->header(FREQUENCY => shift) if @_;
  return $self->header->{'FREQUENCY'};
}

=head2 gain

Antenna gain string as displayed in file (dBd is the default unit of measure)

=cut

sub gain {
  my $self = shift;
  $self->header(GAIN => shift) if @_;
  return $self->header->{'GAIN'};
}

=head2 horizontal

An array reference of array references [[$angle1, $value1], $angle2, $value2], ...]

Horizontal gain data points per horizontal angle relative to maximum gain being zero. Any value below zero is assumed to be negative. Minus sign is not used with these values

=cut

sub horizontal {
  my $self = shift;
  $self->{'horizontal'} = shift if @_;
  return $self->{'horizontal'};
}

=head2 vertical

An array reference of array references [[$angle1, $value1], $angle2, $value2], ...]

Horizontal gain data points per horizontal angle relative to maximum gain being zero. Any value below zero is assumed to be negative. Minus sign is not used with these values

=cut

sub vertical {
  my $self = shift;
  $self->{'vertical'} = shift if @_;
  return $self->{'vertical'};
}

=head1 SEE ALSO

Format Definition: L<http://radiomobile.pe1mew.nl/?The_program:Definitions:MSI>

Antenna Pattern File Library L<https://www.wireless-planning.com/msi-antenna-pattern-file-library>

=head1 AUTHOR

Michael R. Davis, MRDVT

=head1 COPYRIGHT AND LICENSE

MIT License

Copyright (c) 2022 Michael R. Davis

=cut

1;
