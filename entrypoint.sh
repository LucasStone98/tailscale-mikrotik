#!/bin/sh

# Start tailscaled service
/app/ts/tailscaled --state=/var/lib/tailscale/tailscaled.state &

sleep 2

# Allow user to check for updates to binary
if [ "$UPDATE_TAILSCALE" = "true" ]; then
    echo "Checking for Tailscale updates..."
    /app/ts/tailscale update
fi

# Set default args
UP_ARGS="--accept-dns=false"

# --- Should add logic to AUTH_KEY and ADVERTISE_ROUTES env to error on invalid input ---

# Check for auth key
if [ -n "$AUTH_KEY" ]; then
    UP_ARGS="$UP_ARGS --authkey=$AUTH_KEY"
fi

# Check for route advertisements 
if [ -n "$ADVERTISE_ROUTES" ]; then
    UP_ARGS="$UP_ARGS --advertise-routes=$ADVERTISE_ROUTES"
fi

# Apply firewall rules
iptables -t nat -A POSTROUTING -o tailscale0 -j MASQUERADE

# Run tailscale bin
echo "Running: tailscale up $UP_ARGS"
/app/ts/tailscale up $UP_ARGS

# Keep the container alive
wait
