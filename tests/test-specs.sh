# skip if offline
if [ ! -z ${OFFLINE+x} ]; then
    exit 255
fi

cd specs
for spec in *.spec; do
    spectool -g $spec > /dev/null 2>&1
    mock -q --rebuild --spec $spec --sources *.tar.gz \
        -r fedora-rawhide-x86_64 --resultdir tmp
    rm -f *.tar.gz tmp/*debug*.rpm tmp/*.src.rpm
    for rpm in tmp/*.rpm; do
        rpm -ql $rpm | grep -v ".build-id"
        echo -e
    done
    rm -rf tmp
done
