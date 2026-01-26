#!/bin/bash

export HOME="$(cd $(dirname $0); pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
export MOCK_OPTIONS_PATH="/tmp/${TEST_NAME}.yaml"

#region Prepare mock sigenergy2mqtt options file
cat << EOF > $MOCK_OPTIONS_PATH
advanced:
    consumption_method: Calculated
    device_name_prefix: device
    discovery_prefix: discover
    edit_pct_box: true
    entity_id_prefix: entity
    metrics_enabled: true
    no_remote_ems: true
    no_remote_ems_check: true
    read_only: true
    sanity_check_default_kw: 495
    unique_id_prefix: unique
auto_discovery:
    force: false
    ping_timeout: 1
    retries: 1
    timeout: 1
logging:
    debug_sensor: any
    modbus: WARNING
    mqtt: WARNING
    pvoutput: WARNING
    sigenergy2mqtt: WARNING
manual_config:
    accharger_device_id: 2
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
smartport:
    enabled: true
    host: 192.168.192.224
    module_name: enphase
    mqtt_gain: 1000
    mqtt_topic: mqtt/smartport
    password: test_enphase_password
    pv_power: EnphasePVPower
    username: test_enphase_user
EOF
#endregion

#region Prepare expected assertions
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
