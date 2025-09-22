{inputs, ...}: {
  imports = [
    ./network
    ./audio
    ./boot
    ./hardware
    ./kde
    inputs.nix-index-database.nixosModules.nix-index
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Set your time zone.
  time.timeZone = "America/Argentina/Buenos_Aires";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_AR.UTF-8";
    LC_IDENTIFICATION = "es_AR.UTF-8";
    LC_MEASUREMENT = "es_AR.UTF-8";
    LC_MONETARY = "es_AR.UTF-8";
    LC_NAME = "es_AR.UTF-8";
    LC_NUMERIC = "es_AR.UTF-8";
    LC_PAPER = "es_AR.UTF-8";
    LC_TELEPHONE = "es_AR.UTF-8";
    LC_TIME = "es_AR.UTF-8";
  };

  # Do not modify even if there a new stable release
  # Check for all options changes if you really need to
  system.stateVersion = "25.05";

  # boot.kernelPackages = pkgs.linuxPackages_latest;
}
