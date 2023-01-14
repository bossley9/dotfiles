# adapted from https://github.com/NixOS/nixpkgs/blob/350fd0044447ae8712392c6b212a18bdf2433e71/pkgs/applications/misc/sc-im/default.nix
# for custom scopen capability
{ bison, fetchFromGitHub, gnuplot, lib, libxls, libxlsxwriter, libxml2, libzip, makeWrapper, ncurses, pkg-config, stdenv, which, ... }:

stdenv.mkDerivation rec {
  pname = "sc-im";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "andmarti1424";
    repo = "sc-im";
    rev = "v${version}";
    sha256 = "sha256-H+GQUpouiXc/w6GWdkSVvTXZ/Dtb7sUmBLGcpxG3Mts=";
  };

  sourceRoot = "${src.name}/src";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    which
    bison
  ];

  buildInputs = [
    gnuplot
    libxls
    libxlsxwriter
    libxml2
    libzip
    ncurses
  ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  scopen = ./scopen;
  postInstall = ''
    wrapProgram "$out/bin/sc-im" --prefix PATH : "${lib.makeBinPath [ gnuplot ]}"
    # overwrite default scopen
    cp -v $scopen $out/bin/scopen
  '';

  meta = with lib; {
    homepage = "https://github.com/andmarti1424/sc-im";
    description = "An ncurses spreadsheet program for terminal";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.unix;
  };
}
