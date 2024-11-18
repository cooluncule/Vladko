#!/bin/bash

# Check if the PORT environment variable is set (Render requires this)
if [ -z "$PORT" ]; then
  echo "Error: PORT environment variable is not set. Render requires this to run properly."
  exit 1
fi

# Default Gotty command for mobile-friendly interactive mode
GOTTY_CMD="/usr/local/bin/gotty \
  --permit-write \
  --reconnect \
  --enable-webgl \
  --enable-clipboard \
  --once \
  --port $PORT \
  --title-format 'Render Terminal' \
  /bin/bash"

echo "Starting Gotty on port $PORT..."
exec $GOTTY_CMD
