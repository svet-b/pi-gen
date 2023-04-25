#!/bin/bash -e

echo "Attempting to expand root partition"

SD_DEV=/dev/mmcblk0
ROOT_PART_LABEL=rootfs

ROOT_PART_DEV=$(blkid -o device -t LABEL=\"${ROOT_PART_LABEL}\")
ROOT_PART_NUM=${ROOT_PART_DEV#${SD_DEV}p}

# Get the starting offset of the var partition
ROOT_PART_START=$(parted "$SD_DEV" -ms unit s p | grep "^${ROOT_PART_NUM}" | cut -f 2 -d: | sed 's/[^0-9]//g')
echo "Expanding partition"
fdisk $SD_DEV <<EOF
p
d
$ROOT_PART_NUM
n
p
$ROOT_PART_NUM
$ROOT_PART_START

p
w
EOF
sleep 1

echo "Reloading partition table"
partprobe $SD_DEV

echo "Expanding filesystem $ROOT_PART_DEV"
# Btrfs resize only works on mounted filesystem
TMPMNT=$(mktemp -d)
mount -t btrfs $ROOT_PART_DEV $TMPMNT
btrfs filesystem resize max $TMPMNT
umount $TMPMNT
