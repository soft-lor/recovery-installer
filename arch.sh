#!/usr/bin/env bash

# Mount subvolume for installation
umount -q --recursive /mnt
mount -o subvol=@ARCH,compress=zstd /dev/disk/by-partlabel/HIKSEMI /mnt --mkdir
mount -o subvol=@log,compress=zstd /dev/disk/by-partlabel/HIKSEMI /mnt/var/log --mkdir
mount -o subvol=@home,compress=zstd /dev/disk/by-partlabel/HIKSEMI /mnt/home --mkdir
mount /dev/disk/by-partlabel/HIKSEMI-BOOT /mnt/boot --mkdir

# Prepare the system for installation
pacman --noconfirm -Sy reflector arch-install-scripts
reflector --latest 5 --country Brasil --sort rate --save /etc/pacman.d/mirrorlist

# Install base system
pacstrap -K /mnt base linux-lts linux-firmware btrfs-progs neovim sudo git base-devel

# Mount EFI and generate the fstab file
mount /dev/disk/by-partlabel/HIKSEMI-BOOT /boot --mkdir
genfstab -L /mnt >> /mnt/etc/fstab

# Set hostname
cat "RECOVERY-ARCH" > /mnt/etc/hostname

# Set keymap and set up locale
cat "KEYMAP=us" > /mnt/etc/vconsole.conf
cat "LANG=en_US.UTF-8" > /mnt/etc/locale.conf
cat "en_US.UTF-8 UTF-8" > /mnt/etc/locale.gen

# Configure root access for wheel
echo "%wheel ALL=(ALL) ALL" > /mnt/etc/sudoers.d/00-wheel
chmod 440 /mnt/etc/sudoers.d/00-wheel


# Run chrooted commands
arch-chroot /mnt /bin/bash <<'EOF'
  ln -sf /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime
  hwclock --systohc
  locale-gen

  # Install desktop packages
  pacman --noconfirm -S plasma kitty sddm pipewire wireplumber

  systemctl enable sddm.service

  # ---------------------------------- #
  #     NEED TO FIX FROM HERE DOWN     #
  # ---------------------------------- #
  
  systemctl enable reflector.timer

  echo "Please set the root password:"
  passwd

  useradd -m -G wheel,audio,video -s /bin/zsh lorem

  # yay installation
  su lorem
  git clone https://aur.archlinux.org/yay-bin.git /tmp/yay
  cd /tmp/yay
  makepkg -si
  exit

  echo "Please set the user password:"
  passwd lorem

  yay --noconfirm zen-browser-bin
EOF
