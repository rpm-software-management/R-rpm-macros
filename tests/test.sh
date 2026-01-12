#!/bin/bash

set -uo pipefail
cd $(dirname $0)
export LANG=C.UTF-8

for file in test-*.sh; do
    echo -n "Running $file... "
    set +e
    sh $file 2>&1 > $file.out.new
    if [ $? -eq 255 ]; then
        echo "skipped"
        rm $file.out.new
        continue
    fi
    if [ ! -f $file.out ]; then
        echo "created $file.out"
        mv $file.out.new $file.out
        continue
    fi
    set -e
    diff --color -u $file.out $file.out.new
    echo "done"
    rm $file.out.new
done
