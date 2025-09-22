{
  pkgs,
  inputs,
  theme,
  host,
  std,
  ...
}: {
  imports = [
    ./tmux.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow executing binaries
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add missing libraries for binaries here, not to systemPackages
    icu #osu-beatmap-exporter
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
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

  programs = {
    zsh.enable = true;
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    # command-not-found.enable = true;
    nix-index.enableZshIntegration = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    plemoljp
  ];
}
