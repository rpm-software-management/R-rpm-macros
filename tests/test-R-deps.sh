export PATH=../:$PATH

echo anRpackage/DESCRIPTION | R-deps.R LinkingTo
echo anRpackage/DESCRIPTION | R-deps.R Depends
echo anRpackage/DESCRIPTION | R-deps.R Imports
echo anRpackage/DESCRIPTION | R-deps.R Suggests
echo anRpackage/DESCRIPTION | R-deps.R Provides
