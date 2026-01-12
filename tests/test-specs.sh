# skip if offline
if [ ! -z ${OFFLINE+x} ]; then
    exit 255
fi

cd specs
for spec in *.spec; do
    spectool -g $spec
    mock --rebuild --spec $spec --sources *.tar.gz \
        -r fedora-rawhide-x86_64 --resultdir tmp > /dev/null
    rm -f *.tar.gz tmp/*debug*.rpm tmp/*.src.rpm
    for rpm in tmp/*.rpm; do
        echo "RPM $rpm generated:"
        rpm -ql $rpm
        echo -e
    done
    rm -rf tmp
done
