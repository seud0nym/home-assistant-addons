#!/bin/bash

export HOME="$(cd $(dirname $0); pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
export MOCK_OPTIONS_PATH="/tmp/${TEST_NAME}.yaml"

#region Prepare mock sigenergy2mqtt options file
cat << EOF > $MOCK_OPTIONS_PATH
advanced:
auto_discovery:
    status: Disabled
    max_device_id: 10
manual_config:
pvoutput:
mqtt:
logging:
influxdb:
EOF
#endregion

#region Prepare expected assertions
declare -A ASSERTIONS=(
    ["language"]="en"
    ["hass-enabled"]="true" # Default
    ["SIGENERGY2MQTT_DIAGNOSTICS_ALLOWED_IPS"]="172.30.32.2" # Default
    ["SIGENERGY2MQTT_MQTT_BROKER"]="localhost" # Default
    ["SIGENERGY2MQTT_MQTT_PORT"]="1883" # Default
    ["SIGENERGY2MQTT_MQTT_TLS"]="false" # Default
    ["SIGENERGY2MQTT_MQTT_USERNAME"]="mock_mqtt_user" # Default
    ["SIGENERGY2MQTT_MQTT_PASSWORD"]="super_secret_mock_password" # Default
    ["no-metrics"]="true" # Default
)
#endregion

cd $HOME
source "../mock_bashio.sh"
source "../functions.sh"
export_assertions
mkdir -p /tmp/test_data/sigenergy2mqtt
touch /tmp/test_data/sigenergy2mqtt/auto-discovery.yaml
unshare -m bash -c '
    mkdir -p /data 
    mount --bind /tmp/test_data /data
    bash ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run
' > $LOG_PATH 2>&1
RESULT=$?
rm -rf /tmp/test_data
[ $RESULT -eq 1 ] && exit 0 || exit 1
exit $RESULT
