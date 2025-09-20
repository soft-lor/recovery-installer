#!/usr/bin/env bash

ensure_deps() {

  # Get current distro name
  current_distro=$(echo $(cat /etc/os-release | grep -w "NAME=*" | awk -F "=" '{print $2}') | tr -d '"')

  if [ "$current_distro" = "NixOS" ]; then 

    # Install deps
    nix-env -iA arch-install-scripts parted

    # Create a tmpfs where to bootstrap a small arch installation
    umount -q --recursive /tmp/arch-bootstrap
    mount -t tmpfs -o size=1G tmpfs /tmp/arch-bootstrap

    # Install arch into the tmpfs
    arch-bootstrap /tmp/arch-bootstrap
    pacstrap -K /tmp/arch-bootstrap arch-install-scripts archinstall

    # Ensure system dirs for the arch bootstrap
    mount --bind /proc /tmp/arch-bootstrap/proc
    mount --bind /sys /tmp/arch-bootstrap/sys
    mount --bind /dev /tmp/arch-bootstrap/dev
    mount --bind /dev/pts /tmp/arch-bootstrap/dev/pts
    
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
