{ fetchFromGitHub, libpulseaudio, meson, ninja, pkg-config, stdenv, wayland, wayland-protocols, ... }:

stdenv.mkDerivation rec {
  pname = "sway-audio-idle-inhibit";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayAudioIdleInhibit";
    rev = "4a481a04b33da108ddcccb0557d6ea3eada13973";
    sha256 = "1c55vbar97n17hzl9gla43bd26n4yc7vrf87ly0b2fwpwr8i8iax";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ wayland wayland-protocols libpulseaudio ];
}
