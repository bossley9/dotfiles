# vim:ft=sh:fdm=marker

# options {{{
# x11 none
# }}}

# block/allow lists {{{
# whitelist adds access to directories or files
# nowhitelist disables whitelist rules
# blacklist removes access to directories or files
# noblacklist disables blacklist rules

# order of operations:
# 1. nowhitelist
# 2. whitelist
# 3. noblacklist
# 4. blacklist

# can't whitelist Downloads because it messes up things like DRM
# whitelist ${HOME}/Downloads

# system critical
blacklist /boot
blacklist /efi
blacklist /root
blacklist /drive

# executable
blacklist /sbin
blacklist /usr/sbin

blacklist ${HOME}/.ssh

blacklist ${HOME}/Data
blacklist ${HOME}/Documents
blacklist ${HOME}/Media
blacklist ${HOME}/Mount
blacklist ${HOME}/Music
blacklist ${HOME}/Pictures
blacklist ${HOME}/Public
blacklist ${HOME}/Repos
blacklist ${HOME}/Videos
# }}}
