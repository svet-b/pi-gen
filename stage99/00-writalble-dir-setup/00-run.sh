#!/bin/bash -e

mkdir -p "${ROOTFS_DIR}/writable"

if [ ! -d "${ROOTFS_DIR}/writable/home" ]; then
    mv "${ROOTFS_DIR}/home" "${ROOTFS_DIR}/writable/"
    ln -sf writable/home "${ROOTFS_DIR}/"
fi

if [ ! -d "${ROOTFS_DIR}/writable/root" ]; then
    mv "${ROOTFS_DIR}/root" "${ROOTFS_DIR}/writable/"
    ln -sf writable/root "${ROOTFS_DIR}/"
fi
