#!/bin/bash

export HOME="$(cd $(dirname $0); pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
export MOCK_OPTIONS_PATH="/tmp/${TEST_NAME}.yaml"

# Shared config
BASE_CONFIG="
auto_discovery:
    retries: 1
    timeout: 1
manual_config:
    host: 127.0.0.1
pvoutput:
mqtt:
logging:
smartport:
"

# Scenario: advanced.clean is true
cat << EOF > $MOCK_OPTIONS_PATH
advanced:
    clean: true
$BASE_CONFIG
EOF

export CALLS_LOG="/tmp/${TEST_NAME}_calls.log"
rm -f $CALLS_LOG

cd $HOME
source "../mock_bashio.sh"
source "../functions.sh"
# No export_assertions needed, we will check the log manually for both calls
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?

if [ $RESULT -ne 0 ]; then
    echo "Clean option test failed with result $RESULT"
    cat $LOG_PATH
    exit $RESULT
fi

# Check for the clean call
if ! grep -q "\-\-clean" $CALLS_LOG; then
    echo "Failed: --clean call not found in $CALLS_LOG"
    cat $CALLS_LOG
    exit 1
fi

# Check if advanced.clean was reset
if ! grep -q "Reset advanced.clean=false" $LOG_PATH; then
    echo "Failed: advanced.clean was not reset to false"
    exit 1
fi

# Check for the subsequent regular call (should NOT have --clean)
# We expect 2 lines in CALLS_LOG. The second one should be the regular call.
CALL_COUNT=$(wc -l < $CALLS_LOG)
if [ "$CALL_COUNT" -ne 2 ]; then
    echo "Failed: Expected 2 calls, got $CALL_COUNT"
    cat $CALLS_LOG
    exit 1
fi

LAST_CALL=$(tail -n 1 $CALLS_LOG)
if [[ "$LAST_CALL" == *"--clean"* ]]; then
    echo "Failed: Regular call (second call) contains --clean"
    echo "$LAST_CALL"
    exit 1
fi

# Clean option test passed
exit 0
