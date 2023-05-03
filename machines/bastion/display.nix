{ home-manager, ... }:
{ config, lib, pkgs, ... }@args:

let
  username = "sam";
in
{
  imports = [ home-manager.nixosModules.home-manager ];

  # overwrite existing configuration with monitor configuration
  home-manager.users."${username}".home.file.".config/sway/config" = lib.mkForce {
    text = builtins.concatStringsSep "\n" [
      (builtins.readFile ../../user/config/sway/config)
      ''
        output "DP-1" {
          mode 1920x1080@60Hz
          pos 0 0
          transform normal
        }
        output "HDMI-A-1" {
          mode 1920x1080@60Hz
          pos 1920 0
          transform normal
        }
        exec_always wlr-randr --output DP-1 --preferred

        workspace 1 output "DP-1"
        workspace 2 output "DP-1"
        workspace 3 output "DP-1"
        workspace 4 output "DP-1"
        workspace 5 output "DP-1"
        workspace 6 output "HDMI-A-1"
        workspace 7 output "HDMI-A-1"
        workspace 8 output "HDMI-A-1"
        workspace 9 output "HDMI-A-1"
        workspace 10 output "HDMI-A-1"
      ''
    ];
  };
}
