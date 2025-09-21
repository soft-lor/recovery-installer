#!/usr/bin/env bash

ensure_deps() {

  if [ "$current_distro" = "NixOS" ]; then 

    # Install deps
    nix-env -iA nixpkgs.arch-install-scripts nixpkgs.parted

    # Get arch-bootstrap
    git clone https://github.com/tokland/arch-bootstrap.git /tmp/bin/arch-bootstrap

    # Create a tmpfs where to bootstrap a small arch installation
    umount -q --recursive /tmp/arch-bootstrap
    mount -t tmpfs -o size=10G tmpfs /tmp/arch-bootstrap --mkdir

    # Install arch into the tmpfs
    sh /tmp/bin/arch-bootstrap/arch-bootstrap.sh /tmp/arch-bootstrap

    # Ensure system dirs for the arch bootstrap
    mount --bind /proc /tmp/arch-bootstrap/proc
    mount --bind /sys /tmp/arch-bootstrap/sys
    mount --bind /dev /tmp/arch-bootstrap/dev
    mount --bind /dev/pts /tmp/arch-bootstrap/dev/pts

    # Add installation scripts to the arch bootstrap
    arch-chroot /tmp/arch-bootstrap /bin/bash -c "pacman --noconfirm -Sy arch-install-scripts archinstall"
    
  elif [ "$current_distro" = "Arch Linux" ]; then
    
    # Install nix package manager
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s install
    nix-channel --add https://nixos.org/channels/nixpkgs-unstable
    nix-channel --update

    # Install deps
    pacman --noconfirm -Sy arch-install-scripts parted
    nix-env -iA nixpkgs.nixos-install-tools

  else
    echo "Error: Current system is not recognized as NixOS nor Arch Linux. Exiting." && exit 1
  fi
}

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root. Try: sudo $0" >&2
  echo "Please ensure you have read the script before running it with sudo"
  exit 1
fi

# Get current distro name
current_distro=$(echo $(cat /etc/os-release | grep -w "NAME=*" | awk -F "=" '{print $2}') | tr -d '"')

ensure_deps
bash ./partition.sh

if [ "$current_distro" = "NixOS" ]; then 

  # Setup the arch bootstrap
  arch-chroot /tmp/arch-bootstrap /bin/bash -c "/usr/bin/update-ca-trust"
  arch-chroot /tmp/arch-bootstrap /bin/bash -c "pacman --noconfirm -S reflector"
  arch-chroot /tmp/arch-bootstrap /bin/bash -c "reflector --latest 5 --country Brazil --sort rate --save /etc/pacman.d/mirrorlist"

  # Install arch from inside the arch-bootstrap in tmpfs
  touch /tmp/arch-bootstrap/arch.sh
  mount --bind ./arch.sh /tmp/arch-bootstrap/arch.sh
  arch-chroot /tmp/arch-bootstrap /bin/bash "/arch.sh"

fi

umount --recursive -q /tmp/mnt /mnt
