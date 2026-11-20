#!/bin/bash

export HOME="$(cd $(dirname $0); pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
export MOCK_OPTIONS_PATH="/tmp/${TEST_NAME}.yaml"

# Scenario: advanced.clear_validation_cache is true -> passed once, then reset to false
cat << EOF2 > $MOCK_OPTIONS_PATH
advanced:
    clear_validation_cache: true
auto_discovery:
    status: Disabled
manual_config:
    host: 127.0.0.1
pvoutput:
mqtt:
logging:
influxdb:
EOF2

declare -A ASSERTIONS=(
    ["language"]="en"
    ["hass-enabled"]="true"
    ["diagnostics-host"]="0.0.0.0"
    ["diagnostics-allowed-ips"]="172.30.32.2"
    ["SIGENERGY2MQTT_MQTT_BROKER"]="127.0.0.1"
    ["SIGENERGY2MQTT_MQTT_PORT"]="1883"
    ["SIGENERGY2MQTT_MQTT_TLS"]="false"
    ["SIGENERGY2MQTT_MQTT_USERNAME"]="mock_mqtt_user"
    ["SIGENERGY2MQTT_MQTT_PASSWORD"]="super_secret_mock_password"
    ["modbus-host"]="127.0.0.1"
    ["clear-validation-cache"]="true"
)

cd $HOME
source "../mock_bashio.sh"
source "../functions.sh"
export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?
if [ $RESULT -ne 0 ]; then
    exit $RESULT
fi

if ! grep -q "Reset advanced.clear_validation_cache=false" $LOG_PATH; then
    echo "Failed: advanced.clear_validation_cache was not reset to false"
    exit 1
fi
if [[ "$(yq '.advanced.clear_validation_cache' $MOCK_OPTIONS_PATH)" != "false" ]]; then
    echo "Failed: stored advanced.clear_validation_cache is not false"
    exit 1
fi

# Scenario: the stored (reset) configuration must not pass the option again
unset 'ASSERTIONS[clear-validation-cache]'
export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
exit $?
