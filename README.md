# NAME

RF::Antenna::Planet::MSI::Format - RF Antenna Pattern File Reader and Writer in Planet MSI Format

# SYNOPSIS

    use RF::Antenna::Planet::MSI::Format;
    my $antenna = RF::Antenna::Planet::MSI::Format->new(%parameters);
    $antenna->name("Set Name");

    my $antenna = RF::Antenna::Planet::MSI::Format->new;
    $antenna->read($filename);

    my $file    = $antenna->write($filename);

# DESCRIPTION

This package reads and writes antenna radiation patterns in Planet MSI antenna format.

Planet is a RF propagation simulation tool initially developed by MSI. Planet was a 2G radio planning tool which has set a standard in the early days of computer aided radio network design. The antenna pattern file and the format which is currently known as ".msi" format or .msi-file has become a standard.

# CONSTRUCTORS

## new

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

## read

Reads an antenna pattern file and parses the data into the current object data structure.

    $antenna->read($filename);

## write

Writes the objects data to an antenna pattern file and returns a Path::Class file object of the written file.

    my $file     = $antenna->write($filename); #isa Path::Class::file
    my $tempfile = $antenna->write;            #isa Path::Class::file in temp directory

# METHODS

## header

Returns a header

    my $header_href = $antenna->header; #isa HASH
    $antenna->header(NAME => $myname, MAKE => $mymake);

## name

Name of the antenna

    my $name = $antenna->name;
    $antenna->name("My Antenna Name");

## make

Name of the manufacturer

    my $name = $antenna->name;
    $antenna->name("My Antenna Manufacturer");

## frequency

Frequency string as displayed in file

    my $name = $antenna->name;
    $antenna->name("My Antenna Name");

## gain

Antenna gain string as displayed in file (dBd is the default unit of measure)

## horizontal

An array reference of array references \[\[$angle1, $value1\], $angle2, $value2\], ...\]

Horizontal gain data points per horizontal angle relative to maximum gain being zero. Any value below zero is assumed to be negative. Minus sign is not used with these values

## vertical

An array reference of array references \[\[$angle1, $value1\], $angle2, $value2\], ...\]

Horizontal gain data points per horizontal angle relative to maximum gain being zero. Any value below zero is assumed to be negative. Minus sign is not used with these values

# SEE ALSO

Format Definition: [http://radiomobile.pe1mew.nl/?The\_program:Definitions:MSI](http://radiomobile.pe1mew.nl/?The_program:Definitions:MSI)

Antenna Pattern File Library [https://www.wireless-planning.com/msi-antenna-pattern-file-library](https://www.wireless-planning.com/msi-antenna-pattern-file-library)

# AUTHOR

Michael R. Davis, MRDVT

# COPYRIGHT AND LICENSE

MIT License

Copyright (c) 2022 Michael R. Davis
