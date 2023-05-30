#!/bin/bash -e

mkdir -p "${DEPLOY_DIR}"

SQFS_FILE="${DEPLOY_DIR}/${IMG_FILENAME}${IMG_SUFFIX}.sqfs"

if [ -f "$SQFS_FILE" ]; then
	mv -f $SQFS_FILE "${SQFS_FILE}.old"
fi;

mksquashfs $EXPORT_ROOTFS_DIR $SQFS_FILE -noappend -no-exports -no-fragments \
  -all-root -all-time 0 -mkfs-time 0 -noI -noD -noF -noX \
  -wildcards -e 'writable/*' -e 'boot/*' -e 'var/cache/apt/archives'
