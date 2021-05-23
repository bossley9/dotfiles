#!/usr/bin/env sh

#
# setup
#

PKGS=""

# install nix
sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume
. "/Users/${USER}/.nix-profile/etc/profile.d/nix.sh"

# install brew
# curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh

#
# core
#

PKGS="${PKGS} envsubst"
PKGS="${PKGS} mksh dash"

PKGS="${PKGS} neovim ripgrep nodejs nodePackages.npm fzf"
# PKGS="${PKGS} vifm"

# development
# PKGS="${PKGS} abook"
PKGS="${PKGS} nodePackages.typescript deno yarn"
PKGS="${PKGS} python3"
# TODO symlink python to python3
# PKGS="${PKGS} rustup"
# PKGS="${PKGS} texlive-most biber"
# rss reader
# PKGS="${PKGS} newsboat"
# ssh
# PKGS="${PKGS} openssh"
# tuning and power management
# PKGS="${PKGS} tlp brightnessctl"
# various utils
# AURS="${AURS} mmv"
PKGS="${PKGS} unzip wget"

# brew install $PACKS

# brew cask

# PACKS=""
# PACKS="${PACKS} iterm2"
# PACKS="${PACKS} figma"
# PACKS="${PACKS} firefox"

# brew cask install $PACKS

NIXPKGS=""
for PKG in $PKGS; do
  NIXPKGS="${NIXPKGS} nixpkgs.${PKG}"
done
nix-env -iA $NIXPKGS

# change shell to mksh
chsh -s mksh
