#!/bin/bash

export HOME="$(cd $(dirname $0); pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
export MOCK_OPTIONS_PATH="/tmp/${TEST_NAME}.yaml"

#region Prepare mock sigenergy2mqtt options file
cat << EOF > $MOCK_OPTIONS_PATH
advanced:
    consumption_method: Total Load
    metrics_enabled: false
auto_discovery:
    retries: 1
    timeout: 1
manual_config:
    host: 127.0.0.1
pvoutput:
    api_key: test_key
    enabled: true
    eod_update: false
    system_id: 12345
    voltage: Phase A
mqtt:
logging:
smartport:
EOF
#endregion

#region Prepare expected assertions
# Note: Defaults from mock_bashio/run script are matched here
declare -A ASSERTIONS=(
    ["hass-enabled"]="true"
    ["mqtt-broker"]="127.0.0.1"
    ["mqtt-port"]="1883"
    ["mqtt-username"]="mock_mqtt_user"
    ["mqtt-password"]="super_secret_mock_password"
    ["consumption"]="total"
    ["no-metrics"]="true"
    ["pvoutput-enabled"]="true"
    ["pvoutput-api-key"]="test_key"
    ["pvoutput-system-id"]="12345"
    ["pvoutput-voltage"]="phase-a"
    ["pvoutput-output-hour"]="-1"
    ["modbus-host"]="127.0.0.1"
)
#endregion

cd $HOME
source "../mock_bashio.sh"
source "../functions.sh"
export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?
if [ $RESULT -ne 0 ]; then
    echo "First run failed with result $RESULT"
    exit $RESULT
fi

#region Second run with different options (General Load, different voltage, implicit metrics=false, explicit eod_update=true)
cat << EOF > $MOCK_OPTIONS_PATH
advanced:
    consumption_method: General Load
auto_discovery:
    retries: 1
    timeout: 1
manual_config:
    host: 127.0.0.1
pvoutput:
    api_key: test_key
    enabled: true
    eod_update: true
    system_id: 12345
    voltage: Phase B
mqtt:
logging:
smartport:
EOF

unset ASSERTIONS
declare -A ASSERTIONS=(
    ["hass-enabled"]="true"
    ["mqtt-broker"]="127.0.0.1"
    ["mqtt-port"]="1883"
    ["mqtt-username"]="mock_mqtt_user"
    ["mqtt-password"]="super_secret_mock_password"
    ["consumption"]="general"
    ["no-metrics"]="true"
    ["pvoutput-enabled"]="true"
    ["pvoutput-api-key"]="test_key"
    ["pvoutput-system-id"]="12345"
    ["pvoutput-voltage"]="phase-b"
    # pvoutput-output-hour is ABSENT when eod_update is true
    ["modbus-host"]="127.0.0.1"
)

export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?
if [ $RESULT -ne 0 ]; then
    echo "Second run failed with result $RESULT"
    exit $RESULT
fi
#endregion

#region Third run (Calculated, Phase C)
cat << EOF > $MOCK_OPTIONS_PATH
advanced:
    consumption_method: Calculated
auto_discovery:
    retries: 1
    timeout: 1
manual_config:
    host: 127.0.0.1
pvoutput:
    api_key: test_key
    enabled: true
    system_id: 12345
    voltage: Phase C
mqtt:
logging:
smartport:
EOF

unset ASSERTIONS
declare -A ASSERTIONS=(
    ["hass-enabled"]="true"
    ["mqtt-broker"]="127.0.0.1"
    ["mqtt-port"]="1883"
    ["mqtt-username"]="mock_mqtt_user"
    ["mqtt-password"]="super_secret_mock_password"
    ["consumption"]="calculated"
    ["no-metrics"]="true"
    ["pvoutput-enabled"]="true"
    ["pvoutput-api-key"]="test_key"
    ["pvoutput-system-id"]="12345"
    ["pvoutput-voltage"]="phase-c"
    ["pvoutput-output-hour"]="-1"
    ["modbus-host"]="127.0.0.1"
)

