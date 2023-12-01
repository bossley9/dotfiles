{ buildGoModule, fetchFromGitHub, lib, ... }:

buildGoModule rec {
  pname = "sn";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "bossley9";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "070ggn0vva3s5qwj21pljh5zaya9fgfb3qivg5kl6idbk7mspacr";
  };
  tags = [ "production" ];

  vendorHash = "sha256-2SmOOv66IfSR3bYBz8CaCKplUN3qyADbl79Wgd6zfds=";

  meta = with lib; {
    description = "A Simplenote syncing CLI client written in Go";
    homepage = "https://github.com/bossley9/sn";
    maintainers = with maintainers; [ bossley9 ];
    license = licenses.bsd2;
  };

  installPhase = ''
    mkdir -p $out/bin
    exe="$GOPATH/bin/sn"
    [ -f "$exe" ] && cp $exe $out/bin/sn
  '';
}
