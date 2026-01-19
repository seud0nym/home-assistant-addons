#!/bin/bash

export HOME="$(cd $(dirname $0); pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
export MOCK_OPTIONS_PATH="/tmp/${TEST_NAME}.yaml"

touch $MOCK_OPTIONS_PATH

cd $HOME
source "../mock_bashio.sh"
source "../functions.sh"

#region Test PVOutput missing keys
cat << EOF > $MOCK_OPTIONS_PATH
advanced:
auto_discovery:
    retries: 1
    timeout: 1
manual_config:
    host: 127.0.0.1
pvoutput:
    enabled: true
mqtt:
logging:
smartport:
EOF

# We expect this to fail
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?
if [ $RESULT -eq 0 ]; then
    echo "Expected failure for missing PVOutput keys, but got success"
    exit 1
fi
grep -q "PVOutput enabled, but API Key and/or System ID not found" $LOG_PATH
if [ $? -ne 0 ]; then
   echo "Did not find expected error message for PVOutput missing keys"
   echo "--- LOG START ---"
   cat $LOG_PATH
   echo "--- LOG END ---"
   exit 1
fi
#endregion

#region Test SmartPort missing module and topic
cat << EOF > $MOCK_OPTIONS_PATH
advanced:
auto_discovery:
    retries: 1
    timeout: 1
manual_config:
    host: 127.0.0.1
pvoutput:
mqtt:
logging:
smartport:
    enabled: true
EOF

# We expect this to fail
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?
if [ $RESULT -eq 0 ]; then
    echo "Expected failure for missing SmartPort keys, but got success"
    exit 1
fi
grep -q "Smart-Port enabled, but neither module name or MQTT topic found" $LOG_PATH
if [ $? -ne 0 ]; then
   echo "Did not find expected error message for SmartPort missing keys"
   echo "--- LOG START ---"
   cat $LOG_PATH
   echo "--- LOG END ---"
   exit 1
fi
#endregion

exit 0
