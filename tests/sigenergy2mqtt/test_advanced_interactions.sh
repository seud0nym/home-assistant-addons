#!/bin/bash

export HOME="$(cd $(dirname $0); pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
export MOCK_OPTIONS_PATH="/tmp/${TEST_NAME}.yaml"

# Shared config
BASE_CONFIG="
auto_discovery:
    retries: 1
    timeout: 1
manual_config:
    host: 127.0.0.1
pvoutput:
mqtt:
logging:
smartport:
"

#region Scenario 1: Read Only takes precedence
# All true, but only read_only should apply
cat << EOF > $MOCK_OPTIONS_PATH
advanced:
    read_only: true
    no_remote_ems: true
    no_remote_ems_check: true
$BASE_CONFIG
EOF

declare -A ASSERTIONS=(
    ["hass-enabled"]="true"
    ["mqtt-broker"]="127.0.0.1"
    ["mqtt-port"]="1883"
    ["mqtt-username"]="mock_mqtt_user"
    ["mqtt-password"]="super_secret_mock_password"
    ["consumption"]="calculated"
    ["no-metrics"]="true"
    ["modbus-host"]="127.0.0.1"
    ["modbus-readonly"]="true"
    # Expect others to be absent
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

# Manual check for absence of other flags
if grep -q "\-\-modbus-no-remote-ems" $LOG_PATH; then
    echo "Scenario 1 Failed: Found --modbus-no-remote-ems when read_only is true"
    exit 1
fi
if grep -q "\-\-no-remote-ems-check" $LOG_PATH; then
    echo "Scenario 1 Failed: Found --no-remote-ems-check when read_only is true"
    exit 1
fi
#endregion

#region Scenario 2: No Remote EMS takes second precedence
# read_only false, others true. no_remote_ems should apply.
cat << EOF > $MOCK_OPTIONS_PATH
advanced:
    read_only: false
    no_remote_ems: true
    no_remote_ems_check: true
$BASE_CONFIG
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
    ["modbus-host"]="127.0.0.1"
    ["modbus-no-remote-ems"]="true"
)
export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?
if [ $RESULT -ne 0 ]; then
    echo "Scenario 2 failed with result $RESULT"
    cat $LOG_PATH
    exit $RESULT
fi

# Manual check for absence
if grep -q "\-\-modbus-readonly" $LOG_PATH; then
    echo "Scenario 2 Failed: Found --modbus-readonly"
    exit 1
fi
if grep -q "\-\-no-remote-ems-check" $LOG_PATH; then
    echo "Scenario 2 Failed: Found --no-remote-ems-check when no_remote_ems is true"
    exit 1
fi
#endregion

#region Scenario 3: No Remote EMS Check works when others are false
cat << EOF > $MOCK_OPTIONS_PATH
advanced:
    read_only: false
    no_remote_ems: false
    no_remote_ems_check: true
$BASE_CONFIG
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
    ["modbus-host"]="127.0.0.1"
    ["no-remote-ems-check"]="true"
)
export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?
if [ $RESULT -ne 0 ]; then
    echo "Scenario 3 failed with result $RESULT"
    cat $LOG_PATH
    exit $RESULT
fi

if grep -q "\-\-modbus-readonly" $LOG_PATH; then
    echo "Scenario 3 Failed: Found --modbus-readonly"
    exit 1
fi
if grep -q "\-\-modbus-no-remote-ems" $LOG_PATH; then
    echo "Scenario 3 Failed: Found --modbus-no-remote-ems"
    exit 1
fi
#endregion

#region Scenario 4: All false
cat << EOF > $MOCK_OPTIONS_PATH
advanced:
    read_only: false
    no_remote_ems: false
    no_remote_ems_check: false
$BASE_CONFIG
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
    ["modbus-host"]="127.0.0.1"
)
export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?
if [ $RESULT -ne 0 ]; then
    echo "Scenario 4 failed with result $RESULT"
    cat $LOG_PATH
    exit $RESULT
fi

if grep -q "\-\-modbus-readonly" $LOG_PATH; then
    echo "Scenario 4 Failed: Found --modbus-readonly"
    exit 1
fi
if grep -q "\-\-modbus-no-remote-ems" $LOG_PATH; then
    echo "Scenario 4 Failed: Found --modbus-no-remote-ems"
    exit 1
fi
if grep -q "\-\-no-remote-ems-check" $LOG_PATH; then
    echo "Scenario 4 Failed: Found --no-remote-ems-check"
    exit 1
fi
#endregion

exit 0
