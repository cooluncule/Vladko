#!/bin/bash

# Ensure systemd is properly initialized
if [ "$(stat -c %d /)" != "$(stat -c %d /run)" ]; then
    mount -t tmpfs tmpfs /run
    mkdir -p /run/lock
fi

# Start the systemd service manager
exec /lib/systemd/systemd
