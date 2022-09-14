use 5.016003;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'RF::Antenna::Planet::MSI::Format',
    VERSION_FROM      => 'lib/RF/Antenna/Planet/MSI/Format.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/RF/Antenna/Planet/MSI/Format.pm', # retrieve abstract from module
       AUTHOR         => 'Michael R. Davis <mdavis@localdomain>') : ()),
);
