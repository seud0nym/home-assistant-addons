#!/bin/bash

cd "$(cd $(dirname $0)/../../sigenergy2mqtt; pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
RESULT=0

rm -f $LOG_PATH

while IFS= read -r line; do
    key="${line%%:*}"
    echo "$key" | grep -q '\.' || continue
    value="${line#*:}"

    while IFS='|' read -r -a list; do
        for val in "${list[@]}"; do
            if [[ $val == Default ]]; then
                echo "Dummy list value '${val}' ignored for config key '$key'" >> "$LOG_PATH"
                continue
            elif ! grep --context=$(( ${#list[*]} + 1 )) "$val" rootfs/etc/services.d/sigenergy2mqtt/run | grep -q "${key}"; then
                echo "===========================================================================================" >> "$LOG_PATH"
                echo "ERROR: Config key '$key' not found within $(( ${#list[*]} + 1 )) lines of list value '$val'" >> "$LOG_PATH"
                echo "Context:" >> "$LOG_PATH"
                grep --context=$(( ${#list[*]} + 1 )) "$val" rootfs/etc/services.d/sigenergy2mqtt/run >> "$LOG_PATH"
                echo "===========================================================================================" >> "$LOG_PATH"
                RESULT=1
            else
                echo "Config key '$key' found within $(( ${#list[*]} + 1 )) lines of list value '$val'" >> "$LOG_PATH"
            fi
        done
    done < <(echo "$value" | grep -oP "(?<=\().*?(?=\))")

done < <(yq '
  .. | 
  select(type == "!!str" and test("^list\\(.*\\)")) | 
  {(path | .[1:] | join(".")): .}
' config.yaml)

exit $RESULT