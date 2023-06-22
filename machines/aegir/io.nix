{ home-manager, ... }:
{ config, lib, pkgs, ... }@args:

let
  username = "sam";
in
{
  imports = [ home-manager.nixosModules.home-manager ];

  home-manager.users."${username}" = {
    home.packages = with pkgs; [
      networkmanagerapplet
    ];

    home.file.".config/sway/config" = lib.mkForce {
      text = builtins.concatStringsSep "\n" [
        (builtins.readFile ../../user/config/sway/config)
        (builtins.readFile ./swayconfig)
      ];
    };
  };
}
