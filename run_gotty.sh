#!/bin/bash

# Enhanced Gotty command for mobile interactivity
GOTTY_CMD="/usr/local/bin/gotty \
  --permit-write \
  --reconnect \
  --enable-webgl \
  --enable-clipboard \
  --once \
  --title-format 'Mobile Terminal' \
  --width 80 \
  --height 24 \
  /bin/bash"

# Start Gotty
echo "Starting Gotty with mobile-friendly settings..."
if $GOTTY_CMD; then
    echo "Gotty session ended. Exiting process."
else
    echo "Failed to start Gotty!" >&2
    exit 1
fi
