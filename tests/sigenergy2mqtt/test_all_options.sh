#!/bin/bash
set -o pipefail

# Requires: yq (https://github.com/mikefarah/yq/) version v4.50.1

export HOME="$(cd $(dirname $0); pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
export MOCK_OPTIONS_PATH="/tmp/${TEST_NAME}.yaml"

#region Prepare mock sigenergy2mqtt options file
cat << EOF > $MOCK_OPTIONS_PATH
advanced:
    clean: false
    consumption_method: Total Load
    edit_pct_box: true
    language: English
    metrics_enabled: true
    no_remote_ems: true
    no_ems_mode_check: true
    read_only: true
    sanity_check_default_kw: 495
    sigenergy_local_modbus_naming: true
    envvars:
        - name: SIGENERGY2MQTT_HASS_DEVICE_NAME_PREFIX
          value: device
        - name:  SIGENERGY2MQTT_HASS_ENTITY_ID_PREFIX
          value: entity
        - name:  SIGENERGY2MQTT_HASS_DISCOVERY_PREFIX
          value: discover
        - name:  SIGENERGY2MQTT_HASS_UNIQUE_ID_PREFIX
          value: unique
        - name: SIGENERGY2MQTT_SMARTPORT_ENABLED
          value: "true"
        - name: SIGENERGY2MQTT_SMARTPORT_HOST
          value: 192.168.192.224
        - name: SIGENERGY2MQTT_SMARTPORT_MODULE_NAME
          value: enphase
        - name: SIGENERGY2MQTT_SMARTPORT_MQTT_GAIN
          value: "1000"
        - name: SIGENERGY2MQTT_SMARTPORT_MQTT_TOPIC
          value: mqtt/smartport
        - name: SIGENERGY2MQTT_SMARTPORT_PASSWORD
          value: test_enphase_password
        - name: SIGENERGY2MQTT_SMARTPORT_PV_POWER
          value: EnphasePVPower
        - name: SIGENERGY2MQTT_SMARTPORT_USERNAME
          value: test_enphase_user
auto_discovery:
    force: false
    ping_timeout: 1
    retries: 1
    timeout: 1
influxdb:
    enabled: true
    host: 127.0.0.1
    port: 8686
    username: test_influxdb_user
    password: test_influxdb_password
    database: test_influxdb_database
    org: test_influxdb_organization
    token: test_influxdb_token
    bucket: test_influxdb_bucket
    include: 
        - sensor: test_influxdb_include1
        - sensor: test_influxdb_include2
    exclude: 
        - sensor: test_influxdb_exclude1
        - sensor: test_influxdb_exclude2
logging:
    app: Default
    debug_sensor: any
    modbus: INFO
    mqtt: WARNING
    pvoutput: INFO
    sigenergy2mqtt: DEBUG
    influxdb: CRITICAL
manual_config:
    accharger_device_id: 2,4
    dccharger_device_id: 1
    host: 127.0.0.1
    inverter_device_id: 1 3
    port: 502
mqtt:
    broker: localhost
    password: test_mqtt_password
    port: 8883
    tls: true
    username: test_mqtt_user
pvoutput:
    api_key: b2d224a131574b6a96f3592741637ad82f4c1989
    consumption: true
    enabled: true
    eod_update: true
    exports: true
    ext_v10: EV10
    ext_v11: EV11
    ext_v12: EV12
    ext_v7: EV7
    ext_v8: EV8
    ext_v9: EV9
    imports: true
    system_id: testing
    temp_topic: homeassistant/weather/temperature
    voltage: Line to Neutral Average
scan_interval:
    high: 1
    low: 300
    medium: 30
    realtime: 1

# Deprecated flat keys for completeness check
consumption_method: "Total Load"
debug_sensor: any
device_name_prefix: device
discovery_prefix: discover
edit_pct_box: true
entity_id_prefix: entity
log_level: DEBUG
metrics_enabled: true
modbus_accharger_slave: "2,4"
modbus_auto_discovery_ping_timeout: 1
modbus_auto_discovery_retries: 1
modbus_auto_discovery_timeout: 1
modbus_dccharger_slave: 1
modbus_force_auto_discovery: false
modbus_host: 127.0.0.1
modbus_log_level: INFO
modbus_no_remote_ems: true
modbus_port: 502
modbus_read_only: true
modbus_slave: "1 3"
mqtt_broker: localhost
mqtt_log_level: WARNING
mqtt_password: test_mqtt_password
mqtt_port: 8883
mqtt_tls: true
mqtt_username: test_mqtt_user
no_ems_mode_check: true
pvoutput_api_key: b2d224a131574b6a96f3592741637ad82f4c1989
pvoutput_consumption: true
pvoutput_enabled: true
pvoutput_eod_update: true
pvoutput_exports: true
pvoutput_ext_v10: EV10
pvoutput_ext_v11: EV11
pvoutput_ext_v12: EV12
pvoutput_ext_v7: EV7
pvoutput_ext_v8: EV8
pvoutput_ext_v9: EV9
pvoutput_imports: true
pvoutput_log_level: INFO
pvoutput_system_id: testing
pvoutput_temp_topic: homeassistant/weather/temperature
pvoutput_voltage: "Line to Neutral Average"
sanity_check_default_kw: 495
scan_interval_high: 1
scan_interval_low: 300
scan_interval_medium: 30
scan_interval_realtime: 1
smartport_enabled: false
smartport_host: 192.168.192.224
smartport_module_name: enphase
smartport_mqtt_gain: 1000
smartport_mqtt_topic: mqtt/smartport
smartport_password: test_enphase_password
smartport_pv_power: EnphasePVPower
smartport_username: test_enphase_user
unique_id_prefix: unique
EOF
#endregion

