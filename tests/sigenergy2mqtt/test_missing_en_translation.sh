#!/bin/bash

cd "$(cd $(dirname $0)/../../sigenergy2mqtt; pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
RESULT=0

rm -f $LOG_PATH

while read -r missing_key; do
    echo "Missing translation for schema key: $missing_key"
    RESULT=1
done >> $LOG_PATH 2>&1 < <(comm -23 \
    <(yq -r '.schema
            | with_entries(select(.value | tag == "!!map"))
            | to_entries[]
            | .key as $section
            | .value | keys[] as $field
            | "\($section).\($field)"' config.yaml | sort) \
    <(yq -r '.configuration
            | to_entries[]
            | .key as $section
            | .value.fields // {} | keys[] as $field
            | "\($section).\($field)"' translations/en.yaml | sort) \
    )

exit $RESULT