{ pkgs ? import <nixpkgs> {} }:

with pkgs; mkShell {
  name = "videoediting";

  nativeBuildInputs = [
    kdenlive
  ];
}
