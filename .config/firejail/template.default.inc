# vim: set ft=sh :

include globals.local

# include whitelist-common.inc
# include whitelist-player-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

include disable-common.inc
include disable-devel.inc
# include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
# include disable-programs.inc
# include disable-shell.inc
include disable-write-mnt.inc
include disable-xdg.inc

# NOTHING should be able to access this
blacklist /boot
blacklist /efi
blacklist /root

# manual blacklist of data folders
blacklist ${HOME}/Data
blacklist ${HOME}/Music
blacklist ${HOME}/Repos
