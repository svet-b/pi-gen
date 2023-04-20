#!/bin/bash -e

DIRS="home
root
var/log/chrony
var/log/journal"

FILES="var/log/wtmp
var/log/lastlog
var/lib/systemd/random-seed
var/lib/chrony/chrony.drift"
# Maybe var/lib/snapd/state.json if snapd installed

for d in $DIRS ; do
    if [ -d "${ROOTFS_DIR}/writable/$d" ]; then
        rm -rf "${ROOTFS_DIR}/writable/$d"
    fi
    mv "${ROOTFS_DIR}/$d" "${ROOTFS_DIR}/writable/" || true
    ln -sf /writable/$d "${ROOTFS_DIR}/"
done

for f in $FILES ; do
    if [ -f "${ROOTFS_DIR}/writable/$f" ]; then
        rm -f "${ROOTFS_DIR}/writable/$f"
    fi
    mkdir -p "${ROOTFS_DIR}/writable/$(dirname $f)"
    mv "${ROOTFS_DIR}/$f" "${ROOTFS_DIR}/writable/$(dirname $f)" || true
    ln -sf /writable/$f "${ROOTFS_DIR}/$f"
done

ln -sf /run/resolvconf/resolv.conf "${ROOTFS_DIR}/etc/resolv.conf"
