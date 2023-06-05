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
  swayaudioidleinhibit = pkgs.callPackage ./packages/sway-audio-idle-inhibit.nix { };
  customncspot = pkgs.callPackage ./packages/ncspot.nix {
    withPulseAudio = true;
    withMPRIS = true;
    withShareClipboard = true;
  };
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

  # Firefox extensions {{{

  programs.firefox = {
    enable = true;
    policies = {
      # https://github.com/mozilla/policy-templates/tree/07be9665c8adab27ae78075cbd1f25a3be91bd3b#extensionsettings
      ExtensionSettings = {
        # ublock origin
        "uBlock0@raymondhill.net" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
        # firefox multi-account containers
        "@testpilot-containers" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
        };
        # bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        };
        # vimium-ff
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
        };
        # metamask
        "webextension@metamask.io" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/file/4037096/ether_metamask-latest.xpi";
        };
        # qwant lite
        "{7965226e-78d5-45c1-a1e9-2c9e6b80fff4}" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/file/3963572/qwant_lite-1.0.8.xpi";
        };
      };
    };
  };

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
      sshfs

      # ui
      sway
      wl-clipboard
      xdg-utils # xdg-utils is required for clipboard XDG MIME support (images)
      bat # for fzf previews
      jetbrains-mono
      open-sans # spotify playlist covers and typefaces
      wqy_zenhei
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
      wally-cli
      pdftk
      terminal-typeracer
      tesseract5
      tty-clock
      terraform
      # formatters
      nixpkgs-fmt
      rustfmt
      luaformatter
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
      rsync
      aspell
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.en-science
      nodejs
      openai-whisper-cpp
      # projects
      go
      deno
      python3 # webservers with python3 -m http.server
      cargo
      gcc # required for rust toolchain
      rustc
      # fun
      nethack

      # multimedia
      grim
      slurp
      (writeScriptBin "caption" (lib.strings.fileContents ./bin/caption))
      (writeScriptBin "scene" (lib.strings.fileContents ./bin/scene))
      (writeScriptBin "swallow" (lib.strings.fileContents ./bin/swallow))
      imv
      ffmpeg
      exiftool # for vifm image previews
      libsixel # for vifm image previews
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
      okular # for editing and digitally signing pdf forms
      amfora
      webcord
      (writeShellScriptBin "chromium" "nix-shell -p chromium --run \"chromium --incognito\"")
      transmission-gtk
      scrcpy

      # editing
      tenacity
      inkscape
      gimp # requires xwayland

      # streaming
      (writeShellScriptBin "stream" "nix-shell $DOTDIR/user/shells/streamidle.nix --run obs")
      (writeShellScriptBin "zoom" "NIXPKGS_ALLOW_UNFREE=1 nix-shell --impure $DOTDIR/user/shells/zoom.nix --run \"firejail zoom\"") # requires xwayland
      (writeShellScriptBin "minecraft" "nix shell nixpkgs#jdk17_headless nixpkgs#prismlauncher -c prismlauncher") # requires xwayland
      (writeShellScriptBin "vedit" "nix-shell $DOTDIR/user/shells/videoediting.nix --run kdenlive")
    ];

    # required for fontconfig to find home fonts
    fonts.fontconfig.enable = true;

    # }}}

    # workflow {{{

    # shell initialization
    home.file.".profile" = {
      source = ./profile;
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
      text = builtins.concatStringsSep "\n" [
        (builtins.readFile ../shared/navigationrc)
        (builtins.readFile ./config/aliasrc)
      ];
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
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = true;
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

    # miscellaneous {{{

    home.file.".config/nethack/nethackrc".source = ./config/nethack/nethackrc;

    # }}}

    home.stateVersion = "22.05";
    programs.home-manager.enable = true;
  };
}
