#!/usr/bin/env bash

# Format the partitions
format_partitions() {

  mkfs.fat -F 32 /dev/disk/by-partlabel/HIKSEMI-BOOT

  mkfs.btrfs -f /dev/disk/by-partlabel/HIKSEMI
  mount /dev/disk/by-partlabel/HIKSEMI /tmp/mnt --mkdir
  btrfs subvolume create /tmp/mnt/@ARCH
  btrfs subvolume create /tmp/mnt/@NIXOS
  btrfs subvolume create /tmp/mnt/@log
  btrfs subvolume create /tmp/mnt/@home
  umount /tmp/mnt --recursive
}

# Needs the disk to be partitioned as $1
partition_disk() {
  
  # Create the partition table
  parted --script $1 mklabel gpt

  # Boot partition, 1GB 
  parted --script $1 mkpart HIKSEMI-BOOT fat32 1MiB 1025MiB
  parted --script $1 set 1 esp on
  parted --script $1 name 1 HIKSEMI-BOOT

  # NixOS + Arch partition, remaining space of disk
  parted --script $1 mkpart HIKSEMI ext4 1025MiB 100%
  parted --script $1 name 2 HIKSEMI
}

select_disk() {
  local disk target response

  while true; do

    # List available disks
    echo "Available disks:"
    lsblk -d -o NAME,SIZE,MODEL,TYPE
    echo

    # Prompt for disk
    read -rp "Enter the disk to partition (e.g. sda, nvme0n1): " disk
    target="/dev/$disk"

    # Validate disk exists and is a block device
    if [ ! -b "$target" ]; then
      echo "Error: $target is not a valid disk."
      echo
      continue
    fi

    # Confirm selection
    read -rp "You selected $target. Are you sure you want to use this disk? [yes/NO]: " response
    case "$response" in
      [Yy][Ee][Ss]|[Yy])
        echo "Disk confirmed: $target"
        break
        ;;
      *)
        echo "Please try again."
        echo
        ;;
      esac
    done

  partition_disk "$target"
}

select_disk
format_partitions
