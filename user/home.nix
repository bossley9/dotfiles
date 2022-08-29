# See home-configuration.nix(5) for more information.
# vim:fdm=marker

{ config, pkgs, ... }@args:

# imports {{{

let
  secrets = import ../secrets.nix;
  nvim = import ./config/nvim/init.nix args;
  fzf = import ./config/fzf/fzf.nix args;
  foot = import ./config/foot/foot.nix args;
in
  assert secrets.username != "";
  assert secrets.email    != "";

{
  imports = [
    <home-manager/nixos>
    ./extras/hyprland.nix
  ];

  # }}}

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

      # ui
      swaybg
      wl-clipboard
      bat # for fzf previews
      jetbrains-mono
      waybar

      # utils
      wev
      wlr-randr

      # multimedia
      grim slurp
      (writeScriptBin "scene" (lib.strings.fileContents ./bin/scene))
      imv
      wob
      pamixer
      pavucontrol
      mpv
      yt-dlp
      newsboat
    ];

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

    # }}}

    # window manager {{{

    home.file.".config/startw" = {
      source = ./config/startw;
      executable = true;
    };
    home.file.".config/hypr/hyprland.conf".source = ./config/hypr/hyprland.conf;

    programs.foot = foot;

    programs.chromium = {
      enable = true;
      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      ];
    };

    home.file.".config/imv/config".source = ./config/imv/config;

    # }}}

    # status bar {{{

    home.file.".config/waybar/config".source = ./config/waybar/config;
    home.file.".config/waybar/style.css".source = ./config/waybar/style.css;

    # }}}

    home.file.".config/mpv".source = ./config/mpv;
    home.file.".config/yt-dlp/config".source = ./config/yt-dlp/config;

    home.file.".config/newsboat".source = ./config/newsboat;

    home.stateVersion = "22.05";
    programs.home-manager.enable = true;
  };
}
