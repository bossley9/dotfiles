{ pkgs ? import <nixpkgs> {} }:

with pkgs; mkShell {
  name = "streamidle";

  nativeBuildInputs = [
    obs-studio
    # plugins
    obs-studio-plugins.obs-pipewire-audio-capture
    obs-studio-plugins.obs-vkcapture
    obs-studio-plugins.wlrobs
  ];
}

