#!/bin/bash

cd "$(cd $(dirname $0)/../../sigenergy2mqtt; pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
RESULT=0

rm -f $LOG_PATH

branch="$(git branch --show-current)"
docker buildx build . -t test-sigenergy2mqtt-app:$branch >> $LOG_PATH 2>&1
RESULT=$?
if [ $RESULT -eq 0 ]; then
    snyk container test test-sigenergy2mqtt-app:$branch --file=Dockerfile >> $LOG_PATH 2>&1
    RESULT=$?
fi

exit $RESULT