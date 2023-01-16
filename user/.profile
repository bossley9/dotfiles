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

# environment variables {{{

export MOZ_DBUS_REMOTE=1
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM="wayland"
export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"

# }}}

# application variables {{{

export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/rg/rgrc"
export BAT_CONFIG_PATH="${XDG_CONFIG_HOME}/bat/config"
export FZF_DEFAULT_OPTS="\
--bind \"alt-k:up,\
alt-j:down,\
alt-u:half-page-up,\
alt-d:half-page-down,\
alt-h:backward-delete-char,\
alt-q:abort,\
alt-l:accept\" \
--color \"bg+:-1,\
pointer:#81A1C1,\
hl:#81A1C1,\
hl+:#B48EAD,\
info:#A3BE8C\" \
--ansi"
export FZF_DEFAULT_COMMAND="rg --files"
export GPG_TTY=$(tty)

# }}}

# final initialization {{{

export DOTDIR="/etc/nixos"
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" # allow home-manager to manage shell

# }}}

# window manager {{{

if [ -n "$DISPLAY" ] || [ "$(tty)" != "/dev/tty1" ]; then return; fi

pgrep -x sway > "/dev/null" || \
  exec sway > "/dev/null" 2>&1

# }}}
