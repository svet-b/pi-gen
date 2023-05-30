#!/bin/bash -e

if [ ! "${FULL_IMG}" = "1" ]; then
  echo "Skipping population of rootfs because FULL_IMG != 1"
  exit 0
fi

ROOT_DEV="$(mount | grep "${ROOTFS_DIR} " | cut -f1 -d' ')"
BOOT_DEV="$(mount | grep "${STAGE_WORK_DIR}/bootfs " | cut -f1 -d' ')"

# Make img subvolume and copy root image
btrfs subvolume create "${ROOTFS_DIR}/@img"
mkdir -p "${ROOTFS_DIR}/@img/root"
install -v -m 644 "${DEPLOY_DIR}/${IMG_FILENAME}${IMG_SUFFIX}.sqfs" "${ROOTFS_DIR}/@img/root"
ln -s "./${IMG_FILENAME}${IMG_SUFFIX}.sqfs" "${ROOTFS_DIR}/@img/root/root.sqfs"

# Make writable subvolume and copy files
btrfs subvolume create "${ROOTFS_DIR}/@writable"
rsync -aHAXx "${EXPORT_ROOTFS_DIR}/writable/" "${ROOTFS_DIR}/@writable/"

# Make overlay subvolume and populate needed files
btrfs subvolume create "${ROOTFS_DIR}/@overlay"
mkdir -p "${ROOTFS_DIR}/@overlay/data" "${ROOTFS_DIR}/@overlay/work"

# Populate bootfs
mkdir -p "${STAGE_WORK_DIR}/bootfs"
rsync -rtx "${EXPORT_ROOTFS_DIR}/boot/" "${STAGE_WORK_DIR}/bootfs/"
