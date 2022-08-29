#!/bin/sh
# vim:fdm=marker

umask 0077

# xdg specification {{{

export XDG_CONFIG_HOME="${HOME}/.config"
XDG_PREFIX="${HOME}/.local"
export XDG_DATA_HOME="${XDG_PREFIX}/share"
export XDG_REPO_HOME="${HOME}/Repos"

# }}}

# application variables {{{

export WOBSOCK="/tmp/wobpipe"

# }}}

# final initialization {{{

export DOTDIR="${HOME}/.dots"
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" # allow home-manager to manage shell

# }}}

# window manager {{{

if [ -n "$DISPLAY" ] || [ "$(tty)" != "/dev/tty1" ]; then return; fi

exec Hyprland > "/dev/null" 2>&1

# }}}
