# adapted from https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/misc/hugo/default.nix
with (import <nixpkgs> {});

buildGoModule rec {
  pname = "hugo";
  version = "0.102.3";

  src = fetchFromGitHub {
    owner = "bossley9";
    repo = pname;
    rev = "321216116ccda4e4274fc27db5d40ca59e331ea9";
    sha256 = "15h30y6q9njcvspgaalg6jgdi0jjqbjw91rrq9fh7nkydrbls5wi";
  };

  vendorSha256 = "sha256-5yYsELOYhZPcLyot5uJV26Uhh1zrtTCjOffL/L7BS7A=";

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
