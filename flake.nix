{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
    lib = nixpkgs.lib;
  in
  {
    nixosConfigurations = {
      bastion = lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          (import ./user/home.nix inputs)
        ];
      };
    };
  };
}
