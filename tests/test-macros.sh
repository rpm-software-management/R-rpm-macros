SRPM=../macros.R-srpm
RPM=../macros.R-rpm

CMD="rpm -E '%{load:$SRPM}' -E '%{load:$RPM}'"
DEF="-D 'name R-anRpackage' -D 'version %R_rpm_version 1.2-3'"

for case in '%__R_ext' '%__R_name' '%__R_version' '%_R_libdir' \
            '%cran_url' '%cran_source' '%bioc_url' '%bioc_source' \
            '%bioc_url data/annotation' '%bioc_source data/annotation'; do
    echo "# $case"
    eval "$CMD $DEF -D '_target_cpu x86_64' -E '$case'"
    eval "$CMD $DEF -D '_target_cpu noarch' -E '$case'"
    echo -e
done
