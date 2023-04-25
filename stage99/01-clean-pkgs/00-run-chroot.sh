#!/bin/bash -e

apt remove --purge -y busybox rsyslog raspi-config
apt autoremove --purge -y
apt clean
