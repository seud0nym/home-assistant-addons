#!/bin/bash

cd "$(cd $(dirname $0); pwd)"

test=$(find . -name "*$1*" | grep '\.sh$' | head -n 1)
if [ -z "$test" ]; then
    echo "No test found matching '*$1*'"
    exit 1
fi

test_name="$(basename "$test" .sh)"
echo "### Running: $test_name ###"
bash "$test"
result=$?
cat /tmp/${test_name}.log
if [ $result -ne 0 ]; then
    echo "### FAILED ###"
    exit 1
else
    echo "### PASSED ###"
    rm -rf /tmp/${test_name}*
fi

exit $result