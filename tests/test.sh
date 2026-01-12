#!/bin/bash

set -euo pipefail
cd $(dirname $0)

for file in test-*.sh; do
    echo -n "Running $file... "
    sh $file 2>&1 > $file.out.new
    if [ ! -f $file.out ]; then
        echo "created $file.out"
        mv $file.out.new $file.out
        continue
    fi
    diff --color -u $file.out $file.out.new
    echo "done"
    rm $file.out.new
done
