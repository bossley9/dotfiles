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
  users.users."${username}".shell = [ pkgs.zsh ];
  home-manager.users."${username}" = {
    home.file.".config/kitty/kitty.conf".source = ../user/config/kitty/kitty.conf;

    home.file.".config/rg/rgrc".source = ../user/config/rg/rgrc;
    home.file.".config/bat/config".source = ../user/config/bat/config;

    home.file.".config/nvim".source = ../user/config/nvim;

    home.file.".config/git/config".source = ../user/config/git/config;

    home.stateVersion = "22.05";
  };
}
