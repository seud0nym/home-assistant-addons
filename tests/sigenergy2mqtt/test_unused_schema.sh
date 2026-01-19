#!/bin/bash

cd "$(cd $(dirname $0)/../../sigenergy2mqtt; pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
RESULT=0

rm -f $LOG_PATH

while read -r missing_key; do
    echo "Unused schema key: $missing_key"
    RESULT=1
done >> $LOG_PATH 2>&1 < <(comm -13 \
    <(yq -r '.schema
            | with_entries(select(.value | tag == "!!map"))
            | to_entries[]
            | .key as $section
            | .value | keys[] as $field
            | "\($section).\($field)"' config.yaml | sort) \
    <(grep -vE '[[:space:]]*#' rootfs/etc/services.d/sigenergy2mqtt/run | grep -oE "bashio::(config|config.has_value) '[^']*" | cut -d"'" -f2 | sort -u) \
    )

exit $RESULT