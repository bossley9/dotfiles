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

    home.stateVersion = "22.05";
  };
}
