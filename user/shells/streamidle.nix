{ pkgs ? import <nixpkgs> {} }:

with pkgs; mkShell {
  name = "streamidle";

  nativeBuildInputs = [
    (wrapOBS.override { obs-studio = pkgs.obs-studio; } {
      plugins = with obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
        obs-vkcapture
      ];
    })
  ];

  shellHook = ''
    export QT_QPA_PLATFORM=wayland
  '';
}

