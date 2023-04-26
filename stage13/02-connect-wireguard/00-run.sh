#!/bin/bash -e

install -v -m 755 files/set_wg_config.sh "${ROOTFS_DIR}/usr/local/bin/"

install -v -m 644 files/*.service "${ROOTFS_DIR}/etc/systemd/system/"

on_chroot << EOF
systemctl enable ammp-connect.wireguard.service
EOF
