#!/bin/bash

cd "$(cd $(dirname $0)/../../sigenergy2mqtt; pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
RESULT=0

rm -f $LOG_PATH

reference="translations/en.yaml"

# Extract reference keys
yq eval '.. | select(tag != "!!map" and tag != "!!seq") | select(. | type == "!!str") | select(. | test("DEPRECATED") | not) | path | join(".")' "$reference" | sort > /tmp/reference_keys.txt

echo "Checking language files against $reference..." >> $LOG_PATH 2>&1

for file in translations/*.yaml; do
    if [ "$file" != "$reference" ]; then
        # Extract keys from current file
        yq eval '.. | select(tag != "!!map" and tag != "!!seq") | path | join(".")' "$file" | sort > /tmp/current_keys.txt
        
        # Find missing keys
        missing=$(comm -23 /tmp/reference_keys.txt /tmp/current_keys.txt)
        
        # Find extra keys
        extra=$(comm -13 /tmp/reference_keys.txt /tmp/current_keys.txt)
        
        if [ -z "$missing" ] && [ -z "$extra" ]; then
            echo "✓ $file - Complete" >> $LOG_PATH 2>&1
        else
            RESULT=1
            echo "✗ $file - Incomplete" >> $LOG_PATH 2>&1
            if [ -n "$missing" ]; then
                echo "  Missing keys:" >> $LOG_PATH 2>&1
                echo "$missing" | sed 's/^/    /' >> $LOG_PATH 2>&1
            fi
            if [ -n "$extra" ]; then
                echo "  Extra keys:" >> $LOG_PATH 2>&1
                echo "$extra" | sed 's/^/    /' >> $LOG_PATH 2>&1
            fi
        fi
    fi
done

# Cleanup
rm -f /tmp/reference_keys.txt /tmp/current_keys.txt

exit $RESULT
