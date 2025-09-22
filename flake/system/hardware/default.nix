{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Important to let flake know what profile to use
  networking.hostName = "HIKSEMI-NIXOS";
  networking.useDHCP = lib.mkForce true;

  # Configure keymap
  console.keyMap = "us";
  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };

  # Bootloader.
  boot = {
    initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "sdhci_pci"];
    initrd.kernelModules = [];
    kernelModules = [];
    extraModulePackages = [];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-partlabel/HIKSEMI";
      fsType = "btrfs";
      options = ["subvol=@" "noatime"];
    };
    "/home" = {
      device = "/dev/disk/by-partlabel/HIKSEMI";
      fsType = "btrfs";
      options = ["subvol=@home" "noatime"];
    };
    "/var/log" = {
      device = "/dev/disk/by-partlabel/HIKSEMI";
      fsType = "btrfs";
      options = ["subvol=@log" "noatime"];
      neededForBoot = true;
    };
    "/boot" = {
      device = "/dev/disk/by-partlabel/HIKSEMI-BOOT";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
  };

  swapDevices = [];

  hardware.graphics.enable = true;
}
