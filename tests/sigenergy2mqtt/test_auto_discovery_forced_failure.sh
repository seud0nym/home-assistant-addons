#!/bin/bash

export HOME="$(cd $(dirname $0); pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
export MOCK_OPTIONS_PATH="/tmp/${TEST_NAME}.yaml"

#region Prepare mock sigenergy2mqtt options file
cat << EOF > $MOCK_OPTIONS_PATH
advanced:
auto_discovery:
    force: true
manual_config:
    host: 127.0.0.1
pvoutput:
mqtt:
logging:
smartport:
EOF
#endregion

#region Prepare expected assertions
declare -A ASSERTIONS=(
    ["hass-enabled"]="true" # Default
    ["mqtt-broker"]="127.0.0.1" # Default
    ["mqtt-port"]="1883" # Default
    ["mqtt-username"]="mock_mqtt_user" # Default
    ["mqtt-password"]="super_secret_mock_password" # Default
    ["consumption"]="calculated" # Default
    ["no-metrics"]="true" # Default
    ["modbus-host"]="127.0.0.1"
)
#endregion

cd $HOME
source "../mock_bashio.sh"
source "../functions.sh"
export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?
exit $RESULT
