# See home-configuration.nix(5) for more information.
# vim:fdm=marker

{ config, pkgs, ... }@args:

# imports {{{

let
  secrets = import ../secrets.nix;
  nvim = import ./config/nvim/init.nix args;
  foot = import ./config/foot/foot.nix args;
  firefox = import ./config/browser/firefox.nix args;
  # derivations
  fzf = import ./derivations/fzf.nix;
  sn = import ./derivations/sn.nix;
  webcord = import ./derivations/webcord/default.nix;
  swayaudioidleinhibit = import ./derivations/sway-audio-idle-inhibit.nix;
  customncspot = import ./derivations/ncspot.nix;
  sc-im = import ./config/sc-im/sc-im.nix;

in
  assert secrets.username != "";
  assert secrets.email    != "";

{
  imports = [
    <home-manager/nixos>
  ];

  # }}}

  programs.sway.enable = true;
  programs.firejail.enable = true;
  programs.wshowkeys.enable = true;
  nixpkgs.config.chromium.enableWideVine = true; # for DRM content

  home-manager.users."${secrets.username}" = {
    home.username = secrets.username;
    home.homeDirectory = "/home/${secrets.username}";

    # packages {{{

    home.packages = with pkgs; [
      # functional
      fzf ripgrep
      less
      htop
      neofetch # For asserting dominance
      vifm
      sc-im
      bitwarden-cli
      yubikey-manager

      # ui
      sway
      wl-clipboard xdg-utils # xdg-utils is required for clipboard XDG MIME support (images)
      bat # for fzf previews
      jetbrains-mono
      font-awesome
      waybar
      wofi
      swayaudioidleinhibit
      gnome.adwaita-icon-theme # required for cursors in Firefox
      brightnessctl

      # utils
      unzip
      wev
      wlr-randr
      dig
      wally-cli

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
      # fun
      nethack

      # multimedia
      grim slurp
      (writeScriptBin "scene" (lib.strings.fileContents ./bin/scene))
      imv
      pamixer pavucontrol
      mpv yt-dlp
      newsboat
      sn
      customncspot cava
      zathura mupdf
      amfora
      webcord

      # editing
      inkscape
      gimp # requires xwayland

      # streaming
      (writeShellScriptBin "stream" "nix-shell $DOTDIR/user/shells/streamidle.nix --run obs")
      (writeShellScriptBin "zoom" "NIXPKGS_ALLOW_UNFREE=1 nix-shell --impure $DOTDIR/user/shells/zoom.nix --run \"firejail zoom\"") # requires xwayland
      (writeShellScriptBin "minecraft" "nix-shell $DOTDIR/user/shells/minecraft.nix --run prismlauncher") # requires xwayland
      (writeShellScriptBin "vedit" "nix-shell $DOTDIR/user/shells/videoediting.nix --run kdenlive")
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
      VISUAL="nvim";
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

    programs.git = {
      enable = true;
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
        user = {
          name = secrets.username;
          email = secrets.email;
        };
      };
    };

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

    home.file.".config/mpv".source = ./config/mpv;
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
