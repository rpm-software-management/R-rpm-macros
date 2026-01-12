export PATH=../:$PATH

# Generate file structure from base packages
# mkdir -p anRpackage/po
# FILES=$(dnf rq -q -l R-core | grep library/ \
#     | grep -v translations | grep -v /po/ | grep -v DESCRIPTION \
#     | cut -d/ -f 7 | sort | uniq)
# for f in $FILES; do
#     touch anRpackage/$f
# done
# FILES=$(dnf rq -q -l R-core | grep library/ \
#     | grep -v translations | grep /po/ \
#     | cut -d/ -f 8 | sort | uniq)
# for f in $FILES; do
#     touch anRpackage/po/$f
# done

buildroot=$(dirname $PWD)
R-files.R -b $buildroot -p /tests/anRpackage
