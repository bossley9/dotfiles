# https://github.com/NixOS/nixpkgs/blob/32abfcc92306345b124aa2201d337d5c6f2a7469/pkgs/applications/audio/ncspot/default.nix
# patched for share_clipboard build option
{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, ncurses
, openssl
, withALSA ? true
, alsa-lib
, withPulseAudio ? false
, libpulseaudio
, withPortAudio ? false
, portaudio
, withMPRIS ? false
, dbus
, withShareClipboard ? false
, xorg
, python3
}:

rustPlatform.buildRustPackage rec {
  pname = "ncspot";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "hrkfdn";
    repo = "ncspot";
    rev = "v${version}";
    hash = "sha256-YWA8chp33SkMdo+XT/7qikIkgwt8pozC9wMFpY8Dv8Q=";
  };

  cargoHash = "sha256-DB3r6pPtustEQG8QXM6qT1hkd7msC//46bhVP/HMxnY=";

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optional withShareClipboard python3;

  buildInputs = [ ncurses ]
    ++ lib.optional stdenv.isLinux openssl
    ++ lib.optional withALSA alsa-lib
    ++ lib.optional withPulseAudio libpulseaudio
    ++ lib.optional withPortAudio portaudio
    ++ lib.optional withMPRIS dbus
    ++ lib.optional withShareClipboard xorg.libxcb;

  buildNoDefaultFeatures = true;
  buildFeatures = [ "cursive/pancurses-backend" ]
    ++ lib.optional withALSA "alsa_backend"
    ++ lib.optional withPulseAudio "pulseaudio_backend"
    ++ lib.optional withPortAudio "portaudio_backend"
    ++ lib.optional withMPRIS "mpris"
    ++ lib.optional withShareClipboard "share_clipboard";

  doCheck = false;

  meta = with lib; {
    description = "Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes";
    homepage = "https://github.com/hrkfdn/ncspot";
    license = licenses.bsd2;
    maintainers = [ maintainers.marsam ];
  };
}
