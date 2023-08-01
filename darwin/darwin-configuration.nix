{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # functional
    oksh
    fzf
    git
    neovim
    htop
    # LSP servers
    nodePackages.vscode-langservers-extracted # eslint, jsonls
    nixd
    prettierd
    nodePackages.typescript-language-server

    # ui
    jetbrains-mono
    kitty

    # work tools
    yarn
    deno

    # formatters
    nixpkgs-fmt
    luaformatter
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
  nix.extraOptions = ''
    build-users-group = nixbld
  '';

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  system.stateVersion = 4;
}
