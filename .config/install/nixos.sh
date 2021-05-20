#!/bin/sh

BASE_URL="https://raw.githubusercontent.com/bossley9/dotfiles/master"

detemplate_url="${BASE_URL}/.local/bin/det"
template_url="${BASE_URL}/.config/etc/nixos/template.configuration.nix"

detemplate_script="${HOME}/detemplate.sh"
template_script="${HOME}/template.configuration.nix"

curl "$detemplate_url" -o "$detemplate_script"
curl "$template_url" -o "$template_script"

HOSTID="$(head -c "/etc/machine-id")" \
LOCALE="en_US.UTF-8" \
  sh "$detemplate_script" "$template_script"

rm "$detemplate_script"
rm "$template_script"
