#!/usr/bin/env bash

# Mount subvolume for installation
umount -q --recursive /mnt
mount -o subvol=@ARCH,compress=zstd /dev/disk/by-label/HIKSEMI /mnt --mkdir
mount -o subvol=@log,compress=zstd /dev/disk/by-label/HIKSEMI /mnt/var/log --mkdir
mount -o subvol=@home,compress=zstd /dev/disk/by-label/HIKSEMI /mnt/home --mkdir
mount /dev/disk/by-label/HIKSEMI-BOOT /mnt/boot --mkdir

# Install system
archinstall ./user_configuration.json
