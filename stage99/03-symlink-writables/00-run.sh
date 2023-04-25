#!/bin/bash -e

DIRS="home
root
var/lib/chrony
var/lib/dbus
var/lib/dhcpcd
var/lib/systemd
var/log
var/tmp"

FILES=""

for d in $DIRS ; do
    if [ -L "${ROOTFS_DIR}/$d" ]; then
        # If this is already a symlink, then don't do anything
        continue
    fi
    if [ -d "${ROOTFS_DIR}/writable/$d" ]; then
        rm -rf "${ROOTFS_DIR}/writable/$d"
    fi
    mkdir -p "${ROOTFS_DIR}/writable/$(dirname $d)"
    mv "${ROOTFS_DIR}/$d" "${ROOTFS_DIR}/writable/$(dirname $d)" || true
    ln -sfv /writable/$d "${ROOTFS_DIR}/$(dirname $d)"
done

for f in $FILES ; do
    if [ -L "${ROOTFS_DIR}/$d" ]; then
        # If this is already a symlink, then don't do anything
        continue
    fi
    if [ -f "${ROOTFS_DIR}/writable/$f" ]; then
        rm -f "${ROOTFS_DIR}/writable/$f"
    fi
    mkdir -p "${ROOTFS_DIR}/writable/$(dirname $f)"
    mv "${ROOTFS_DIR}/$f" "${ROOTFS_DIR}/writable/$(dirname $f)/$f" || true
    ln -sfv /writable/$f "${ROOTFS_DIR}/$f"
done

ln -sfv /run/resolvconf/resolv.conf "${ROOTFS_DIR}/etc/resolv.conf"

chmod 777 "${ROOTFS_DIR}/writable/var/tmp"

# For snaps
ln -sfv /writable/var/snap "${ROOTFS_DIR}/var/snap"
