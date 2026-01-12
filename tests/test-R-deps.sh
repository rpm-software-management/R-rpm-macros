export PATH=../:$PATH

echo "# LinkingTo"
echo anRpackage/DESCRIPTION | R-deps.R LinkingTo
echo "# Depends"
echo anRpackage/DESCRIPTION | R-deps.R Depends
echo "# Imports"
echo anRpackage/DESCRIPTION | R-deps.R Imports
echo "# LinkingTo Depends Imports"
echo anRpackage/DESCRIPTION | R-deps.R LinkingTo Depends Imports
echo "# Depends Imports"
echo anRpackage/DESCRIPTION | R-deps.R Depends Imports
echo "# Suggests"
echo anRpackage/DESCRIPTION | R-deps.R Suggests
echo "# Provides"
echo anRpackage/DESCRIPTION | R-deps.R Provides
