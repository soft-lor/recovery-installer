{
  description = "Recovery flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-std.url = "github:chessai/nix-std";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs:
    nixosConfigurations.HIKSEMI-NIXOS = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./system
      ];
    };
  };
}
