{ pkgs ? import <nixpkgs> {} }:

with pkgs; mkShell {
  nativeBuildInputs = [
    # web development
    nodejs
    # prototyping and small projects
    go deno
  ];
}

