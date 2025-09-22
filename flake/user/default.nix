{pkgs, ...}: {
  imports = [
    ./packages
  ];

  users.users.lorem = {
    isNormalUser = true;

    # User full name
    description = "Lorem";
    extraGroups = ["networkmanager" "wheel" "video" "adbusers"];

    shell = pkgs.zsh;

    hashedPassword = "$y$j9T$LnXVIyVNTLNwptoznMKvx0$Gpdb3vFTIrYX44ACOQOmEby/2pwbZE.91CaDb4/6fRB";
  };

  environment.variables = {
    EDITOR = "nvim";
  };
}
