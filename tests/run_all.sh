#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <test_directory>"
    exit 1
fi

cd "$(cd $(dirname $0); pwd)"
export PATH=$PATH:$(pwd)/$1/.local/bin

tests=$(find $1 -name "test_*.sh" | sort)
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
total=0
for test in $tests; do
    test_name="$(basename "$test" .sh)"
    [[ "$1" != "-q" ]] && printf "Running: %-${chars}s " "$test"
    { time { bash $(shopt -qo xtrace && echo "-x" || echo "") "$test"; result=$?; }; } 2> /tmp/${test_name}.time 
    if [ $result -ne 0 ]; then
        [[ "$1" == "-q" ]] && echo -n "$test_name "
        echo "## FAILED ## ($result)"
        [[ "$1" != "-q" ]] && cat /tmp/${test_name}.log
        exit 1
    else
        elapsed=$(grep real /tmp/${test_name}.time | cut -d'm' -f2)
        total=$(echo "$total $(echo $elapsed | tr -d 's')" | awk '{ total = $1 + $2; printf "%.3f", total; }')
        [[ "$1" != "-q" ]] && echo "## PASSED ## [$elapsed]"
        passed=$((passed + 1))
        rm -rf /tmp/${test_name}*
    fi
done

[[ "$1" != "-q" ]] && echo "All ${passed} tests passed in $(printf '%.3'f $total)s"

exit 0