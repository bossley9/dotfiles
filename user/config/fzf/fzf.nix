{ config, pkgs, lib, ... }:

let
  bindings = builtins.concatStringsSep "," [
    "--bind alt-k:up"
    "alt-j:down"
    "alt-u:half-page-up"
    "alt-d:half-page-down"
    "alt-h:backward-delete-char"
    "alt-q:abort"
    "alt-l:accept"
  ];
  colors = builtins.concatStringsSep "," [
    "--color bg+:-1"
    "pointer:#81A1C1"
    "hl:#81A1C1"
    "hl+:#B48EAD"
    "info:#A3BE8C"
  ];
in
{
  enable = true;
  enableBashIntegration = false;
  enableFishIntegration = false;
  enableZshIntegration = false;
  defaultCommand = "rg --files --hidden --follow --glob '!.git/*'";
  defaultOptions = [
    bindings
    colors
    "--ansi" # keep ansi color codes
  ];
}
