#!/bin/bash -e

apt remove --purge -y rsyslog raspi-config
apt autoremove --purge -y
apt clean
