#!/bin/bash

cd "$(cd $(dirname $0)/../..; pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
RESULT=0

rm -f $LOG_PATH

pytest tests/unit/test_translations_validity.py --maxfail=0 >> $LOG_PATH 2>&1
RESULT=$?

exit $RESULT