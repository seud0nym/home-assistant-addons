#!/bin/bash

export HOME="$(cd $(dirname $0); pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
export MOCK_OPTIONS_PATH="/tmp/${TEST_NAME}.yaml"

#region Prepare mock sigenergy2mqtt options file
cat << EOF > $MOCK_OPTIONS_PATH
consumption_method: Calculated
debug_sensor: any
device_name_prefix: device
discovery_prefix: discover
edit_pct_box: true
entity_id_prefix: entity
log_level: WARNING
metrics_enabled: true
modbus_accharger_slave: "2"
modbus_auto_discovery_ping_timeout: 1
modbus_auto_discovery_retries: 1
modbus_auto_discovery_timeout: 1
modbus_dccharger_slave: "1"
modbus_force_auto_discovery: false
modbus_host: 127.0.0.1
modbus_log_level: WARNING
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
no_remote_ems_check: true
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
pvoutput_log_level: WARNING
pvoutput_system_id: testing
pvoutput_temp_topic: homeassistant/weather/temperature
pvoutput_voltage: Line to Neutral Average
sanity_check_default_kw: 495
scan_interval_high: 1
scan_interval_low: 300
scan_interval_medium: 30
scan_interval_realtime: 1
smartport_enabled: true
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

# region Prepare expected assertions
declare -A ASSERTIONS=(
    ["language"]="en"
    ["consumption"]="calculated"
    ["debug-sensor"]="any"
    ["hass-device-name-prefix"]="device"
    ["hass-discovery-prefix"]="discover"
    ["hass-edit-pct-box"]="true"
    ["hass-enabled"]="true"
    ["hass-entity-id-prefix"]="entity"
    ["hass-unique-id-prefix"]="unique"
    ["log-level"]="WARNING"
    ["modbus-accharger-device-id"]="2"
    ["modbus-dccharger-device-id"]="1"
    ["modbus-host"]="127.0.0.1"
    ["modbus-inverter-device-id"]="1 3"
    ["modbus-log-level"]="WARNING"
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
    ["pvoutput-log-level"]="WARNING"
    ["pvoutput-system-id"]="testing"
    ["pvoutput-temp-topic"]="homeassistant/weather/temperature"
    ["pvoutput-voltage"]="l/n-avg"
    ["sanity-check-default-kw"]="495"
    ["scan-interval-high"]="1"
    ["scan-interval-low"]="300"
    ["scan-interval-medium"]="30"
    ["scan-interval-realtime"]="1"
    ["smartport-enabled"]="true"
    ["smartport-host"]="192.168.192.224"
    ["smartport-module-name"]="enphase"
    ["smartport-mqtt-gain"]="1000"
    ["smartport-mqtt-topic"]="mqtt/smartport"
    ["smartport-password"]="test_enphase_password"
    ["smartport-pv-power"]="EnphasePVPower"
    ["smartport-username"]="test_enphase_user"
)
#endregion

cd $HOME
source "../mock_bashio.sh"
source "../functions.sh"
export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?
exit $RESULT
