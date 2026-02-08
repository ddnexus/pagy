#!/bin/bash

# Setup example for a Project that requires bun
#- `podman exec -it <service-name> /%N/.devcontainer/setup.sh` from the host
#- `/<Project-name>/.devcontainer/setup.sh` from inside a container shell

# 1. Install Bun (to /opt/bun)
if [[ ! -x "/opt/tools/bun/bin/bun" ]]; then
    echo ">>> Installing Bun..."
    curl -fsSL https://bun.sh/install | BUN_INSTALL=/opt/tools/bun bash
fi

echo ">>> Project environment ready."
