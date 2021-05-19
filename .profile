#!/bin/sh
# core environmental variables set on login

# operating systems

export OS="$(uname)"
export OS_MACOS="Darwin"
export OS_LINUX="Linux"
export OS_FREEBSD="FreeBSD"
export OS_OPENBSD="OpenBSD"

# distros (kernel-based)

export DISTRO_ARCHLINUX="Archlinux"
export DISTRO_GENTOO="Gentoo"
export DISTRO_NIXOS="NixOS"

if [ "$OS" = "$OS_LINUX" ]; then
  distro="$(cat /etc/*-release | grep "^NAME=" | cut -d "=" -f 2)"
  case "$distro" in
    *Arch*)     export DISTRO="$DISTRO_ARCHLINUX" ;;
    *gentoo*)   export DISTRO="$DISTRO_GENTOO" ;;
    *NixOS*)    export DISTRO="$DISTRO_NIXOS" ;;
    *)          export DISTRO="" ;;
  esac
fi

#
# directories
#

# config directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_DIR="$XDG_CONFIG_HOME"
# cache directory
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CACHE_DIR="$XDG_CACHE_HOME"
# script directory
export XDG_SCRIPT_HOME="$HOME/.local/bin"
# data directory
export XDG_DATA_HOME="$HOME/.local/share"
# repo directory
export XDG_REPO_HOME="$HOME/Repos"
# desktop directory
export XDG_DESKTOP_DIR="${XDG_CACHE_HOME}/Desktop"

# local font directory
export FONT_DIR="${XDG_DATA_HOME}/fonts"
# null
export NULL="/dev/null"
# opt directory
export OPT_DIR="/opt"
# ports directory
export PORTS_DIR="/usr/ports"
# tmp directory
export TMPDIR="/tmp"
export TMP_DIR="$TMPDIR" # TODO deprecate

export PREFIX="/usr/local"
export BIN="${PREFIX}/bin"

#
# display
#

export RICE_HIGH="desktop"
export RICE_LOW="minimal"

# rice LOD
export RICE="$RICE_LOW"
export RICE_LOD_FILE="${XDG_CONFIG_HOME}/rice"

case "$(cat "$RICE_LOD_FILE" 2> "$NULL")" in
  "$RICE_HIGH") export RICE="$RICE_HIGH";
esac

export RES_WIDTH="1920"
export RES_HEIGHT="1080"

export THEME_LIGHT="light"
export THEME_DARK="dark"

if [ -z "${CURRENT_THEME_MODE}" ]; then
  export CURRENT_THEME_MODE="${THEME_DARK}"
fi

export THEME="Adapta-Nokto"
export THEME_FONT="Roboto Regular 12"
export GTK_THEME_DIR="/usr/share/themes"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

#
# default programs
#

# editor
export EDITOR="nvim"
export VISUAL="${EDITOR}"

# terminal
case "$OS" in
  "$OS_LINUX"|"$OS_FREEBSD"|"$OS_OPENBSD")
    export TERM="st"
    export TERM_ARGS="$TERM"
    ;;
  *) export TERM_ARGS="$TERM" ;;
esac
export TERMINAL="$TERM"

# browser
export BROWSER="browser"
export BROWSER_INCOGNITO="browser incognito"

# file explorer
export FILE_EXPLORER="vifm"
export FILE_EXPLORER_ARGS="${FILE_EXPLORER}"

# document viewer
export PDF_VIEWER="zathura"

# system profiler
export SYSTEM_PROFILER="htop"

# notifications
export NOTIFICATION_MANAGER="herbe"

# panel/bar
case "$OS" in
  "$OS_LINUX"|"$OS_FREEBSD"|"$OS_OPENBSD")
    # updated further in apprc file
    export BAR="polybar"
    export BAR_ARGS="${BAR} -r main"
    export BAR_UPDATE=""
    ;;
  *)
    export BAR=""
    export BAR_ARGS="$BAR"
    export BAR_UPDATE=""
    ;;
esac

# compositor
case "$OS" in
  "$OS_LINUX"|"$OS_FREEBSD"|"$OS_OPENBSD")
    export COMPOSITOR="picom"
    export COMPOSITOR_ARGS="${COMPOSITOR}"
    ;;
  *)
    export COMPOSITOR=""
    export COMPOSITOR_ARGS="${COMPOSITOR}"
    ;;
esac

# music player
export MUSIC_PLAYER=""
export MUSIC_PLAYER_ARGS="${MUSIC_PLAYER}"
if command -v "spotify" > "$NULL"; then
  export MUSIC_PLAYER="spotify"
  export MUSIC_PLAYER_ARGS="${MUSIC_PLAYER}"
fi
case "$OS" in
  "$OS_FREEBSD") export MUSIC_PLAYER_DAEMON="musicpd" ;;
  *) export MUSIC_PLAYER_DAEMON="mpd" ;;
esac

# pager
export PAGER="less"
export MANPAGER="nvim +Man!"

# window manager
export WM="bspwm"

#
# variables
#

case "$OS" in
  "$OS_FREEBSD")
    export AUDIO_ARCH="oss"
    export AUDIO_OUTPUT="${AUDIO_ARCH}"
    ;;
  "$OS_OPENBSD")
    export AUDIO_ARCH="sndio"
    export AUDIO_OUTPUT="${AUDIO_ARCH}"
    ;;
  "$OS_LINUX")
    export AUDIO_ARCH="alsa"
    if command -v "pulseaudio" > "$NULL"; then
      export AUDIO_OUTPUT="pulse"
    else
      export AUDIO_OUTPUT="alsa"
    fi
    ;;
