#!/bin/bash

set -u
export SUPERVISOR_TOKEN=""

# --------------------------------------------------------
# Mock bashio:: Functions (using yq v4 syntax)
# --------------------------------------------------------

# --- Logging Functions ---
[[ -z "${__BASHIO_LOG_LEVEL:-}" ]] && export __BASHIO_LOG_LEVEL="info"
function bashio::log.level() {
    local level=$1
    case "$level" in
        debug|info|warning|fatal)
            export __BASHIO_LOG_LEVEL="$level"
            ;;
        *)
            bashio::log.warning "Unknown log level '$level' specified, defaulting to 'info'"
            export __BASHIO_LOG_LEVEL="info"
            ;;
    esac
}
function bashio::log.debug() {   [[ "${__BASHIO_LOG_LEVEL:-info}" == "debug" ]] && echo "[DEBUG] $1" >&2 || true; }
function bashio::log.info() {    echo "[INFO]  $1" >&2; }
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
    local key=${1:-}
    local value=$(yq ".$key" "$MOCK_OPTIONS_PATH" | tr -d '\n''"')
    [ "$value" == "null" ] && value=""
    bashio::log.debug "··· bashio::config() - key '$key' has value '$value'"
    echo "$value"
}

# Usage: bashio::config.exists <key>
function bashio::config.exists() {
    local key=$1
    local value="$(yq ".$key" "$MOCK_OPTIONS_PATH")"
    bashio::log.debug "··· bashio::config.exists() - key '$key' has value $value"
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
  local key="$1"
  local value="$2"
  local assignment="="

  if [[ "$value" =~ ^\{.*\}$ && $key =~ \[\]$ ]]; then 
    key="${key%[]}"
    value="[ $value ]"
    assignment="+="
  elif [[ "$value" =~ ^(true|false)$ ]]; then 
    :
  elif [[ "$value" =~ ^-?[0-9]+$ ]]; then 
    :
  elif [[ "$value" =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
    :
  else
    value="\"$value\""
  fi

  bashio::log.debug "··· bashio::config.set() - Setting key '$key' $assignment '$value'"
  yq -i ".${key} ${assignment} ${value}" "$MOCK_OPTIONS_PATH"
}

function bashio::config.remove() {
    local key=$1
    bashio::log.debug "··· bashio::config.remove() - Removing key '$key' from config"
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