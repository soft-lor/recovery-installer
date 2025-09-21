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
pacstrap -K /mnt base linux-lts linux-firmware btrfs-progs neovim sudo git base-devel reflector

# Mount EFI and generate the fstab file
mount /dev/disk/by-partlabel/HIKSEMI-BOOT /boot --mkdir
genfstab -L /mnt >> /mnt/etc/fstab

# Set hostname
cat "RECOVERY-ARCH" > /mnt/etc/hostname

# Set keymap and set up locale
cat "KEYMAP=us" > /mnt/etc/vconsole.conf
cat "LANG=en_US.UTF-8" > /mnt/etc/locale.conf
cat "en_US.UTF-8 UTF-8" > /mnt/etc/locale.gen
arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime"
arch-chroot /mnt /bin/bash -c "hwclock --systohc && locale-gen"

# Configure root access for wheel
echo "%wheel ALL=(ALL) ALL" > /mnt/etc/sudoers.d/00-wheel
chmod 440 /mnt/etc/sudoers.d/00-wheel

# Set root password and main user
echo "Please set the root password:"
passwd -R /mnt
useradd -R /mnt -m -G wheel,audio,video -s /bin/zsh lorem
echo "Please set the user password:"
passwd -R /mnt lorem

# Set a temporary builder user to build yay
useradd -R /mnt -s /bin/bash builder
passwd -R /mnt -d builder
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /mnt/etc/sudoers.d/builder
chmod 440 /mnt/etc/sudoers.d/builder
arch-chroot -u builder /mnt /bin/bash -c "git clone https://aur.archlinux.org/yay-bin.git /tmp/yay && cd /tmp/yay && makepkg --noconfirm -si"

# Install desktop environment
arch-chroot -u builder /mnt /bin/bash -c "yay --noconfirm -S plasma kitty sddm pipewire wireplumber zen-browser-bin"

# Enable systemd services
arch-chroot /mnt /bin/bash -c "ln /etc/systemd/system/display-manager.service /usr/lib/systemd/system/sddm.service"
arch-chroot /mnt /bin/bash -c "ln /etc/systemd/system/timers.target.wants/reflector.timer /usr/lib/systemd/system/reflector.timer"

# Clean the builder user
rm /mnt/etc/sudoers.d/builder
userdel -R /mnt builder

# Unmount the new system
umount -q --recursive /mnt
