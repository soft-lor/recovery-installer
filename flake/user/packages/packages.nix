{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [

    (callPackage ./wrapped/kitty)
    gptfdisk
    efibootmgr
    btrfs-progs
    fbterm
    wireguard-tools
    e2fsprogs
    dosfstools
    ntfs3g
    ethtool
    iw
    unzip
    testdisk
    photorec
    ddrescue
    neovim
    btop
    tmux
    smartmontools
    hdparm
    pciutils
    usbutils
    nix
    rsync
  ];

  networking.networkmanager.enable = true;

  programs = {
    zsh.enable = true;
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    command-not-found.enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  environment.variables = {
    EDITOR = "nvim";
  };
}
