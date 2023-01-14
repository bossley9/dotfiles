# adapted from https://github.com/NixOS/nixpkgs/blob/994fa61c56c3be575eaa0680c93e829d231f8a85/pkgs/applications/audio/ncspot/default.nix
# for share_clipboard capability
{ dbus, fetchFromGitHub, lib, libpulseaudio, ncurses, openssl, pkg-config, python3, rustPlatform, xorg, ... }:

rustPlatform.buildRustPackage rec {
  pname = "ncspot";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "hrkfdn";
    repo = "ncspot";
    rev = "v${version}";
    sha256 = "sha256-mtveGRwadcct9R8CxLWCvT9FamK2PnicpeSvL4iT4oE=";
  };

  cargoSha256 = "sha256-JqHJY91q2vm0x819zUkBBAObpnXN5aPde8m5UJ2NeNY=";

  nativeBuildInputs = [ pkg-config python3 ];

  buildInputs = [ ncurses openssl libpulseaudio dbus xorg.libxcb ];

  buildFeatures = [ "cursive/pancurses-backend" "pulseaudio_backend" "mpris" "share_clipboard" ];

  meta = with lib; {
    description = "Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes";
    homepage = "https://github.com/hrkfdn/ncspot";
    license = licenses.bsd2;
    maintainers = [ maintainers.marsam ];
  };
}
