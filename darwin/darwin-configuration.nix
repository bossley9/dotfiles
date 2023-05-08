{ config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.htop
    pkgs.neovim
  ];

  programs.zsh.enable = true;

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  system.stateVersion = 4;
}
