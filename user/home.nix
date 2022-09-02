# See home-configuration.nix(5) for more information.
# vim:fdm=marker

{ config, pkgs, ... }@args:

# imports {{{

let
  secrets = import ../secrets.nix;
  nvim = import ./config/nvim/init.nix args;
  fzf = import ./config/fzf/fzf.nix args;
  foot = import ./config/foot/foot.nix args;
  chromium = import ./config/browser/chromium.nix args;
  sn = import ./derivations/sn.nix;
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

  home-manager.users."${secrets.username}" = {
    home.username = secrets.username;
    home.homeDirectory = "/home/${secrets.username}";

    # packages {{{

    home.packages = with pkgs; [
      # functional
      ripgrep
      less
      htop
      neofetch # For asserting dominance
      vifm
      sc-im

      # derivations
      sn

      # ui
      sway
      swaybg
      wl-clipboard xdg_utils # xdg-mime is required for clipboard MIME support (images)
      bat # for fzf previews
      jetbrains-mono
      font-awesome
      waybar
      wofi

      # utils
      wev
      wlr-randr

      # multimedia
      grim slurp
      (writeScriptBin "scene" (lib.strings.fileContents ./bin/scene))
      imv
      pamixer pavucontrol
      mpv yt-dlp
      newsboat
      ncspot
      zathura mupdf
      amfora # gemini browser
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
      BROWSER = "firejail chromium";
    };
    home.file.".config/aliasrc" = {
      source = ./config/aliasrc;
      executable = true;
    };
    programs.fzf = fzf;

    # editor
    programs.neovim = nvim;
    home.file.".config/nvim/syntax/nix.vim".source = ./config/nvim/syntax/nix.vim;
    home.file.".config/nvim/syntax/gemini.vim".source = ./config/nvim/syntax/gemini.vim;

    programs.git = {
      enable = true;
      extraConfig = {
        init.defaultBranch = "main";
        user = {
          name = secrets.username;
          email = secrets.email;
        };
      };
    };

    # symlinking the directory otherwise vifm can't find the colorschemes
    home.file.".config/vifm".source = ./config/vifm;

    home.file.".config/sc-im/scimrc".source = ./config/sc-im/scimrc;

    # }}}

    # window manager essentials {{{

    home.file.".config/sway/config".source = ./config/sway/config;

    programs.foot = foot;

    programs.chromium = chromium;

    home.file.".config/waybar/config".source = ./config/waybar/config;
    home.file.".config/waybar/style.css".source = ./config/waybar/style.css;

    home.file.".config/wofi/config".source = ./config/wofi/config;
    home.file.".config/wofi/style.css".source = ./config/wofi/style.css;

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
