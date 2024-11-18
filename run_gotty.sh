#!/bin/bash

# Default Gotty command with additional options
GOTTY_CMD="/usr/local/bin/gotty --permit-write --reconnect --enable-webgl --enable-clipboard /bin/bash"

# Start Gotty
echo "Starting Gotty..."
if $GOTTY_CMD; then
    echo "Gotty started successfully."
else
    echo "Failed to start Gotty!" >&2
    exit 1
fi
