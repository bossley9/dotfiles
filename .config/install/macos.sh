#!/usr/bin/env sh

#
# setup
#

PKGS=""
BREW=""
CASK=""

# FF_DIR="${HOME}/Library/Application\ Support"
# mkdir -p "$FF_DIR"

# install nix
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
PKGS="${PKGS} nodePackages.typescript deno yarn"
# TODO symlink python to python3?
PKGS="${PKGS} python3"
# various utils
PKGS="${PKGS} unzip wget"

CASK="${CASK} kitty"
CASK="${CASK} brave-browser"
CASK="${CASK} firefox"
CASK="${CASK} figma"
# screen recording utility
CASK="${CASK} kap"

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

# set default shell
ln -sf "${NIX_PROFILE}/bin/mksh" "${BIN}/mksh"
grep -q "^${BIN}/mksh" "/etc/shells" || echo "${BIN}/mksh" | sudo tee -a "/etc/shells"
chsh -s "${BIN}/mksh"

# firefox profile
# sudo rm -rv "${FF_DIR}/Firefox"
# ln -sf "${XDG_CONFIG_HOME}/mozilla/firefox" "${FF_DIR}/Firefox"

echo "${YELLOW}WARNING: You will need to manually grant many of the installed applications extended permissions for the installation to work as intended.${NC}"
