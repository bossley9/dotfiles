{ appimageTools, coreutils, fetchurl, ... }:

derivation {
  name = "webcord";
  builder = ./builder.sh;

  appimage = (appimageTools.wrapType2 {
    pname = "webcord";
    version = "3.8.1";

    src = fetchurl {
      url = "https://github.com/SpacingBat3/WebCord/releases/download/v3.8.1/WebCord-3.8.1-x64.AppImage";
      sha256 = "f7f7fb812d71cde738a44c53a0131f28ec4782f90f530b5d3d2f82c8d8c50d65";
    };
  });

  inherit coreutils;

  system = "x86_64-linux";
}
