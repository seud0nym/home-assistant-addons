#!/bin/bash

export HOME="$(cd $(dirname $0); pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
export MOCK_OPTIONS_PATH="/tmp/${TEST_NAME}.yaml"

#region Prepare mock sigenergy2mqtt options file
cat << EOF > $MOCK_OPTIONS_PATH
advanced:
    consumption_method: Total Load
    edit_pct_box: true
    metrics_enabled: true
    no_remote_ems: true
    no_ems_mode_check: true
    read_only: true
    sanity_check_default_kw: 495
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
    user: test_influxdb_user
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
EOF
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
)
#endregion

cd $HOME
source "../mock_bashio.sh"
source "../functions.sh"
export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?
exit $RESULT
