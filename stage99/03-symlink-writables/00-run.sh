#!/bin/bash -e

DIRS="home
root
var/lib/chrony
var/lib/dbus
var/lib/dhcpcd
var/lib/systemd
var/log"

FILES=""
# Maybe var/lib/snapd/state.json if snapd installed

for d in $DIRS ; do
    if [ -d "${ROOTFS_DIR}/writable/$d" ]; then
        rm -rf "${ROOTFS_DIR}/writable/$d"
    fi
    mv "${ROOTFS_DIR}/$d" "${ROOTFS_DIR}/writable/" || true
    ln -sfv /writable/$d "${ROOTFS_DIR}/$(dirname $d)"
done

for f in $FILES ; do
    if [ -f "${ROOTFS_DIR}/writable/$f" ]; then
        rm -f "${ROOTFS_DIR}/writable/$f"
    fi
    mkdir -p "${ROOTFS_DIR}/writable/$(dirname $f)"
    mv "${ROOTFS_DIR}/$f" "${ROOTFS_DIR}/writable/$(dirname $f)" || true
    ln -sfv /writable/$f "${ROOTFS_DIR}/$f"
done

ln -sfv /run/resolvconf/resolv.conf "${ROOTFS_DIR}/etc/resolv.conf"
