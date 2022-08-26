# See home-configuration.nix(5) for more information.

{ config, pkgs, ... }@args:

let
  secrets = import ../secrets.nix;
  nvim = import ./config/nvim/nvim.nix args;
in
  assert secrets.username != "";
  assert secrets.email    != "";

{
  imports = [
    <home-manager/nixos>
  ];

  programs.sway.enable = true;

  home-manager.users."${secrets.username}" = {
    home.username = secrets.username;
    home.homeDirectory = "/home/${secrets.username}";

    home.packages = with pkgs; [
      # functional
      less
      htop
      neofetch # For asserting dominance
    ];

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
      ENV = "$XDG_CONFIG_HOME/sh/shrc";
      PAGER = "less";
    };
    home.file.".config/aliasrc" = {
      source = ./config/aliasrc;
      executable = true;
    };

    programs.fzf = {
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
      enableZshIntegration = false;
    };

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

    # ui
    home.file.".config/sway/config".source = ./config/sway/config;

    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "monospace:size=10";
          pad = "4x4";
        };
        key-bindings = {
          font-increase = "Control+Shift+k";
          font-decrease = "Control+Shift+j";
          scrollback-up-half-page = "Control+Shift+u";
          scrollback-down-half-page = "Control+Shift+d";
        };
        tweak = {
          font-monospace-warn = "no"; # reduce startup time
          sixel = "yes";
        };
      };
    };

    programs.chromium = {
      enable = true;
      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      ];
    };

    home.stateVersion = "22.05";
    programs.home-manager.enable = true;
  };
}
