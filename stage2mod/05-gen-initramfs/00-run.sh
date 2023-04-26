#!/bin/bash -e

install -m 644 files/ae-initramfs.conf "${ROOTFS_DIR}/etc/initramfs-tools/conf.d/"
install -m 644 files/modules "${ROOTFS_DIR}/etc/initramfs-tools/modules"
install -m 644 files/overlay "${ROOTFS_DIR}/etc/initramfs-tools/scripts/"

KVER=$(ls "${ROOTFS_DIR}/usr/lib/modules" -1 | tail -n 1)

on_chroot << EOF
update-initramfs -u -k $KVER
EOF

cat >> "${ROOTFS_DIR}"/boot/config.txt << EOF
[all]
initramfs initrd.img-$KVER
EOF