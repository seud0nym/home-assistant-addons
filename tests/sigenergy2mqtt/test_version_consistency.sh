#!/bin/bash
# The add-on version, the wheel installed by the Dockerfile, the wheel shipped in
# rootfs/dist and the changelog must all agree.

cd "$(cd $(dirname $0)/../../sigenergy2mqtt; pwd)"
export TEST_NAME="$(basename "$0" .sh)"
export LOG_PATH="/tmp/${TEST_NAME}.log"
RESULT=0

rm -f $LOG_PATH

fail() { echo "$1" >> $LOG_PATH; RESULT=1; }

version="$(grep '^version:' config.yaml | cut -d'"' -f2)"
[[ -n "$version" ]] || fail "No version found in config.yaml"

grep -q "^## \[${version}\]" CHANGELOG.md || fail "CHANGELOG.md has no entry for version ${version}"

docker_wheel="$(grep -o '/dist/sigenergy2mqtt-[^ ]*\.whl' Dockerfile | head -n 1)"
[[ "$docker_wheel" == "/dist/sigenergy2mqtt-${version}-py3-none-any.whl" ]] || fail "Dockerfile installs '${docker_wheel}' but config.yaml version is ${version}"

[[ -f "rootfs${docker_wheel}" ]] || fail "Wheel rootfs${docker_wheel} does not exist"

count="$(ls rootfs/dist/*.whl 2>/dev/null | wc -l)"
[[ "$count" -eq 1 ]] || fail "Expected exactly one wheel in rootfs/dist, found ${count}"

exit $RESULT
