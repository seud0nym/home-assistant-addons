#!/usr/bin/env bash
# Requires Bash 4+

function export_assertions() {
    local arr_name="ASSERTIONS"
    local -n arr_ref="$arr_name"  # nameref to the array
    local serialized=""
    local k

    for k in "${!arr_ref[@]}"; do
        # Escape semicolons and equals in keys/values
        local esc_key="${k//;/\\;}"
        esc_key="${esc_key//=/\\=}"
        local esc_val="${arr_ref[$k]//;/\\;}"
        esc_val="${esc_val//=/\\=}"
        serialized+="${esc_key}=${esc_val};"
    done

    export "${arr_name}_SERIALIZED=${serialized}"
}

function import_assertions() {
    local arr_name="ASSERTIONS"
    local serialized_var="${arr_name}_SERIALIZED"
    local serialized="${!serialized_var}"
    ASSERTIONS=()  # clear existing

    IFS=';' read -ra pairs <<< "$serialized"
    for pair in "${pairs[@]}"; do
        [[ -z "$pair" ]] && continue
        local k="${pair%%=*}"
        local v="${pair#*=}"
        # Unescape
        k="${k//\\;/;}"
        k="${k//\\=/=}"
        v="${v//\\;/;}"
        v="${v//\\=/=}"
        ASSERTIONS["$k"]="$v"
    done
}

function validate_params_against_assertions() {
    local result=0
    declare -A ASSERTIONS
    import_assertions

    if [[ ${#SIGENERGY2MQTT_PARAMETERS[@]} -ne  ${#ASSERTIONS[@]} ]]; then
        echo "${TEST_NAME} [ERROR] Mismatch in number of parsed options (${#SIGENERGY2MQTT_PARAMETERS[@]}) and assertions (${#ASSERTIONS[@]})."
        result=1
    fi

    for k in $(printf "%s\n" "${!ASSERTIONS[@]}" | sort); do
        expected_value="${ASSERTIONS[$k]}"
        actual_value="${SIGENERGY2MQTT_PARAMETERS[$k]}"
        if [[ "$expected_value" != "any" && "$actual_value" != "$expected_value" ]]; then
            echo "${TEST_NAME} [ERROR] Mismatch for option '$k': expected '$expected_value', got '$actual_value'"
            result=1
        fi
    done

    exit $result
}