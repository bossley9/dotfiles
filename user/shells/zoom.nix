{ pkgs ? import <nixpkgs> {} }:

with pkgs; mkShell {
  name = "zoom";

  nativeBuildInputs = [
    zoom-us
    pulseaudio # pactl dependency
  ];
}

