Name:           perl-RF-Antenna-Planet-MSI-Format
Version:        0.14
Release:        1%{?dist}
Summary:        RF Antenna Pattern File Reader and Writer in Planet MSI Format
License:        mit
Group:          Development/Libraries
URL:            http://search.cpan.org/dist/RF-Antenna-Planet-MSI-Format/
Source0:        http://www.cpan.org/modules/by-module/RF/RF-Antenna-Planet-MSI-Format-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch:      noarch
BuildRequires:  perl(ExtUtils::MakeMaker)
BuildRequires:  perl(Path::Class) >= 0.12
BuildRequires:  perl(Test::Number::Delta)
BuildRequires:  perl(Test::More)
BuildRequires:  perl(Scalar::Util)
BuildRequires:  perl(Tie::IxHash)
BuildRequires:  perl(RF::Functions) >= 0.04
BuildRequires:  perl(Archive::Zip)
BuildRequires:  perl(File::Temp)
Requires:       perl(Path::Class) >= 0.12
Requires:       perl(Scalar::Util)
Requires:       perl(Tie::IxHash)
Requires:       perl(RF::Functions) >= 0.04
Requires:       perl(Archive::Zip)
Requires:       perl(File::Temp)
Requires:       perl(:MODULE_COMPAT_%(eval "`%{__perl} -V:version`"; echo $version))

%description
This package reads and writes antenna radiation patterns in Planet MSI
antenna format.

%prep
%setup -q -n RF-Antenna-Planet-MSI-Format-%{version}

%build
%{__perl} Makefile.PL INSTALLDIRS=vendor
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT

make pure_install PERL_INSTALL_ROOT=$RPM_BUILD_ROOT

find $RPM_BUILD_ROOT -type f -name .packlist -exec rm -f {} \;
find $RPM_BUILD_ROOT -depth -type d -exec rmdir {} 2>/dev/null \;

%{_fixperms} $RPM_BUILD_ROOT/*

%check
make test

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%doc Changes CONTRIBUTING.md LICENSE META.json README.md
%{perl_vendorlib}/*
%{_mandir}/man3/*
%{_mandir}/man1/*
%{_bindir}/*


%changelog
