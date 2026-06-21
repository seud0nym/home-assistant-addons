#!/bin/bash

export HOME="$(cd $(dirname $0); pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
export MOCK_OPTIONS_PATH="/tmp/${TEST_NAME}.yaml"

#region Scenario 1: Default: not configured
cat << EOF > $MOCK_OPTIONS_PATH
advanced:
auto_discovery:
manual_config:
pvoutput:
logging:
influxdb:
EOF

declare -A ASSERTIONS=(
    ["language"]="en"
    ["hass-enabled"]="true"
    ["SIGENERGY2MQTT_MQTT_BROKER"]="127.0.0.1" # Default
    ["SIGENERGY2MQTT_MQTT_PORT"]="1883" # Default
    ["SIGENERGY2MQTT_MQTT_TLS"]="false" # Default
    ["SIGENERGY2MQTT_MQTT_USERNAME"]="mock_mqtt_user" # Default
    ["SIGENERGY2MQTT_MQTT_PASSWORD"]="super_secret_mock_password" # Default
    ["modbus-auto-discovery"]="once"
    ["no-metrics"]="true"
)

cd $HOME
source "../mock_bashio.sh"
source "../functions.sh"
export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?
if [ $RESULT -ne 0 ]; then
    echo "Scenario 1 failed with result $RESULT"
    exit $RESULT
fi
#endregion

#region Scenario 2: Configured but false
cat << EOF > $MOCK_OPTIONS_PATH
advanced:
    metrics_enabled: false
    edit_pct_box: false
    sigenergy_local_modbus_naming: false
auto_discovery:
manual_config:
    read_only: false
    no_remote_ems: false
    no_ems_mode_check: false
pvoutput:
    enabled: false
    consumption: false
    exports: false
    imports: false
logging:
influxdb:
    enabled: false
EOF

unset ASSERTIONS
declare -A ASSERTIONS=(
    ["language"]="en"
    ["hass-enabled"]="true"
    ["SIGENERGY2MQTT_MQTT_BROKER"]="127.0.0.1" # Default
    ["SIGENERGY2MQTT_MQTT_PORT"]="1883" # Default
    ["SIGENERGY2MQTT_MQTT_TLS"]="false" # Default
    ["SIGENERGY2MQTT_MQTT_USERNAME"]="mock_mqtt_user" # Default
    ["SIGENERGY2MQTT_MQTT_PASSWORD"]="super_secret_mock_password" # Default
    ["modbus-auto-discovery"]="once"
    ["no-metrics"]="true"
)
export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?
if [ $RESULT -ne 0 ]; then
    echo "Scenario 2 failed with result $RESULT"
    exit $RESULT
fi
#endregion

#region Scenario 3: Enabled
cat << EOF > $MOCK_OPTIONS_PATH
advanced:
    metrics_enabled: true
    edit_pct_box: true
    sigenergy_local_modbus_naming: true
    read_only: true
    no_remote_ems: true
    no_ems_mode_check: true
auto_discovery:
manual_config:
    host: "127.0.0.1"
pvoutput:
    enabled: true
    system_id: "system_id"
    api_key: "api_key"
    consumption: true
    exports: true
    imports: true
logging:
influxdb:
    enabled: true
    host: "a0d7b954-influxdb"
    port: 8086
    username: "username"
    password: "password"
    database: "database"
EOF

unset ASSERTIONS
declare -A ASSERTIONS=(
    ["language"]="en"
    ["hass-enabled"]="true"
    ["hass-edit-pct-box"]="true"
    ["hass-sigenergy-local-modbus-naming"]="true"
    ["SIGENERGY2MQTT_MQTT_BROKER"]="127.0.0.1" # Inherited
    ["SIGENERGY2MQTT_MQTT_PORT"]="1883" # Inherited
    ["SIGENERGY2MQTT_MQTT_TLS"]="false" # Default
    ["SIGENERGY2MQTT_MQTT_USERNAME"]="mock_mqtt_user" # Default
    ["SIGENERGY2MQTT_MQTT_PASSWORD"]="super_secret_mock_password" # Default
    ["modbus-host"]="127.0.0.1"
    ["modbus-readonly"]="true"
    # ["modbus-no-remote-ems"]="true" # Will be missing because readonly == true
    # ["modbus-no-ems-mode-check"]="true" # Will be missing because readonly == true
    ["pvoutput-enabled"]="true"
    ["pvoutput-system-id"]="system_id"
    ["pvoutput-api-key"]="api_key"
    ["pvoutput-consumption"]="true"
    ["pvoutput-exports"]="true"
    ["pvoutput-imports"]="true"
    ["pvoutput-output-hour"]="-1"
    ["influxdb-enabled"]="true"
    ["influxdb-host"]="a0d7b954-influxdb"
    ["influxdb-port"]="8086"
    ["influxdb-username"]="username"
    ["influxdb-password"]="password"
    ["influxdb-database"]="database"
)
export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?
if [ $RESULT -ne 0 ]; then
    echo "Scenario 3 failed with result $RESULT"
    exit $RESULT
fi
#endregion

exit 0
