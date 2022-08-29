{ config, pkgs, ... }:

{
  scene = pkgs.writeScriptBin "scene" ''
    echo hello world!
  '';
}
