{ fetchgit, pkgs, stdenv, ... }:

let
  pname = "wlay";
  version = "ed316060ac3ac122c0d3d8918293e19dfe9a6c90";
in
stdenv.mkDerivation {
  inherit pname version;

  # fetchFromGitHub doesn't play nicely with submodules
  src = fetchgit {
    url = "https://github.com/atx/wlay.git";
    rev = version;
    sha256 = "sha256-bKnY1vpZUXyoX9pa6WPtXQr4L7Lv9Q2oT/w8WoDEkL4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkgs.cmake
    pkgs.epoxy
    pkgs.extra-cmake-modules
    pkgs.glfw3
    pkgs.wayland
    pkgs.xorg.libX11
  ];

  buildPhase = ''
    cd $TMPDIR
    cmake $src
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp $TMPDIR/wlay $out/bin/wlay
    chmod 555 $out/bin/wlay
  '';
}
