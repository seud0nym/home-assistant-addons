#!/bin/bash

cd "$(cd $(dirname $0)/../../sigenergy2mqtt; pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
RESULT=0

rm -f $LOG_PATH

while read -r name; do
    if ! grep -qE "[>\`]$name[<\`]" DOCS.md; then
        echo "Schema key '$name' is not documented in DOCS.md"
        RESULT=1
    fi
done >> $LOG_PATH 2>&1 < <(yq '.configuration.*.fields.*.name' translations/en.yaml | grep -v null | sort)

exit $RESULT