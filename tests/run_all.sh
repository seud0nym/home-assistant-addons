#!/bin/bash

cd "$(cd $(dirname $0); pwd)"

tests=$(find . -name "test_*.sh" | sort)
chars=$(echo "$tests" | awk 'BEGIN {
   chars = 0
   longest = ""
} 
length( $NF ) > chars { 
   chars = length( $NF )
   longest = $NF
} 
END { 
   print chars
}')

passed=0
for test in $tests; do
    test_name="$(basename "$test" .sh)"
    [[ "$1" != "-q" ]] && printf "Running: %-${chars}s " "$test"
    bash "$test"
    if [ $? -ne 0 ]; then
        [[ "$1" == "-q" ]] && echo -n "$test_name "
        echo "## FAILED ##"
        [[ "$1" != "-q" ]] && cat /tmp/${test_name}.log
        exit 1
    else
        [[ "$1" != "-q" ]] && echo "## PASSED ##"
        passed=$((passed + 1))
        rm -rf /tmp/${test_name}*
    fi
done

[[ "$1" != "-q" ]] && echo "All ${passed} tests passed."

exit 0