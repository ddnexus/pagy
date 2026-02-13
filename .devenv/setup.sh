#!/bin/bash

# Setup example for a Project that requires bun
#- `podman exec -it <service-name> /%N/.devcontainer/setup.sh` from the host
#- `/<Project-name>/.devcontainer/setup.sh` from inside a container shell

set -e

# Print the command that failed and its line number
trap 'echo "Error on line $LINENO: command [$BASH_COMMAND] failed with exit code $?"' ERR

# 1. Install Bun (to /opt/bun)
if [[ ! -x "/opt/tools/bun/bin/bun" ]]; then
    echo ">>> Installing Bun..."
    curl -fL -C - https://bun.sh/install -o /tmp/bun-install.sh
    BUN_INSTALL=/opt/tools/bun bash /tmp/bun-install.sh
    rm /tmp/bun-install.sh
fi

# 2. Install Chromium (to /opt/tools/chromium)
# if [[ ! -x "/opt/tools/chromium/chrome-linux/chrome" ]]; then
#     echo ">>> Installing Chromium..."
#     mkdir -p /opt/tools/chromium
#     # Download latest Linux_x64 build
#     LATEST=$(curl -sS https://storage.googleapis.com/chromium-browser-snapshots/Linux_x64/LAST_CHANGE)
#     curl -fL -C - "https://storage.googleapis.com/chromium-browser-snapshots/Linux_x64/$LATEST/chrome-linux.zip" -o /tmp/chrome-linux.zip
#     unzip -q /tmp/chrome-linux.zip -d /opt/tools/chromium
#     rm /tmp/chrome-linux.zip
#     # Create symlink to satisfy the path expected by some configurations
#     mkdir -p /opt/google/chrome
#     ln -sf /opt/tools/chromium/chrome-linux/chrome /opt/google/chrome/chrome
# fi

echo ">>> Project environment ready."
