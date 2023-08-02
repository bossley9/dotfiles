# waiting for init at https://github.com/NixOS/nixpkgs/pull/241992
{ lib, fetchurl, appimageTools, libsecret }:
let
  pname = "beeper";
  version = "3.61.6";
  src = fetchurl {
    url = "https://download.todesktop.com/2003241lzgn20jd/beeper-${version}.AppImage";
    hash = "sha256-/LwEfBrrSW0aJcgKRSiGbP9MWwzENMiWlfzhAu5utSA=";
  };
in
appimageTools.wrapType2 rec {
  inherit pname src;
  name = pname;

  extraPkgs = pkgs: with pkgs; [ libsecret ];

  meta = with lib; {
    description = "Beeper is a universal chat app. With Beeper, you can send and receive messages to friends, family and colleagues on many different chat networks.";
    homepage = "https://beeper.com";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ jshcmpbll ];
    platforms = [ "x86_64-linux" ];
  };
}
