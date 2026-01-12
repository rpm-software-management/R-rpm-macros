Name:           R-units
Version:        %R_rpm_version 1.0-0
Release:        %autorelease
Summary:        Measurement Units for R Vectors

License:        GPL-2
URL:            %cran_url
Source:         %cran_source

BuildRequires:  R-devel
BuildRequires:  udunits2-devel

%description
Support for measurement units in R vectors, matrices and arrays: automatic
propagation, conversion, derivation and simplification of units; raising
errors in case of unit incompatibility. Compatible with the POSIXct, Date
and difftime classes. Uses the UNIDATA udunits library and unit database
for unit compatibility checking and conversion. Documentation about 'units'
is provided in the paper by Pebesma, Mailund & Hiebert (2016,
<doi:10.32614/RJ-2016-061>), included in this package as a vignette; see
'citation("units")' for details.

%prep
%autosetup -c

%generate_buildrequires
%R_buildrequires

%build

%install
%R_install
%R_save_files

%check
%R_check

%files -f %{R_files}

%changelog
%autochangelog
