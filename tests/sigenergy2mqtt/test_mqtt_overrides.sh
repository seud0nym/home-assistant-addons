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
pvoutput:
logging:
smartport:
"

#region Scenario 1: Default Auto-Discovery (Mocked in mock_bashio.sh)
# Logic: If no overrides, use bashio::services "mqtt"
cat << EOF > $MOCK_OPTIONS_PATH
mqtt:
$BASE_CONFIG
EOF

declare -A ASSERTIONS=(
    ["language"]="en"
    ["hass-enabled"]="true"
    ["mqtt-broker"]="127.0.0.1"
    ["mqtt-port"]="1883"
    ["mqtt-username"]="mock_mqtt_user"
    ["mqtt-password"]="super_secret_mock_password"
    ["modbus-host"]="127.0.0.1"
)
# Note: consumption/metrics/etc are defaults we don't strictly care about here but valid_params checks them.
# We'll just ignore them by only asserting what we care about + defaults that mock_bashio always forces?
# Re-checking functions.sh: validate_params_against_assertions checks ALL params against assertions.
# If assertion is missing for a present param, it fails? No, logic is:
# "Mismatch in number of parsed options" -> Yes, it fails count check.
# So we need ALL default params.
# Defaults from run script:
# --consumption=calculated (if advanced missing)
# --no-metrics (if advanced missing)
ASSERTIONS["consumption"]="calculated"
ASSERTIONS["no-metrics"]="true"

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

#region Scenario 2: Override Host and Port
cat << EOF > $MOCK_OPTIONS_PATH
mqtt:
    broker: 192.168.1.100
    port: 9999
$BASE_CONFIG
EOF

unset ASSERTIONS
declare -A ASSERTIONS=(
    ["language"]="en"
    ["hass-enabled"]="true"
    ["mqtt-broker"]="192.168.1.100"
    ["mqtt-port"]="9999"
    ["mqtt-username"]="mock_mqtt_user" # Inherited from auto-discovery
    ["mqtt-password"]="super_secret_mock_password" # Inherited
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
#endregion

#region Scenario 3: Override Credentials + TLS
cat << EOF > $MOCK_OPTIONS_PATH
mqtt:
    username: myuser
    password: mypassword
    tls: true
$BASE_CONFIG
EOF

unset ASSERTIONS
declare -A ASSERTIONS=(
    ["language"]="en"
    ["hass-enabled"]="true"
    ["mqtt-broker"]="127.0.0.1" # Inherited
    ["mqtt-port"]="1883" # Inherited
    ["mqtt-username"]="myuser"
    ["mqtt-password"]="mypassword"
    ["mqtt-tls"]="true"
    ["modbus-host"]="127.0.0.1"
    ["consumption"]="calculated"
    ["no-metrics"]="true"
)
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
