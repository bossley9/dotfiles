#!/usr/bin/env sh

#
# setup
#

PKGS=""
BREW=""
CASK=""

# install nix
# sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume
# . "/Users/${USER}/.nix-profile/etc/profile.d/nix.sh"
sh <(curl -L https://nixos.org/nix/install) --daemon

# install brew
sh -c "$(curl -fsSL "https://raw.githubusercontent.com/Homebrew/install/master/install.sh")"
git restore "$GIT_CONFIG" # fix brew install errors

#
# core
#

PKGS="${PKGS} envsubst"

PKGS="${PKGS} neovim ripgrep nodejs nodePackages.npm fzf"
BREW="${BREW} vifm"
PKGS="${PKGS} scim"

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

# PKGS="${PKGS} kitty"
CASK="${CASK} iterm2"
# PACKS="${PACKS} figma"
# PACKS="${PACKS} firefox"

#
# installation
#

NIXPKGS=""
for PKG in $PKGS; do
  NIXPKGS="${NIXPKGS} nixpkgs.${PKG}"
done
nix-env -iA $NIXPKGS

brew install $BREW

brew install --cask $CASK

# shenv
ln -sf "$ENV" "${HOME}/.zshrc"

echo "${YELLOW}WARNING: You will need to manually set keyboard mappings for this to work as intended. This can be done from the menu > System Preferences > Keyboard > Modifier Keys.${NC}"
echo "${YELLOW}I usually map the following:\n\
  Function (fn) Key: Control
${NC}"
