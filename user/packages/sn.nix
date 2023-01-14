{ buildGoModule, fetchFromSourcehut, lib, ... }:

buildGoModule rec {
  pname = "sn";
  version = "1.15.0";

  src = fetchFromSourcehut {
    owner = "~bossley9";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "1xjrbmb2rklxxwibk26qs01f1rk4llxy4iddj4r6i8azy55qyr7h";
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
