#!/bin/bash
# With no MQTT service and no MQTT overrides, no broker or credentials are
# exported and anonymous access is requested.

export HOME="$(cd $(dirname $0); pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
export MOCK_OPTIONS_PATH="/tmp/${TEST_NAME}.yaml"
export MOCK_MQTT_AVAILABLE=false

cat << EOF > $MOCK_OPTIONS_PATH
advanced:
auto_discovery:
manual_config:
pvoutput:
mqtt:
logging:
influxdb:
EOF

declare -A ASSERTIONS=(
    ["language"]="en"
    ["hass-enabled"]="true"
    ["diagnostics-host"]="0.0.0.0"
    ["diagnostics-allowed-ips"]="172.30.32.2"
    ["SIGENERGY2MQTT_MQTT_PORT"]="1883"
    ["SIGENERGY2MQTT_MQTT_TLS"]="false"
    ["SIGENERGY2MQTT_MQTT_ANONYMOUS"]="true"
    ["modbus-auto-discovery"]="once"
)

cd $HOME
source "../mock_bashio.sh"
source "../functions.sh"
export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
exit $?
