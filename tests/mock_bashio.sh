#!/bin/bash

set -u
export SUPERVISOR_TOKEN="mock_supervisor_token"

# --------------------------------------------------------
# Mock bashio:: Functions (using yq v4 syntax)
# --------------------------------------------------------

# --- Logging Functions ---
function bashio::log.debug() {   echo "[DEBUG] $1"; }
function bashio::log.info() {    echo "[INFO]  $1"; }
function bashio::log.warning() { echo "[WARN]  $1" >&2; }
function bashio::log.fatal() {   echo "[FATAL] $1" >&2; }


# Check if required files exist
if [ ! -f "$MOCK_OPTIONS_PATH" ]; then
    bashio::log.fatal "Missing $MOCK_OPTIONS_PATH file needed for mocks."
    exit 1
fi

# --- Configuration Functions ---

# Usage: bashio::config <key>
function bashio::config() {
    local key=$1
    local value=$(yq ".$key" "$MOCK_OPTIONS_PATH" | tr -d '\n''"')
    [ "$value" == "null" ] && value=""
    echo "$value"
}

# Usage: bashio::config.exists <key>
function bashio::config.exists() {
    local key=$1
    local value="$(yq ".$key" "$MOCK_OPTIONS_PATH")"
    if [[ -n "$value" && $value != "null" ]]; then
        return 0 # True (exists and is non-empty)
    else
        return 1 # False
    fi
}

# Usage: bashio::config.has_value <key>
function bashio::config.has_value() {
    # This function is identical to config.exists in yq v4 logic
    bashio::config.exists "$1"
}

# --- Options file manipulation functions ---
function bashio::config.set() {
    local key=$1
    local value=$2
    local type
    if [[ "$value" =~ ^(true|false)$ ]]; then 
        type="boolean"
    elif [[ "$value" =~ ^-?[0-9]+$ ]]; then 
        type="integer"
    elif [[ "$value" =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
        type="float"
    else
        type="string" 
        value="\"$value\""
    fi
    yq -i ".$key = $value" "$MOCK_OPTIONS_PATH" 
}

function bashio::config.remove() {
    local key=$1

    # Delete the key from the YAML file in place
    # --style=... is often needed with v3 delete to keep file clean
    yq -i "del(.$key)" "$MOCK_OPTIONS_PATH"
}

function bashio::addon.option() {
    local key=${1}
    local value=${2:-}

    if [ -n "$value" ]; then
        bashio::config.set "$key" "$value"
    else
        bashio::config.remove "$key"
    fi
}

# --- Addon Information Functions ---
function bashio::addon.version() { 
    yq .version  ../../sigenergy2mqtt/config.yaml | tr -d '\n'
}

# --- Service Discovery Functions (Extended for MQTT) ---
function bashio::services() {
    local service=$1
    local property=$2

    if [ "$service" == "mqtt" ]; then
        case "$property" in
            host)
                echo "127.0.0.1"
                ;;
            port)
                echo "1883"
                ;;
            username)
                echo "mock_mqtt_user"
                ;;
            password)
                echo "super_secret_mock_password"
                ;;
            *)
                bashio::log.warning "Unknown property '$property' requested for MQTT service."
                ;;
        esac
    else
        bashio::log.warning "bashio::services is mocked and does not know about service '$service'."
    fi
}

# Usage: bashio::services.available <service_slug>
function bashio::services.available() {
    local service=$1
    if [ "$service" == "mqtt" ]; then
        return 0 # True (available)
    else
        return 1 # False (for other services not mocked yet)
    fi
}

for fn in $(declare -F | awk '{print $3}'); do
    export -f "$fn"
done