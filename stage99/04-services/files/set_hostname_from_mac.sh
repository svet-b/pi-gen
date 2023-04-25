#!/bin/sh -e

MAC=$(cat /sys/class/net/eth0/address 2>/dev/null | sed s/://g)
echo "ammp-edge-${MAC}" > /etc/hostname
sed -i "/^127.0.1.1/c\127.0.1.1\tammp-edge-${MAC}" /etc/hosts
