#!/bin/bash -e


# Mount last created image
IMAGE_FILE="$(ls -1 deploy/*.img | tail -1)"
LOOPDEV=$(losetup -Pf --show $IMAGE_FILE)
TMPROOT=$(mktemp -d)
mount ${LOOPDEV}p2 $TMPROOT

# Create squashfs
SQFS_FILE="${IMAGE_FILE%.*}.sqfs"
mksquashfs $TMPROOT $SQFS_FILE -noappend -no-exports -no-fragments \
  -all-root -all-time 0 -mkfs-time 0 -noI -noD -noF -noX \
  -e writable

# Cleanup
umount $TMPROOT
rmdir $TMPROOT
losetup -d $LOOPDEV
