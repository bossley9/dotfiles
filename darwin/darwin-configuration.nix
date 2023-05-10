{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    htop
    neovim
    nixpkgs-fmt
  ];

  programs.zsh = {
    enable = true;
    shellInit = ''
      alias nrs="darwin-rebuild switch --flake .#"
    '';
  };

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  system.stateVersion = 4;
}
