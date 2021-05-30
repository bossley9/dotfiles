#!usr/bin/env sh

# ETC="/etc"
# SYSD="/${ETC}/systemd"
# SYSDSYS="${SYSD}/system"
FF_DIR="${HOME}/.mozilla"

mkdir -p "$BIN"
mkdir -p "$FF_DIR"
# mkdir -p "$FONT_DIR"
# mkdir -p "$ETC"
# mkdir -p "$SYSD"
# mkdir -p "$SYSDSYS"
# mkdir -p "$TMPDIR"
# mkdir -p "$OPT_DIR"

# rust configuration
rustup default stable

# spreadsheets
# git clone "https://github.com/andmarti1424/sc-im.git" "${TMPDIR}/sc-im"
# cd "${TMPDIR}/sc-im/src"
# cp "${XDG_CONFIG_HOME}/sc-im/Makefile" "${TMPDIR}/sc-im/src/"
# make
# sudo make install clean

# system hardening
# add 5 second delay between failed login attempts
# pamLogin="${ETC}/pam.d/system-login"
# sudo cp -v "${XDG_CONFIG_HOME}${pamLogin}" "$pamLogin"

# # suckless
# sbuild "st"
# sbuild "herbe"
# sbuild "slock"

# # slock
# DISPLAY=":0" det "${XDG_CONFIG_HOME}${SYSDSYS}/template.slock@.service"
# sudo ln -sf "${XDG_CONFIG_HOME}${SYSDSYS}/slock@.service" "${SYSDSYS}/slock@.service"
# sudo systemctl enable "slock@${USER}.service"

# # xresources
# cd "${XDG_CONFIG_HOME}/getxr"
# make
# sudo make install clean

# # swallowing windows
# git clone "https://github.com/salman-abedin/devour.git" "${TMPDIR}/devour"
# cd "${TMPDIR}/devour"
# make
# sudo make install

# # ytui
# cd "${XDG_CONFIG_HOME}/ytui"
# make
# sudo make install clean

# # touchpad
# touchpadConf="${ETC}/X11/xorg.conf.d/30-touchpad.conf"
# sudo ln -sf "${XDG_CONFIG_HOME}${touchpadConf}" "$touchpadConf"

# # unmute audio channel
# amixer sset Master unmute

# # alsamixer
# # git clone "https://github.com/bossley9/alsamixer.git" "${TMPDIR}/alsamixer"
# # cd "${TMPDIR}/alsamixer"
# # make all
# # sudo make install clean

# webcam
doas ln -sf "${XDG_SCRIPT_HOME}/webcam" "${BIN}/webcam"

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

# # firefox profile
ln -sf "${XDG_CONFIG_HOME}/mozilla/firefox" "${FF_DIR}/firefox"

# font update
fc-cache -f -v

echo "${YELLOW}It is recommended to reboot the system directly after running this script.${NC}"
