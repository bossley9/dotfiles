{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, ... }@inputs:
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
            ./machines/bastion/hardware-configuration.nix
            (import ./shared/configuration.nix inputs)
            ./machines/bastion/bastion.nix
            (import ./user/home.nix inputs)
            (import ./machines/bastion/display.nix inputs)
          ];
        };
        aegir = lib.nixosSystem {
          inherit system;
          modules = [
            ./machines/aegir/hardware-configuration.nix
            nixos-hardware.nixosModules.framework
            (import ./shared/configuration.nix inputs)
            ./machines/aegir/aegir.nix
            (import ./user/home.nix inputs)
          ];
        };
      };
    };
}
