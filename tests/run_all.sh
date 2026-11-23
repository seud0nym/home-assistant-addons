#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <test_directory> [-q]"
    exit 1
fi
QUIET=false
[[ "${2:-}" == "-q" ]] && QUIET=true

cd "$(cd $(dirname $0); pwd)"
export PATH=$PATH:$(pwd)/$1/.local/bin

# The tests create and remove /config and /data (paths hard-coded in the run
# script). Never touch directories that existed before the run: on a developer
# machine they may hold real data.
for dir in /config /data; do
    if [ -e "$dir" ] && [ -z "${CI:-}" ] && [ ! -e /.dockerenv ]; then
        echo "ERROR: $dir already exists; refusing to run tests that would modify it outside CI/a container." >&2
        exit 1
    fi
done
PREEXISTING=""
for dir in /config /data; do
    [ -e "$dir" ] && PREEXISTING="$PREEXISTING $dir"
done

cleanup_and_exit() {
    for dir in /config /data; do
        case " $PREEXISTING " in
            *" $dir "*) ;;
            *) rm -rf "$dir" ;;
        esac
    done
    exit $1
}

trap cleanup_and_exit EXIT

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
    [[ "$QUIET" == false ]] && printf "Running: %-${chars}s " "$test"
    { time { bash $(shopt -qo xtrace && echo "-x" || echo "") "$test"; result=$?; }; } 2> /tmp/${test_name}.time 
    if [ $result -ne 0 ]; then
        [[ "$QUIET" == true ]] && echo -n "$test_name "
        echo "## FAILED ## ($result)"
        cat /tmp/${test_name}.log
        cleanup_and_exit 1
    else
        elapsed=$(grep real /tmp/${test_name}.time | cut -d'm' -f2)
        total=$(echo "$total $(echo $elapsed | tr -d 's')" | awk '{ total = $1 + $2; printf "%.3f", total; }')
        [[ "$QUIET" == false ]] && echo "## PASSED ## [$elapsed]"
        passed=$((passed + 1))
        rm -rf /tmp/${test_name}*
    fi
done

[[ "$QUIET" == false ]] && echo "All ${passed} tests passed in $(printf '%.3f' $total)s"

cleanup_and_exit 0