{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, darwin, ... }@inputs:
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
            (import ./machines/bastion/io.nix inputs)
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
            (import ./machines/aegir/io.nix inputs)
          ];
        };
      };
      darwinConfigurations = {
        C02FL5MBMD6M = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = [
            ./darwin/darwin-configuration.nix
            (import ./darwin/darwin-home.nix inputs)
          ];
        };
      };
    };
}
