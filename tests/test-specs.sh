# skip if offline
if [ ! -z ${OFFLINE+x} ]; then
    exit 255
fi

cd specs
for spec in *.spec; do
    pkg=$(echo $spec | sed -e "s@^R-@@" -e "s/.spec$//")
    R2rpm $pkg -r fedora-rawhide-x86_64 --resultdir tmp > /dev/null
    rm -f tmp/*debug*.rpm tmp/*.src.rpm
    for rpm in tmp/*.rpm; do
        echo "RPM $rpm generated:"
        rpm -ql $rpm
        echo -e
    done
done

rm -rf tmp
