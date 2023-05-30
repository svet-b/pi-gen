#!/bin/bash -e

apt remove --purge -y --allow-remove-essential busybox e2fsprogs gcc-9-base rsyslog raspi-config
apt autoremove --purge -y
apt clean
