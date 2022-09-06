{ pkgs ? import <nixpkgs> {} }:

with pkgs; mkShell {
  nativeBuildInputs = [
    jdk17_headless
    polymc
  ];
}
