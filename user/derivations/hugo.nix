# adapted from https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/misc/hugo/default.nix
with (import <nixpkgs> {});

buildGoModule rec {
  pname = "hugo";
  version = "0.102.3";

  src = fetchFromGitHub {
    owner = "bossley9";
    repo = pname;
    rev = "8906bf2da5b202d7250d46a5856a87967dfcd456";
    sha256 = "0n9sdsksg0vbcd5gccy45v6vbqpyd83d2xni293s9190qrwhzp2c";
  };

  vendorSha256 = "PoPsdV6rtohu/Un1jllBn08reMRLz17R6Ku7vB+3jFc=";

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
