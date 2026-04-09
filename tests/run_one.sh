#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <test_directory> <test_name>"
    exit 1
fi

cd "$(cd $(dirname $0); pwd)"
export PATH=$PATH:$(pwd)/$1/.local/bin

test=$(find $1 -name "*$2*" | grep '\.sh$' | head -n 1)
if [ -z "$test" ]; then
    echo "No test found matching '*$2*' in $1"
    exit 1
fi


test_name="$(basename "$test" .sh)"
echo "### Running: $test_name ###"
export __BASHIO_LOG_LEVEL="debug"
if shopt -qo xtrace; then
    bash -x "$test"
else
    bash "$test"
fi
result=$?
if [ -e /tmp/${test_name}.yaml ]; then
    echo "### Options: /tmp/${test_name}.yaml ###"
    cat /tmp/${test_name}.yaml
    echo "### End Options ###"
fi
echo "### Log: /tmp/${test_name}.log ###"
cat /tmp/${test_name}.log
echo "### End Log ###"
if [ $result -ne 0 ]; then
    echo "### FAILED ###"
    exit 1
else
    echo "### PASSED ###"
    rm -rf /tmp/${test_name}*
fi

exit $result