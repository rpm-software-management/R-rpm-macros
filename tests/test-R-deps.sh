export PATH=../:$PATH

for case in "LinkingTo" "Depends" "Imports" \
            "LinkingTo Depends Imports" "Depends Imports" \
            "Suggests" "Provides"; do
    echo "# $case"
    echo anRpackage/DESCRIPTION | R-deps.R $case
done
