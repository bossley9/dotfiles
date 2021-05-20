#!/bin/sh

BASE_URL="https://raw.githubusercontent.com/bossley9/dotfiles/master"

template_url="${BASE_URL}/.config/etc/nixos/template.configuration.nix"
detemplate_url="${BASE_URL}/.local/bin/det"

echo $detemplate_url
