#!/bin/bash -e

if [ ! "${FULL_IMG}" = "1" ]; then
  echo "Skipping rescue image generation because FULL_IMG != 1"
  exit 0
fi

# Create a copy of the root filesystem that we can modify
RESCUE_DIR="${STAGE_WORK_DIR}/rescue"
rsync -aHAXx --exclude /var/cache/apt/archives --exclude /boot "${EXPORT_ROOTFS_DIR}/" "${RESCUE_DIR}/"

# Generate SSH keys
rm -f ${RESCUE_DIR}/etc/ssh/ssh_host_*_key*
ssh-keygen -t ed25519 -N "" -f ${RESCUE_DIR}/etc/ssh/ssh_host_ed25519_key
ssh-keygen -t ecdsa -N "" -f ${RESCUE_DIR}/etc/ssh/ssh_host_ecdsa_key

# Disable firstboot services
rm ${RESCUE_DIR}/etc/systemd/system/multi-user.target.wants/firstboot-*.service

# Remove Btrfs mounts from fstab
sed -i '/^LABEL=rootfs/d' ${RESCUE_DIR}/etc/fstab

SQFS_FILE="${STAGE_WORK_DIR}/bootfs/rescue.sqfs"

mksquashfs $RESCUE_DIR $SQFS_FILE -noappend -no-exports -no-fragments \
  -all-root -all-time 0 -mkfs-time 0 -comp xz \
  -wildcards -e 'boot/*'
