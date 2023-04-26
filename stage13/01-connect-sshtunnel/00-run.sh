#!/bin/bash -e

install -d "${ROOTFS_DIR}/usr/local/sshtunnel"
install -v -m 644 files/config "${ROOTFS_DIR}/usr/local/sshtunnel/"
install -v -m 600 files/id_ed25519_remote "${ROOTFS_DIR}/usr/local/sshtunnel/"
install -v -m 644 files/known_hosts "${ROOTFS_DIR}/usr/local/sshtunnel/"

install -v -m 644 files/*.service "${ROOTFS_DIR}/etc/systemd/system/"

on_chroot << EOF
systemctl enable ammp-connect.sshtunnel.service
EOF
