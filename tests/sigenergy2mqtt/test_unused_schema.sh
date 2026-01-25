#!/bin/bash

cd "$(cd $(dirname $0)/../../sigenergy2mqtt; pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
RESULT=0

rm -f $LOG_PATH

for option in $(yq -r '.schema
            | with_entries(select(.value | tag == "!!map"))
            | to_entries[]
            | .key as $section
            | .value | keys[] as $field
            | "\($section).\($field)"' config.yaml | sort); do
    if ! grep -vE '^[[:space:]]*(#|\[".+"\]=")' rootfs/etc/services.d/sigenergy2mqtt/run | grep -q "$option"; then
        echo "Schema key '$option' is not used in the run script"
        RESULT=1
    fi
done >> $LOG_PATH 2>&1

exit $RESULT