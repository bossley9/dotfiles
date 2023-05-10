{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # functional
    git
    neovim
    htop

    # formatters
    nixpkgs-fmt
  ];

  programs.zsh = {
    enable = true;
    promptInit = builtins.readFile ../user/config/zsh/zshrc;
  };

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  system.stateVersion = 4;
}
