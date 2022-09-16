use ExtUtils::MakeMaker;
WriteMakefile(
    NAME           => 'RF::Antenna::Planet::MSI::Format',
    VERSION_FROM   => 'lib/RF/Antenna/Planet/MSI/Format.pm',
    PREREQ_PM      => {
                       'Scalar::Util' => 0,
                       'Tie::IxHash'  => 0,
                       'Path::Class'  => 0.12, #chomp while you slurp
                      },
    ABSTRACT_FROM  => 'lib/RF/Antenna/Planet/MSI/Format.pm',
    AUTHOR         => 'Michael R. Davis',
);
