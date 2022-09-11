with (import <nixpkgs> {});

buildGoModule rec {
  pname = "sn";
  version = "1.2.0";

  src = fetchFromSourcehut {
    owner = "~bossley9";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "10ikbdgx81rkb65rijjcx8b9js2b6j1brhvqd9m7cdjsvr5bwvgq";
  };
  tags = [ "isproduction" ];

  vendorSha256 = "sha256-/roVpjcqsUXR2bA1cTQ2tkBMl8MEczKM+HZbA6Mi6VU=";

  meta = with lib; {
    description = "A Simplenote static-syncning CLI client written in Go";
    homepage = "https://git.sr.ht/~bossley9/sn";
    maintainers = with maintainers; [ bossley9 ];
    license = licenses.bsd2;
  };

  # adapted from https://github.com/NixOS/nixpkgs/blob/00a89d15ab5a0c14c20c3e8784a413ab37d8bd9f/pkgs/build-support/go/module.nix#L288
  installPhase = ''
    mkdir -p $out/bin
    exe="$GOPATH/bin/cmd"
    [ -f "$exe" ] && cp $exe $out/bin/sn
  '';
}
