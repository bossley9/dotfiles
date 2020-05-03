#!/bin/sh

#
# environment settings
#

# redshift
$XDG_SCRIPT_HOME/tui/redshift "$(cat $REDSHIFT_LAST)"

#
# core programs 
#

# shortcut manager
sxhkd &

# compositor
picom --experimental-backends &

# status bar
$BAR_ARGS &

# window manager
exec bspwm

