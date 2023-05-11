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

  system.defaults = {
    NSGlobalDomain = {
      InitialKeyRepeat = 10;
      KeyRepeat = 1;
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  system.stateVersion = 4;
}
