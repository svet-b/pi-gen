#!/bin/bash -e

# Remove console from cmdline.txt
sed -i -e "s/console=ttyAMA0,[0-9]\+ //" "${ROOTFS_DIR}"/boot/cmdline.txt
sed -i -e "s/console=serial0,[0-9]\+ //" "${ROOTFS_DIR}"/boot/cmdline.txt

# This is required, but should already be in there from stage 1
cat >> "${ROOTFS_DIR}"/boot/config.txt << EOF
[all]
enable_uart=1

# Disable Bluetooth
dtoverlay=pi3-disable-bt
EOF

on_chroot << EOF
systemctl disable serial-getty@ttyAMA0.service
EOF
