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
PKGS="${PKGS} mksh"
# rebinding
CASK="${CASK} karabiner-elements"

PKGS="${PKGS} neovim ripgrep nodejs nodePackages.npm fzf"
BREW="${BREW} vifm"
PKGS="${PKGS} scim"

# development
# PKGS="${PKGS} abook"
PKGS="${PKGS} nodePackages.typescript deno yarn"
# TODO symlink python to python3
PKGS="${PKGS} python3"
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

CASK="${CASK} kitty"
# CASK="${CASK} iterm2"
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
# ln -sf "$ENV" "${HOME}/.zshrc"

# set default shell
ln -sf "${NIX_PROFILE}/bin/mksh" "${BIN}/mksh"
grep -q "^${BIN}/mksh" "/etc/shells" || echo "${BIN}/mksh" | sudo tee -a "/etc/shells"
chsh -s "${BIN}/mksh"

echo "${YELLOW}WARNING: You will need to manually give karabiner permissions to monitor keys for the keybindings to work as intended.${NC}"
