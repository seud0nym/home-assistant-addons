#!/bin/bash

export HOME="$(cd $(dirname $0); pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
export MOCK_OPTIONS_PATH="/tmp/${TEST_NAME}.yaml"

# Shared config
BASE_CONFIG="
advanced:
auto_discovery:
    retries: 1
    timeout: 1
manual_config:
    host: 127.0.0.1
smartport:
"

#region Scenario 1: Verify all logging options
cat << EOF > $MOCK_OPTIONS_PATH
logging:
  sigenergy2mqtt: DEBUG
  modbus: INFO
  mqtt: ERROR
  pvoutput: CRITICAL
  debug_sensor: sensor.my_debug_sensor
# Enable pvoutput so we can test its logging flag
pvoutput:
    enabled: true
    api_key: k
    system_id: s
$BASE_CONFIG
EOF

declare -A ASSERTIONS=(
    ["locale"]="en"
    ["hass-enabled"]="true"
    ["mqtt-broker"]="127.0.0.1"
    ["mqtt-port"]="1883"
    ["mqtt-username"]="mock_mqtt_user"
    ["mqtt-password"]="super_secret_mock_password"
    ["modbus-host"]="127.0.0.1"
    ["consumption"]="calculated"
    ["no-metrics"]="true"
    # Logging assertions
    ["log-level"]="DEBUG"
    ["modbus-log-level"]="INFO"
    ["mqtt-log-level"]="ERROR"
    ["pvoutput-log-level"]="CRITICAL"
    ["debug-sensor"]="sensor.my_debug_sensor"
    # PVOutput required assertions because we enabled it
    ["pvoutput-enabled"]="true"
    ["pvoutput-api-key"]="k"
    ["pvoutput-system-id"]="s"
    ["pvoutput-voltage"]="l/n-avg" # Default
    ["pvoutput-output-hour"]="-1" # Default when eod_update missing
)

cd $HOME
source "../mock_bashio.sh"
source "../functions.sh"
export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?
if [ $RESULT -ne 0 ]; then
    echo "Scenario 1 failed with result $RESULT"
    cat $LOG_PATH
    exit $RESULT
fi
#endregion

#region Scenario 2: Verify defaults/absent logging
# If logging keys are missing, flags should not be present (except potentially defaults handled by run script?)
# The run script only adds them if config.has_value.
cat << EOF > $MOCK_OPTIONS_PATH
logging:
pvoutput:
$BASE_CONFIG
EOF

unset ASSERTIONS
declare -A ASSERTIONS=(
    ["locale"]="en"
    ["hass-enabled"]="true"
    ["mqtt-broker"]="127.0.0.1"
    ["mqtt-port"]="1883"
    ["mqtt-username"]="mock_mqtt_user"
    ["mqtt-password"]="super_secret_mock_password"
    ["modbus-host"]="127.0.0.1"
    ["consumption"]="calculated"
    ["no-metrics"]="true"
)

export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?
if [ $RESULT -ne 0 ]; then
    echo "Scenario 2 failed with result $RESULT"
    cat $LOG_PATH
    exit $RESULT
fi

# Manual check that no logging flags are present
if grep -q "Parameter: \-\-log-level" $LOG_PATH; then
    echo "Scenario 2 Failed: Found --log-level"
    exit 1
fi
if grep -q "Parameter: \-\-modbus-log-level" $LOG_PATH; then
    echo "Scenario 2 Failed: Found --modbus-log-level"
    exit 1
fi
if grep -q "Parameter: \-\-mqtt-log-level" $LOG_PATH; then
    echo "Scenario 2 Failed: Found --mqtt-log-level"
    exit 1
fi
if grep -q "Parameter: \-\-pvoutput-log-level" $LOG_PATH; then
    echo "Scenario 2 Failed: Found --pvoutput-log-level"
    exit 1
fi
if grep -q "Parameter: \-\-debug-sensor" $LOG_PATH; then
    echo "Scenario 2 Failed: Found --debug-sensor"
    exit 1
fi
#endregion


#region Scenario 3: Verify UNSET logging option
cat << EOF > $MOCK_OPTIONS_PATH
logging:
  sigenergy2mqtt: UNSET
  modbus: INFO
$BASE_CONFIG
EOF

declare -A ASSERTIONS=(
    ["locale"]="en"
    ["hass-enabled"]="true"
    ["mqtt-broker"]="127.0.0.1"
    ["mqtt-port"]="1883"
    ["mqtt-username"]="mock_mqtt_user"
    ["mqtt-password"]="super_secret_mock_password"
    ["modbus-host"]="127.0.0.1"
    ["consumption"]="calculated"
    ["no-metrics"]="true"
    # Logging assertions
    ["modbus-log-level"]="INFO"
)

cd $HOME
source "../mock_bashio.sh"
source "../functions.sh"
export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?
if [ $RESULT -ne 0 ]; then
    echo "Scenario 3 failed with result $RESULT"
    cat $LOG_PATH
    exit $RESULT
fi
#endregion


exit 0
