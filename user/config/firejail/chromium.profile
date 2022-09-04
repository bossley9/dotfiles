# vim:ft=sh
# NOTE BEFORE MODIFYING THIS FILE:
# be sure that the changes still allow DRM playback (spotify, netflix, youtube...)

include chromium.local
include globals.local

caps.drop all # remove all root privileges
disable-mnt # remove access to mounted media
machine-id # spoof id in /etc/machine-id
# net none # remove internet access
nodvd # remove access to dvd and cd devices
nogroups # disable supplemental user groups
# noinput # remove access to input devices such as mics
# novideo # remove access to video devices such as camera
nonewprivs # remove child process access to new privileges via execve()
noprinters # remove access to printers
noroot # disable root namespace (only one user)
# nosound # disable sound
notv # remove access to tv devices
nou2f # remove access to u2f devices
noexec /tmp # remount /tmp as noexec,nodev,nosuid
shell none # run directly without a shell

include default.inc