esac
export DOLLAR="$" # vital for envsubst escaping
export FF_PROFILE="default"
# for use in mktemp templates
export MK_TEMP="XXXXXXXXXXXXXX"
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export MYVIMRC="${XDG_CONFIG_HOME}/nvim/init.vim"
export NETHACK_VER="3.6.2"
export NODE_REPL_HISTORY="${XDG_CACHE_HOME}/node_repl_history"
export PROMPT_EOL_MARK="" # prevent partial line % from appearing
export PF_COL1="1"
export PF_INFO="ascii title os host kernel pkgs shell editor wm de uptime memory palette"
if [ "$OS" = "$OS_OPENBSD" ]; then
  export PKG_PATH="http://ftp.openbsd.org/pub/OpenBSD/$(uname -r)/packages/$(arch -s)/"
fi
export PULSE_VIRT_MIC="pulse-virtual-mic"
export REDSHIFT_LAST="$XDG_CACHE_HOME/redshift_last"
case "$OS" in
  "$OS_LINUX")
    export SHELL_NAME="mksh"
    export SHELL="/bin/${SHELL_NAME}"
    ;;
  "$OS_FREEBSD")
    export SHELL_NAME="mksh"
    export SHELL="/usr/local/bin/${SHELL_NAME}"
    ;;
  "$OS_OPENBSD")
    export SHELL_NAME="sh"
    export SHELL="/bin/${SHELL_NAME}"
    ;;
  *)
    export SHELL_NAME="sh"
    export SHELL="/bin/${SHELL_NAME}"
    ;;
esac
export UID="$(id -u)"
export VI_NAV_JUMP="5"
export VI_NAV_JUMP_LARGE="25"
export VIMINIT='source $MYVIMRC'
export XRDB_RESOURCES="${XDG_CONFIG_HOME}/Xdefaults/Xresources"
export XRDB_UPDATE="xrdb -merge ${XRDB_RESOURCES}"

#
# cache and config directories
#

export ABOOK_CONFIG="$XDG_CONFIG_HOME/abook/abookrc"
export BOOKMARK_CONFIG="$XDG_DATA_HOME/sh/bookmarks"
export CARGO_HOME="${XDG_CACHE_HOME}/cargo"
export ENV="$XDG_CONFIG_HOME/sh/shrc"
case "$OS" in
  "$OS_OPENBSD") export FF_CACHE_DIR="${TMPDIR}/firefox_cache.${UID}" ;;
  "$OS_LINUX") export FF_CACHE_DIR="/run/user/${UID}/firefox" ;;
esac
export FIREJAIL_PROFILE_DIR="${XDG_CONFIG_HOME}/firejail"
export GIT_CONFIG="$XDG_CONFIG_HOME/git/config"
export GIT_TEMPLATE_DIR="$XDG_CONFIG_HOME/git/template"
export GNUPGHOME="${XDG_CONFIG_HOME}/gnupg"
export LESSHISTFILE="$XDG_CACHE_HOME/less_history"
export LESSKEY="$XDG_CACHE_HOME/lesskey_generated"
export MOZ_LOG_FILE="${XDG_CACHE_HOME}/mozilla/mozilla.log"
export NEWSBOAT_CONFIG="$XDG_CONFIG_HOME/newsboat"
export NETHACKOPTIONS="@${XDG_CONFIG_HOME}/nethack/nethackrc"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export RUSTUP_HOME="${XDG_CONFIG_HOME}/rustup"
export SH_HISTFILE="$XDG_CACHE_HOME/sh_history"
export YARN_CACHE_FOLDER="$XDG_CACHE_HOME/yarn"
export YARN_GLOBAL_DIR="$XDG_CACHE_HOME/yarn_global"
export YARN_RC_DIR="$XDG_CACHE_HOME"
export YARN_RC_FILENAME="$XDG_CONFIG_HOME/yarn/.yarnrc.yml"
export XAUTHORITY="${XDG_CONFIG_HOME}/Xdefaults/Xauthority"
export XMR_CONFIG="${XDG_CONFIG_HOME}/xmr"
export XMR_PATH="${XDG_SCRIPT_HOME}/xmr.d"

#
# path
#

# export LD_PRELOAD="/usr/lib/libhardened_malloc.so"
export MANPATH="/usr/share/man:/usr/local/share/man:${MANPATH}"
export PATH="${XDG_SCRIPT_HOME}:${PATH}"
# java
export PATH="${PATH}:/usr/local/jdk-11/bin"
# rust
export PATH="${PATH}:${CARGO_HOME}/bin"

#
# includes
#

# colors
. "${XDG_CONFIG_HOME}/colorrc"

# app-specific environment variables
. "${XDG_CONFIG_HOME}/apprc"

#
# misc app variables (ordered after main app declarations)
#

# fzf
export FZF_DEFAULT_OPTS="--bind $FZF_BINDINGS --color=\"$FZF_COLORS\""

# spicetify
if command -v "spicetify" > "$NULL"; then
  export MUSIC_PLAYER="spotify"
  export MUSIC_PLAYER_ARGS="spicetifystart"
fi

# background command
export BACKGROUND="feh --no-fehbg --bg-fill ${XDG_DATA_HOME}/wallpapers/nixos.png"

# init
. "${XDG_CONFIG_HOME}/initrc"
