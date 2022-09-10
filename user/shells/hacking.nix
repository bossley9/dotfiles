{ pkgs ? import <nixpkgs> {} }:

with pkgs; mkShell {
  nativeBuildInputs = [
    # web development
    nodejs
    # prototyping and small projects
    deno
  ];

  shellHook = ''
    umask 0077
    set -o vi
  '';
}

