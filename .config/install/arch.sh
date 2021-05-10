#!/bin/sh

#
# setup
#

GUI="1"

PKGS=""
AURS=""
# installed after
PKGA=""
AURA=""

ETC="/etc"
SYSD="/${ETC}/systemd"
SYSDSYS="${SYSD}/system"
FF_DIR="${HOME}/.mozilla"

mkdir -p "$BIN"
mkdir -p "$FF_DIR"
mkdir -p "$FONT_DIR"
mkdir -p "$ETC"
mkdir -p "$SYSD"
mkdir -p "$SYSDSYS"
mkdir -p "$TMPDIR"
mkdir -p "$OPT_DIR"

# AUR package management
git clone "https://aur.archlinux.org/paru-bin.git" "${TMPDIR}/paru"
cd "${TMPDIR}/paru" && makepkg -si

#
# core
#

# documentation
PKGS="${PKGS} mandoc"
PKGS="${PKGS} neovim ripgrep nodejs npm fzf"
PKGS="${PKGS} vifm"

# development
PKGS="${PKGS} abook"
# PKGS="${PKGS} clang"
PKGS="${PKGS} typescript"
PKGS="${PKGS} deno"
PKGS="${PKGS} python"
PKGS="${PKGS} rustup"
PKGS="${PKGS} texlive-most biber"
PKGS="${PKGS} yarn"
# rss reader
PKGS="${PKGS} newsboat"
# ssh
PKGS="${PKGS} openssh"
# tuning and power management
PKGS="${PKGS} tlp brightnessctl"
# various utils
PKGS="${PKGS} dash"
AURS="${AURS} doas"
AURS="${AURS} mmv"
PKGS="${PKGS} unzip wget"

# hackin
PKGS="${PKGS} nethack"

if [ "$GUI" = "1" ]; then

PKGS="${PKGS} xorg-server xorg-xinit"
PKGS="${PKGS} xorg-xsetroot"
PKGS="${PKGS} xorg-xinput"
PKGS="${PKGS} xdotool"
PKGS="${PKGS} xorg-xev"
# PKGS="${PKGS} xf86-video-intel"

PKGS="${PKGS} bspwm sxhkd"
AURS="${AURS} polybar"
AURS="${AURS} picom-ibhagwan-git"

PKGA="${PKGA} firefox"
PKGA="${PKGA} firefox-tridactyl"
AURA="${AURA} firefox-tridactyl-native"
AURA="${AURA} firefox-ublock-origin"
AURA="${AURA} firefox-extension-multi-account-containers"

PKGS="${PKGS} firejail"

PKGS="${PKGS} feh"
PKGS="${PKGS} mpv"
PKGS="${PKGS} ffmpeg"
PKGS="${PKGS} screenkey"
PKGS="${PKGS} youtube-dl"
PKGS="${PKGS} xclip"
PKGS="${PKGS} slop"
PKGS="${PKGS} zathura girara zathura-pdf-mupdf"
# PKGS="${PKGS} gimp inkscape"
PKGS="${PKGS} mpd ncmpcpp"
AURS="${AURS} ncspot"
# AURS="${AURS} spotify"
PKGS="${PKGS} alsa-utils"
PKGS="${PKGS} pamixer"
PKGS="${PKGS} pulseaudio pulseaudio-alsa"
PKGS="${PKGS} pavucontrol"
# PKGS="${PKGS} pipewire pipewire-alsa pipewire-pulse pipewire-jack"
# AURS="${AURS} scrcpy"
# PKGS="${PKGS} lmms"
# PKGS="${PKGS} kdenlive"
# AURS="${AURS} obs-studio-git"
# PKGS="${PKGS} linux-headers dkms"
# PKGA="${PKGA} v4l2loopback-dkms"
# PKGS="${PKGS} discord"

# PKGS="${PKGS} hsetroot"
PKGS="${PKGS} redshift"
PKGS="${PKGS} ttf-liberation"
PKGS="${PKGS} adobe-source-code-pro-fonts"
PKGS="${PKGS} wqy-zenhei"
# PKGS="${PKGS} breeze"
PKGS="${PKGS} adapta-gtk-theme"
PKGS="${PKGS} ttf-roboto"

PKGS="${PKGS} pandoc"
PKGS="${PKGS} nm-connection-editor"
PKGS="${PKGS} aria2"
PKGS="${PKGS} qrencode"
# PKGS="${PKGS} lxd"
# PKGS="${PKGS} pwgen"

# Unity development
# if there are still issues finding mono, set the following props
# "omnisharp.useGlobalMono": "always"
# "omnisharp.monoPath": "/usr/bin/mono"
# AURS="${AURS} unityhub"
# sudo chown -R ${USER}:wheel "${OPT_DIR}/unityhub"
# sudo chmod 700 "${OPT_DIR}/unityhub/unityhub-bin"
# PKGS="${PKGS} mono"
# probably don't need this
# AURS="${AURS} mono-basic"
# PKGS="${PKGS} dotnet-runtime dotnet-sdk"

fi

#
# installation
#

# packages cannot be quoted
sudo pacman -S $PKGS

rustup default stable # rust configuration

for AUR in $AURS; do
  git clone "https://aur.archlinux.org/${AUR}.git" "${TMPDIR}/${AUR}"
  cd "${TMPDIR}/${AUR}"
  makepkg -si
