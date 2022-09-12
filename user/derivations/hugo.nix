# adapted from https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/misc/hugo/default.nix
with (import <nixpkgs> {});

buildGoModule rec {
  pname = "hugo";
  version = "0.102.3";

  src = fetchFromGitHub {
    owner = "bossley9";
    repo = pname;
    rev = "167eaeaba0b4496ab5128780b0600926a21d900c";
    sha256 = "1zw3pv4as3y4dhcw6kb9gww65rjpnnisd3m25hp5ljbkhixnb2yg";
  };

  vendorSha256 = "sha256-K2dSZoFdX/evubIBIvXV+yQle3h0ubuTrQ+Z3vttmmo=";

  doCheck = false;

  proxyVendor = true;

  tags = [ "extended" ];

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" "-X github.com/bossley9/hugo/common/hugo.vendorInfo=nixpkgs" ];

  postInstall = ''
    $out/bin/hugo gen man
    installManPage man/*
    installShellCompletion --cmd hugo \
      --bash <($out/bin/hugo completion bash) \
      --fish <($out/bin/hugo completion fish) \
      --zsh <($out/bin/hugo completion zsh)
  '';

  meta = with lib; {
    description = "Hugo with a custom Gemtext patch";
    homepage = "https://github.com/bossley9/hugo";
    maintainers = with maintainers; [ bossley9 ];
  };
}
