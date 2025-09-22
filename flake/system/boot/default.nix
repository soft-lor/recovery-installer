{
  boot = {
    loader = {
      grub = {
        enable = true;
        device = ["/dev/disk/by-partlabel/HIKSEMI-BOOT"];
        efiSupport = true;
      };
      efi.canTouchEfiVariables = true;
      timeout = 10;
    };
  };
}
