{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    # web development
    nodejs
    # prototyping and small projects
    go deno
  ];
}

