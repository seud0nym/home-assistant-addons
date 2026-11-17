#!/bin/bash
# Credentials containing spaces must reach the app as ONE value (not be split into
# several flags), and no secret may ever appear in the log in clear text.

export HOME="$(cd $(dirname $0); pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
export MOCK_OPTIONS_PATH="/tmp/${TEST_NAME}.yaml"

CLOUD_PASSWORD="correct horse battery"
INFLUX_PASSWORD="pass word*with[glob]"
PVOUTPUT_API_KEY="key with spaces"

#region Prepare mock sigenergy2mqtt options file
cat << EOF > $MOCK_OPTIONS_PATH
advanced:
auto_discovery:
manual_config:
mqtt:
logging:
cloud:
    region: Australia
    accept_unofficial_api_risk: true
    username: some user
    password: $CLOUD_PASSWORD
influxdb:
    enabled: true
    host: 192.168.1.100
    username: influx user
    password: $INFLUX_PASSWORD
    database: sigenergy
pvoutput:
    enabled: true
    api_key: $PVOUTPUT_API_KEY
    system_id: 12345
EOF
#endregion

#region Prepare expected assertions
declare -A ASSERTIONS=(
    ["language"]="en"
    ["hass-enabled"]="true"
    ["diagnostics-host"]="0.0.0.0"
    ["diagnostics-allowed-ips"]="172.30.32.2"
    ["SIGENERGY2MQTT_MQTT_BROKER"]="127.0.0.1"
    ["SIGENERGY2MQTT_MQTT_PORT"]="1883"
    ["SIGENERGY2MQTT_MQTT_TLS"]="false"
    ["SIGENERGY2MQTT_MQTT_USERNAME"]="mock_mqtt_user"
    ["SIGENERGY2MQTT_MQTT_PASSWORD"]="super_secret_mock_password"
    ["modbus-auto-discovery"]="once"
    ["cloud-region"]="aus"
    ["cloud-username"]="some user"
    ["cloud-password"]="$CLOUD_PASSWORD"
    ["cloud-accept-unofficial-api-risk"]="true"
    ["influxdb-enabled"]="true"
    ["influxdb-host"]="192.168.1.100"
    ["influxdb-username"]="influx user"
    ["influxdb-password"]="$INFLUX_PASSWORD"
    ["influxdb-database"]="sigenergy"
    ["pvoutput-enabled"]="true"
    ["pvoutput-api-key"]="$PVOUTPUT_API_KEY"
    ["pvoutput-system-id"]="12345"
    ["pvoutput-output-hour"]="-1"
)
#endregion

cd $HOME
source "../mock_bashio.sh"
source "../functions.sh"
export_assertions
( source ../../sigenergy2mqtt/rootfs/etc/services.d/sigenergy2mqtt/run ) > $LOG_PATH 2>&1
RESULT=$?
if [ $RESULT -ne 0 ]; then
    exit $RESULT
fi

# No secret may be logged in clear text
for secret in "$CLOUD_PASSWORD" "$INFLUX_PASSWORD" "$PVOUTPUT_API_KEY" "super_secret_mock_password"; do
    if grep -qF -- "$secret" $LOG_PATH; then
        echo "${TEST_NAME} [ERROR] Secret '$secret' was found in clear text in the log" >&2
        exit 1
    fi
done
if ! grep -q "REDACTED" $LOG_PATH; then
    echo "${TEST_NAME} [ERROR] Expected redacted values in the log" >&2
    exit 1
fi
exit 0