export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?
if [ $RESULT -ne 0 ]; then
    echo "Third run failed with result $RESULT"
    exit $RESULT
fi
#endregion

#region Fourth run (Line to Line Avg)
cat << EOF > $MOCK_OPTIONS_PATH
advanced:
    consumption_method: Calculated
auto_discovery:
    retries: 1
    timeout: 1
manual_config:
    host: 127.0.0.1
pvoutput:
    api_key: test_key
    enabled: true
    system_id: 12345
    voltage: Line to Line Average
mqtt:
logging:
smartport:
EOF

unset ASSERTIONS
declare -A ASSERTIONS=(
    ["hass-enabled"]="true"
    ["mqtt-broker"]="127.0.0.1"
    ["mqtt-port"]="1883"
    ["mqtt-username"]="mock_mqtt_user"
    ["mqtt-password"]="super_secret_mock_password"
    ["consumption"]="calculated"
    ["no-metrics"]="true"
    ["pvoutput-enabled"]="true"
    ["pvoutput-api-key"]="test_key"
    ["pvoutput-system-id"]="12345"
    ["pvoutput-voltage"]="l/l-avg"
    ["pvoutput-output-hour"]="-1"
    ["modbus-host"]="127.0.0.1"
)

export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?
if [ $RESULT -ne 0 ]; then
    echo "Fourth run failed with result $RESULT"
    exit $RESULT
fi
#endregion

#region Fifth run (PV Average)
cat << EOF > $MOCK_OPTIONS_PATH
advanced:
    consumption_method: Calculated
auto_discovery:
    retries: 1
    timeout: 1
manual_config:
    host: 127.0.0.1
pvoutput:
    api_key: test_key
    enabled: true
    system_id: 12345
    voltage: PV Average
mqtt:
logging:
smartport:
EOF

unset ASSERTIONS
declare -A ASSERTIONS=(
    ["hass-enabled"]="true"
    ["mqtt-broker"]="127.0.0.1"
    ["mqtt-port"]="1883"
    ["mqtt-username"]="mock_mqtt_user"
    ["mqtt-password"]="super_secret_mock_password"
    ["consumption"]="calculated"
    ["no-metrics"]="true"
    ["pvoutput-enabled"]="true"
    ["pvoutput-api-key"]="test_key"
    ["pvoutput-system-id"]="12345"
    ["pvoutput-voltage"]="pv"
    ["pvoutput-output-hour"]="-1"
    ["modbus-host"]="127.0.0.1"
)

export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?
if [ $RESULT -ne 0 ]; then
    echo "Fifth run failed with result $RESULT"
    exit $RESULT
fi
#endregion

#region Sixth run (Metrics Enabled)
cat << EOF > $MOCK_OPTIONS_PATH
advanced:
    metrics_enabled: true
auto_discovery:
    retries: 1
    timeout: 1
manual_config:
    host: 127.0.0.1
pvoutput:
    api_key: test_key
    enabled: true
    system_id: 12345
    voltage: PV Average
mqtt:
logging:
smartport:
EOF

unset ASSERTIONS
declare -A ASSERTIONS=(
    ["hass-enabled"]="true"
    ["mqtt-broker"]="127.0.0.1"
    ["mqtt-port"]="1883"
    ["mqtt-username"]="mock_mqtt_user"
    ["mqtt-password"]="super_secret_mock_password"
    ["consumption"]="calculated"
    # no-metrics should be ABSENT
    ["pvoutput-enabled"]="true"
    ["pvoutput-api-key"]="test_key"
    ["pvoutput-system-id"]="12345"
    ["pvoutput-voltage"]="pv"
    ["pvoutput-output-hour"]="-1"
    ["modbus-host"]="127.0.0.1"
)

export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?
exit $RESULT
#endregion
