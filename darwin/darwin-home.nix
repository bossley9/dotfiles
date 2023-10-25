smbShareName:
{ home-manager, ... }:
{ config, pkgs, ... }:

let
  username = "sbossley";
in
{
  imports = [
    home-manager.darwinModules.home-manager
  ];

  # username must be declared by config.users.users for home-manager detection
  users.users."${username}" = {
    shell = [ pkgs.oksh ];
    home = "/Users/${username}";
  };
  home-manager.users."${username}" = {
    home.file.".profile" = {
      text = builtins.concatStringsSep "\n" [
        ". /etc/zshenv"
        (builtins.readFile ../user/config/zsh/zprofile)
      ];
      executable = true;
    };
    home.file.".config/sh/shrc" = {
      text = builtins.concatStringsSep "\n" [
        (builtins.readFile ../shared/navigationrc)
        (builtins.readFile ../user/config/zsh/zshrc)
        "alias drive=\"open smb://${smbShareName}\""
      ];
      executable = true;
    };

    home.file.".config/kitty/kitty.conf".source = ../user/config/kitty/kitty.conf;

    home.file.".config/rg/rgrc".source = ../user/config/rg/rgrc;
    home.file.".config/bat/config".source = ../user/config/bat/config;

    home.file.".hammerspoon/init.lua".source = ../user/config/hammerspoon/hammerspoon.lua;

    home.file.".config/nvim".source = ../user/config/nvim;

    home.file.".config/git/config".source = ../user/config/git/config;

    home.stateVersion = "22.05";
  };
}
