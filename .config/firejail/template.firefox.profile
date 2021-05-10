# vim: set ft=sh :

include ${FIREJAIL_PROFILE_DIR}/default.inc
include firefox.local

whitelist ${HOME}/Downloads

whitelist ${HOME}/.mozilla
whitelist ${XDG_CONFIG_HOME}/mozilla
whitelist ${XDG_CACHE_HOME}/mozilla

whitelist ${XDG_CONFIG_HOME}/pulse

whitelist ${XDG_CONFIG_HOME}/Xdefaults
whitelist ${XDG_CONFIG_HOME}/gtk-2.0
whitelist ${XDG_CONFIG_HOME}/gtk-3.0

whitelist /usr/share/firefox
whitelist /usr/share/mozilla

include disable-exec.inc
