use strict;
use warnings;
use Test::More tests => 16;
use Path::Class qw{dir file};
BEGIN { use_ok('RF::Antenna::Planet::MSI::Format') };

my $antenna = RF::Antenna::Planet::MSI::Format->new;
isa_ok($antenna, 'RF::Antenna::Planet::MSI::Format');

is($antenna->name("My Name"),            'My Name', 'name');
$antenna->horizontal([[0=>1.1], [1=>1.2], [2=>1.3]]);
$antenna->vertical  ([[0=>2.1], [1=>2.2], [2=>2.3]]);

my $file = $antenna->write; #write to temp folder
ok(-r $file, 'file is readable');
ok(-s $file, 'file has size');
isa_ok($file, 'Path::Class::File');
my $data = join "", <DATA>;
is($file->slurp, $data);

my $ant2 = RF::Antenna::Planet::MSI::Format->new->read($file);
is($ant2->name("My Name"),            'My Name', 'name');
isa_ok($ant2->header, 'HASH');
isa_ok($ant2->horizontal, 'ARRAY');
isa_ok($ant2->vertical, 'ARRAY');
is($ant2->header->{'NAME'}, 'My Name', 'header hash');
is($ant2->horizontal->[0]->[0], 0, 'horizontal array ref');
is($ant2->horizontal->[0]->[1], 1.1, 'horizontal array ref');
is($ant2->vertical->[0]->[0], 0, 'vertical array ref');
is($ant2->vertical->[0]->[1], 2.1, 'vertical array ref');

__DATA__
NAME My Name
HORIZONTAL 3
0 1.1
1 1.2
2 1.3
VERTICAL 3
0 2.1
1 2.2
2 2.3
