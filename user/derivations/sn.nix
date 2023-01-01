with (import <nixpkgs> {});

buildGoModule rec {
  pname = "sn";
  version = "1.14.0";

  src = fetchFromSourcehut {
    owner = "~bossley9";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "0vqj99fy9lv5w3hfsdqqbjwpf7lg8g4as5ckdqyr3ip89rgdxqh9";
  };
  tags = [ "production" ];

  vendorSha256 = "sha256-rg6C4g1yRta5MeUPgPjLyEKV+xRZJTxO9WaJXanX2Bw=";

  meta = with lib; {
    description = "A Simplenote syncing CLI client written in Go";
    homepage = "https://git.sr.ht/~bossley9/sn";
    maintainers = with maintainers; [ bossley9 ];
    license = licenses.bsd2;
  };

  installPhase = ''
    mkdir -p $out/bin
    exe="$GOPATH/bin/sn"
    [ -f "$exe" ] && cp $exe $out/bin/sn
  '';
}
