#!/bin/bash -e

# Get MAC ID
MAC=$(cat /sys/class/net/eth0/address | sed s/://g)

# Generate IP address (based on last three bytes of MAC)
WG_LOCAL_IP="10.$((16#${MAC:6:2})).$((16#${MAC:8:2})).$((16#${MAC:10:2}))"

# Generate 32-byte WireGuard private key base64
WG_LOCAL_PRIVKEY=$(printf "%32s" "$MAC" | base64)

# WireGuard remote endpoint parameters
WG_REMOTE_PUBKEY='uneWvIm34XIkPyDP58XMZ1Ftsg7SzFVMt4EQeotJcRA='
WG_REMOTE_IP=10.255.255.254
WG_REMOTE_HOST=et-wg.ammp.io
WG_REMOTE_PORT=123

# Create WireGuard config file
cat > $RUNTIME_DIRECTORY/wg0.conf <<EOF
[Interface]
PrivateKey = $WG_LOCAL_PRIVKEY
Address = $WG_LOCAL_IP/32

[Peer]
PublicKey = $WG_REMOTE_PUBKEY
AllowedIPs = $WG_REMOTE_IP/32
Endpoint = $WG_REMOTE_HOST:$WG_REMOTE_PORT
PersistentKeepalive = 25
EOF

chmod 600 $RUNTIME_DIRECTORY/wg0.conf

echo "Generated $RUNTIME_DIRECTORY/wg0.conf"