done

# enable power management
sudo systemctl enable --now tlp

# spreadsheets
git clone "https://github.com/andmarti1424/sc-im.git" "${TMPDIR}/sc-im"
cd "${TMPDIR}/sc-im/src"
cp "${XDG_CONFIG_HOME}/sc-im/Makefile" "${TMPDIR}/sc-im/src/"
make
sudo make install clean

# system profiler
git clone "https://github.com/bossley9/htop.git" "${TMPDIR}/htop"
cd "${TMPDIR}/htop"
./autogen.sh
./configure
sudo make install clean

# fetch
git clone "https://github.com/dylanaraps/pfetch.git" "${TMPDIR}/pfetch"
cd "${TMPDIR}/pfetch"
sudo make install

# relink /bin/sh
sudo ln -sfT "dash" "/usr/bin/sh"
PACMAN_HOOK_DIR="${ETC}/pacman.d/hooks"
sudo mkdir -p "$PACMAN_HOOK_DIR"
sudo cp "${XDG_CONFIG_HOME}${PACMAN_HOOK_DIR}/binsh.hook" "$PACMAN_HOOK_DIR"

# add color to /etc/pacman.conf
sudo sed -i 's/#\s*Color/Color/' "${ETC}/pacman.conf"

# system hardening
# umask 0077 as recommended by the NSA
sudo sed -i 's/^umask.*/umask 0077/' "${ETC}/profile"
# set security limits
securityLimits="${ETC}/security/limits.conf"
sudo cp -v "${XDG_CONFIG_HOME}${securityLimits}" "$securityLimits"
# prohibit ssh root login
sshConf="${ETC}/ssh/sshd_config"
sudo sed -i 's/#\s*PermitRootLogin.*/PermitRootLogin no/' "$sshConf"
# add 5 second delay between failed login attempts
pamLogin="${ETC}/pam.d/system-login"
sudo cp -v "${XDG_CONFIG_HOME}${pamLogin}" "$pamLogin"

# systemd
# reduce the amount of journaling
journalConf="${SYSD}/journald.conf"
sudo cp -v "${XDG_CONFIG_HOME}${journalConf}" "$journalConf"
# power/lid events
loginConf="${SYSD}/logind.conf"
sudo cp -v "${XDG_CONFIG_HOME}${loginConf}" "$loginConf"

if [ "$GUI" = "1" ]; then

# suckless
sbuild "st"
sbuild "herbe"
sbuild "slock"

# slock
DISPLAY=":0" det "${XDG_CONFIG_HOME}${SYSDSYS}/template.slock@.service"
sudo ln -sf "${XDG_CONFIG_HOME}${SYSDSYS}/slock@.service" "${SYSDSYS}/slock@.service"
sudo systemctl enable "slock@${USER}.service"

# xresources
cd "${XDG_CONFIG_HOME}/getxr"
make
sudo make install clean

# swallowing windows
git clone "https://github.com/salman-abedin/devour.git" "${TMPDIR}/devour"
cd "${TMPDIR}/devour"
make
sudo make install

# ytui
cd "${XDG_CONFIG_HOME}/ytui"
make
sudo make install clean

# touchpad
touchpadConf="${ETC}/X11/xorg.conf.d/30-touchpad.conf"
sudo ln -sf "${XDG_CONFIG_HOME}${touchpadConf}" "$touchpadConf"

# unmute audio channel
amixer sset Master unmute

# alsamixer
# git clone "https://github.com/bossley9/alsamixer.git" "${TMPDIR}/alsamixer"
# cd "${TMPDIR}/alsamixer"
# make all
# sudo make install clean

# webcam
sudo ln -sf "${XDG_SCRIPT_HOME}/webcam" "${BIN}/webcam"

# spicetify with spotify
# sudo chown -R sam:wheel "${OPT_DIR}/spotify"
# sudo chmod -R go-r "${OPT_DIR}/spotify"
# AURA="${AURA} spicetify-cli"

# xmr
# XMR_ARCHIVE="${TMPDIR}/xmr.tar.bz2"
# curl -L "https://downloads.getmonero.org/cli/linux64" -o "$XMR_ARCHIVE"
# mkdir -p "${TMPDIR}/xmr"
# tar xvjf "$XMR_ARCHIVE" -C "${TMPDIR}/xmr"
# cd "${TMPDIR}/xmr"
# mv "$(ls)" "$XMR_PATH"
# postinstall rec: https://github.com/fireice-uk/xmr-stak

# firefox profile
ln -sf "${XDG_CONFIG_HOME}/mozilla/firefox" "${FF_DIR}/firefox"

# font update
fc-cache -f -v

fi

sudo pacman -S $PKGA

for AUR in $AURA; do
  git clone "https://aur.archlinux.org/${AUR}.git" "${TMPDIR}/${AUR}"
  cd "${TMPDIR}/${AUR}"
  makepkg -si
done

# grub
# timeout
grubConf="${ETC}/default/grub"
sudo sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' "$grubConf"
# regenerate
sudo grub-mkconfig -o "/boot/grub/grub.cfg"

echo "${YELLOW}It is recommended to reboot the system directly after running this script.${NC}"
