#!/bin/sh

. "${0%/*}/user/.profile"

doas nixos-rebuild -I nixos-config=${NIXOS_SYSTEM_CONFIGURATION} switch