#region Check that all schema keys are represented in the mock options file
echo "Verifying that $MOCK_OPTIONS_PATH contains all keys from config.yaml schema..." > $LOG_PATH 2>&1

# Extract all scalar paths from schema in config.yaml, 
# stripping the 'schema.' prefix and replacing list indices (e.g. .0.) with .*
SCHEMA_KEYS=$(yq '.schema | .. | select(kind == "scalar") | path | join(".")' "$HOME/../../sigenergy2mqtt/config.yaml" | \
               sed 's/^schema\.//' | \
               sed -E 's/\.[0-9]+(\.|$)/.*\1/g' | \
               sort -u)

# Extract all scalar paths from the mock options file
OPTIONS_KEYS=$(yq '.. | select(kind == "scalar") | path | join(".")' $MOCK_OPTIONS_PATH | \
                sed -E 's/\.[0-9]+(\.|$)/.*\1/g' | \
                sort -u)

MISSING=$(comm -23 <(echo "$SCHEMA_KEYS") <(echo "$OPTIONS_KEYS"))

if [ -n "$MISSING" ]; then
    echo "ERROR: The following keys from sigenergy2mqtt/config.yaml schema are missing in $MOCK_OPTIONS_PATH:" >> $LOG_PATH 2>&1
    echo "$MISSING" >> $LOG_PATH 2>&1
    exit 1
fi
echo "Success: Mock options file covers all schema keys." >> $LOG_PATH 2>&1
#endregion

#region Prepare expected assertions
declare -A ASSERTIONS=(
    ["consumption"]="total"
    ["debug-sensor"]="any"
    ["hass-edit-pct-box"]="true"
    ["hass-enabled"]="true"
    ["influxdb-bucket"]="test_influxdb_bucket"
    ["influxdb-database"]="test_influxdb_database"
    ["influxdb-enabled"]="true"
    ["influxdb-exclude"]="test_influxdb_exclude1|test_influxdb_exclude2"
    ["influxdb-host"]="127.0.0.1"
    ["influxdb-include"]="test_influxdb_include1|test_influxdb_include2"
    ["influxdb-log-level"]="CRITICAL"
    ["influxdb-org"]="test_influxdb_organization"
    ["influxdb-password"]="test_influxdb_password"
    ["influxdb-port"]="8686"
    ["influxdb-token"]="test_influxdb_token"
    ["influxdb-username"]="test_influxdb_user"
    ["language"]="en"
    ["log-level"]="DEBUG"
    ["modbus-accharger-device-id"]="2|4"
    ["modbus-dccharger-device-id"]="1"
    ["modbus-host"]="127.0.0.1"
    ["modbus-inverter-device-id"]="1|3"
    ["modbus-log-level"]="INFO"
    ["modbus-port"]="502"
    ["modbus-readonly"]="true"
    ["mqtt-broker"]="localhost"
    ["mqtt-log-level"]="WARNING"
    ["mqtt-password"]="test_mqtt_password"
    ["mqtt-port"]="8883"
    ["mqtt-tls"]="true"
    ["mqtt-username"]="test_mqtt_user"
    ["pvoutput-api-key"]="b2d224a131574b6a96f3592741637ad82f4c1989"
    ["pvoutput-consumption"]="true"
    ["pvoutput-enabled"]="true"
    ["pvoutput-exports"]="true"
    ["pvoutput-ext-v10"]="EV10"
    ["pvoutput-ext-v11"]="EV11"
    ["pvoutput-ext-v12"]="EV12"
    ["pvoutput-ext-v7"]="EV7"
    ["pvoutput-ext-v8"]="EV8"
    ["pvoutput-ext-v9"]="EV9"
    ["pvoutput-imports"]="true"
    ["pvoutput-log-level"]="INFO"
    ["pvoutput-system-id"]="testing"
    ["pvoutput-temp-topic"]="homeassistant/weather/temperature"
    ["pvoutput-voltage"]="l/n-avg"
    ["sanity-check-default-kw"]="495"
    ["scan-interval-high"]="1"
    ["scan-interval-low"]="300"
    ["scan-interval-medium"]="30"
    ["scan-interval-realtime"]="1"
    ["SIGENERGY2MQTT_HASS_DEVICE_NAME_PREFIX"]="device"
    ["SIGENERGY2MQTT_HASS_DISCOVERY_PREFIX"]="discover"
    ["SIGENERGY2MQTT_HASS_ENTITY_ID_PREFIX"]="entity"
    ["SIGENERGY2MQTT_HASS_UNIQUE_ID_PREFIX"]="unique"
    ["SIGENERGY2MQTT_SMARTPORT_ENABLED"]="true"
    ["SIGENERGY2MQTT_SMARTPORT_HOST"]="192.168.192.224"
    ["SIGENERGY2MQTT_SMARTPORT_MODULE_NAME"]="enphase"
    ["SIGENERGY2MQTT_SMARTPORT_MQTT_GAIN"]="1000"
    ["SIGENERGY2MQTT_SMARTPORT_MQTT_TOPIC"]="mqtt/smartport"
    ["SIGENERGY2MQTT_SMARTPORT_PASSWORD"]="test_enphase_password"
    ["SIGENERGY2MQTT_SMARTPORT_PV_POWER"]="EnphasePVPower"
    ["SIGENERGY2MQTT_SMARTPORT_USERNAME"]="test_enphase_user"
    ["hass-sigenergy-local-modbus-naming"]="true"
)
#endregion

cd $HOME
source "../mock_bashio.sh"
source "../functions.sh"
export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) >> $LOG_PATH 2>&1
RESULT=$?
exit $RESULT
