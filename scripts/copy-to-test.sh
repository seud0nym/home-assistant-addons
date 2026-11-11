#!/bin/bash
#
# Copies the current version of the sigenergy2mqtt addon to the test environment and triggers a local build.
# Requires the "Advanced SSH & Web Terminal" app add-on in your test Home Assistant instance.
#
# Configure the following environment variables in .scripts.env:
# - SSH_USER: The username to use for SSH connections (e.g., root)
# - SSH_HOST: The hostname or IP address of the test Home Assistant instance (e.g., 10.10.20.14)

source .scripts.env

scp -r sigenergy2mqtt $SSH_USER@$SSH_HOST:addons/

ssh $SSH_USER@$SSH_HOST bash -s <<'EOF'
echo "Copying sigenergy2mqtt to test environment"
sed -e 's/^image/#image/' -i addons/sigenergy2mqtt/config.yaml
echo -n "Copied "
grep ^version: addons/sigenergy2mqtt/config.yaml
echo "Reloading Supervisor's store cache"
ha store reload
echo "Applying version bump & triggering local build"
ha app update local_sigenergy2mqtt || true
ha app rebuild local_sigenergy2mqtt
EOF