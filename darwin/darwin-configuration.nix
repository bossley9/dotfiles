{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # functional
    fzf
    git
    neovim
    htop

    # formatters
    nixpkgs-fmt
  ];

  programs.zsh = {
    enable = true;
    promptInit = builtins.concatStringsSep "\n" [
      (builtins.readFile ../shared/navigationrc)
      (builtins.readFile ../user/config/zsh/zshrc)
    ];
    loginShellInit = builtins.readFile ../user/config/zsh/zprofile;
  };

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  system.stateVersion = 4;
}
