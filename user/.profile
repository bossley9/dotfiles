#!/bin/sh
# vim:fdm=marker

umask 0077

# xdg specification {{{

export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
XDG_PREFIX="${HOME}/.local"
export XDG_DATA_HOME="${XDG_PREFIX}/share"
export XDG_REPO_HOME="${HOME}/Repos"

# }}}

# path {{{

addToPATH() {
  if ! echo "$PATH" | grep -q "$1"; then
    export PATH="${1}:${PATH}"
  fi
}

addToPATH "${HOME}/.cargo/bin"

# }}}

# application variables {{{

export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/rg/rgrc"
export BAT_CONFIG_PATH="${XDG_CONFIG_HOME}/bat/config"

# }}}

# final initialization {{{

export DOTDIR="${HOME}/.dots"
export NIXOS_SYSTEM_CONFIGURATION="${DOTDIR}/system/configuration.nix"
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" # allow home-manager to manage shell

# }}}

# window manager {{{

if [ -n "$DISPLAY" ] || [ "$(tty)" != "/dev/tty1" ]; then return; fi

pgrep -x sway > "/dev/null" || \
  exec sway > "/dev/null" 2>&1

# }}}
