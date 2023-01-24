# See home-configuration.nix(5) for more information.
# vim:fdm=marker

{ home-manager, ... }:
{ config, pkgs, ... }@args:

# imports {{{

let
  username = "sam";
  email = "bossley.samuel@gmail.com";
  foot = import ./config/foot/foot.nix args;
  firefox = import ./config/browser/firefox.nix args;
  # packages
  sn = pkgs.callPackage ./packages/sn.nix { };
  webcord = pkgs.callPackage ./packages/webcord.nix { };
  swayaudioidleinhibit = pkgs.callPackage ./packages/sway-audio-idle-inhibit.nix { };
  customncspot = pkgs.callPackage ./packages/ncspot.nix { };
  sc-im = pkgs.sc-im.overrideAttrs (finalAttrs: previousAttrs: {
    postInstall = builtins.concatStringsSep "\n" [
      previousAttrs.postInstall
      "cp -v ${./config/sc-im/scopen} $out/bin/scopen"
    ];
  });

in
{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  # }}}

  programs.sway.enable = true;
  xdg.portal.wlr.enable = true; # wlroots screen sharing
  programs.firejail.enable = true;
  programs.wshowkeys.enable = true;
  nixpkgs.config.chromium.enableWideVine = true; # for DRM content
  programs.adb.enable = true;

  home-manager.users."${username}" = {
    home.username = username;
    home.homeDirectory = "/home/${username}";

    # packages {{{

    home.packages = with pkgs; [
      # functional
      fzf
      ripgrep
      less
      htop
      neofetch # For asserting dominance
      vifm
      sc-im
      bitwarden-cli
      yubikey-manager

      # ui
      sway
      wl-clipboard
      xdg-utils # xdg-utils is required for clipboard XDG MIME support (images)
      bat # for fzf previews
      jetbrains-mono
      open-sans # spotify playlist covers and typefaces
      font-awesome
      waybar
      wofi
      swayaudioidleinhibit
      gnome.adwaita-icon-theme # required for cursors in Firefox
      brightnessctl
      (pkgs.callPackage ./packages/wlay.nix { })

      # utils
      wev
      wlr-randr
      dig
      wally-cli
      pdftk
      terminal-typeracer
      tesseract5
      # formatters
      nixpkgs-fmt
      rustfmt
      # archiving utils
      unzip # *.zip
      zip
      p7zip
      libarchive # bsdtar - *.tar*
      unar # *.rar

      # documents
      texlive.combined.scheme-full
      # web
      gnumake
      hugo
      rsync
      aspell
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.en-science
      # projects
      go
      deno
      nodejs
      python3 # webservers with python3 -m http.server
      cargo
      gcc # required for rust toolchain
      rustc
      # fun
      nethack

      # multimedia
      grim
      slurp
      (writeScriptBin "scene" (lib.strings.fileContents ./bin/scene))
      (writeScriptBin "swallow" (lib.strings.fileContents ./bin/swallow))
      imv
      pamixer
      pavucontrol
      mpv
      yt-dlp
      newsboat
      sn
      customncspot
      cava
      zathura
      mupdf
      amfora
      webcord
      (writeShellScriptBin "chromium" "nix-shell -p chromium --run \"chromium --incognito\"")
      transmission-gtk
      gscan2pdf

      # editing
      tenacity
      inkscape
      gimp # requires xwayland

      # streaming
      (writeShellScriptBin "stream" "nix-shell $DOTDIR/user/shells/streamidle.nix --run obs")
      (writeShellScriptBin "zoom" "NIXPKGS_ALLOW_UNFREE=1 nix-shell --impure $DOTDIR/user/shells/zoom.nix --run \"firejail zoom\"") # requires xwayland
      (writeShellScriptBin "minecraft" "nix shell nixpkgs#jdk17_headless nixpkgs#prismlauncher -c prismlauncher") # requires xwayland
      (writeShellScriptBin "vedit" "nix-shell $DOTDIR/user/shells/videoediting.nix --run kdenlive")

      # wine support
      # wineWowPackages.stable
      # winetricks
    ];

    # required for fontconfig to find home fonts
    fonts.fontconfig.enable = true;

    # }}}

    # workflow {{{

    # shell initialization
    home.file.".profile" = {
      source = ./.profile;
      executable = true;
    };
    home.file.".config/sh/shrc" = {
      source = ./config/sh/shrc;
      executable = true;
    };
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      ENV = "$XDG_CONFIG_HOME/sh/shrc";
      PAGER = "less";
      MANPAGER = "nvim -u NORC +Man!";
      BROWSER = "firejail firefox";
    };
    home.file.".config/aliasrc" = {
      source = ./config/aliasrc;
      executable = true;
    };
    home.file.".config/rg/rgrc".source = ./config/rg/rgrc;
    home.file.".config/bat/config".source = ./config/bat/config;

    # editor
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;
    };
    home.file.".config/nvim".source = ./config/nvim;

    home.file.".config/git/config".source = ./config/git/config;

    # symlinking the directory otherwise vifm can't find the colorschemes
    home.file.".config/vifm".source = ./config/vifm;

    home.file.".config/sc-im/scimrc".source = ./config/sc-im/scimrc;

    home.file.".w3m/config".text = ''
      extbrowser sh -c 'printf %s "$0" | wl-copy'
    '';

    # }}}

    # window manager essentials {{{

    home.file.".config/sway/config".source = ./config/sway/config;

    programs.foot = foot;

    programs.firefox = firefox;

    home.file.".config/waybar/config".source = ./config/waybar/config;
    home.file.".config/waybar/style.css".source = ./config/waybar/style.css;

    home.file.".config/wofi/config".source = ./config/wofi/config;
    home.file.".config/wofi/style.css".source = ./config/wofi/style.css;

    home.file.".config/swaylock/config".source = ./config/swaylock/config;

    # }}}

    # theming {{{
    gtk = {
      enable = true;
      theme = {
        package = pkgs.nordic;
        name = "Nordic";
      };
    };
    # }}}

    # multimedia {{{

    home.file.".config/imv/config".source = ./config/imv/config;

    home.file.".config/ncspot/config.toml".source = ./config/ncspot/config.toml;

    # do not symlink entire mpv directory for watch_later feature to work properly
    home.file.".config/mpv/scripts".source = ./config/mpv/scripts;
    home.file.".config/mpv/input.conf".source = ./config/mpv/input.conf;
    home.file.".config/mpv/mpv.conf".source = ./config/mpv/mpv.conf;
    home.file.".config/yt-dlp/config".source = ./config/yt-dlp/config;

    home.file.".config/newsboat".source = ./config/newsboat;

    home.file.".config/zathura/zathurarc".source = ./config/zathura/zathurarc;

    home.file.".config/amfora/config.toml".source = ./config/amfora/config.toml;
    home.file.".config/amfora/newtab.gmi".source = ./config/amfora/newtab.gmi;

    # }}}

    # security {{{

    home.file.".config/firejail".source = ./config/firejail;

    # }}}

    home.stateVersion = "22.05";
    programs.home-manager.enable = true;
  };
}
