#!/bin/bash

cd "$(cd $(dirname $0)/../../sigenergy2mqtt; pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
RESULT=0

rm -f $LOG_PATH

for file in translations/*.yaml; do
    echo "Validating translations in $file" >> $LOG_PATH 2>&1
    yq eval '.' "$file" >> $LOG_PATH 2>&1
    [[ $? != 0 ]] && RESULT=1
done

exit $RESULT