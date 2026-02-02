#!/bin/bash

export HOME="$(cd $(dirname $0); pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
export MOCK_OPTIONS_PATH="/tmp/${TEST_NAME}.yaml"

#region Prepare mock sigenergy2mqtt options file
cat << EOF > $MOCK_OPTIONS_PATH
influxdb:
    enabled: true
    host: 192.168.1.100
    port: 8086
    token: my-super-secret-token
    org: my-org
    bucket: my-bucket
    include: 
        - sensor: sensor.energy_consumption
        - sensor: sensor.solar_yield
        - sensor: sensor.battery_soc
    exclude: 
        - sensor: sensor.uptime
        - sensor: sensor.wifi_signal
logging:
    sigenergy2mqtt: DEBUG
    influxdb: INFO
EOF
#endregion

#region Prepare expected assertions
declare -A ASSERTIONS=(
    ["influxdb-enabled"]="true"
    ["influxdb-host"]="192.168.1.100"
    ["influxdb-port"]="8086"
    ["influxdb-token"]="my-super-secret-token"
    ["influxdb-org"]="my-org"
    ["influxdb-bucket"]="my-bucket"
    # The mock executable aggregates these with |
    ["influxdb-include"]="sensor.energy_consumption|sensor.solar_yield|sensor.battery_soc"
    ["influxdb-exclude"]="sensor.uptime|sensor.wifi_signal"
    ["influxdb-log-level"]="INFO"
    ["log-level"]="DEBUG"
    # Default language added by run script if not specified
    ["language"]="en" 
    # Default config checks
    ["hass-enabled"]="true"
    ["no-metrics"]="true"
    ["mqtt-broker"]="127.0.0.1"
    ["mqtt-port"]="1883"
    ["mqtt-username"]="mock_mqtt_user"
    ["mqtt-password"]="super_secret_mock_password"
    ["modbus-auto-discovery"]="once"
)
#endregion

cd $HOME
source "../mock_bashio.sh"
source "../functions.sh"
export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?

if [ $RESULT -ne 0 ]; then
    echo "Test failed with exit code $RESULT"
    cat $LOG_PATH
fi

exit $RESULT
