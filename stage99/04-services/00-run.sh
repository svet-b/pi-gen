#!/bin/bash -e

install -v -m 644 files/*.service "${ROOTFS_DIR}/etc/systemd/system/"
install -v -m 755 files/set_hostname_from_mac.sh "${ROOTFS_DIR}/usr/local/bin/"
install -v -m 755 files/resize_rootfs.sh "${ROOTFS_DIR}/usr/local/bin/"

on_chroot << EOF
systemctl enable firstboot-commit-machine-id.service
systemctl enable firstboot-generate-ssh-keys.service
systemctl enable firstboot-resize-rootfs.service
systemctl enable firstboot-set-hostname.service
systemctl enable firstboot-reboot.service
EOF
