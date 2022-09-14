use strict;
use warnings;
use Test::More tests => 11;
BEGIN { use_ok('RF::Antenna::Planet::MSI::Format') };

my $antenna = RF::Antenna::Planet::MSI::Format->new;
isa_ok($antenna, 'RF::Antenna::Planet::MSI::Format');

can_ok($antenna, 'new');
can_ok($antenna, 'read');
can_ok($antenna, 'write');

can_ok($antenna, 'header');
can_ok($antenna, 'horizontal');
can_ok($antenna, 'vertical');

can_ok($antenna, 'name');
can_ok($antenna, 'gain');
can_ok($antenna, 'frequency');
