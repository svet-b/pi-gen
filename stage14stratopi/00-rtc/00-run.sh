#!/bin/bash -e

# An alternative it do this using an overlay, but this seems to be more reliable
# on the StratoPis.

install -v -m 644 files/config-rtc-MCP79410.service  "${ROOTFS_DIR}/etc/systemd/system/"
install -v -m 755 files/configrtc.sh  "${ROOTFS_DIR}/usr/local/bin/"

sed -i -e '/^#dtparam=i2c_arm=on/s/^#//' "${ROOTFS_DIR}"/boot/config.txt

on_chroot << EOF
systemctl enable config-rtc-MCP79410.service
EOF
