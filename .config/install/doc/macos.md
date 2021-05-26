## MacOS Installation <a name="macos-installation">

> You should only use this if you are forced to use MacOS for work-related things. I do not recommend using MacOS as a daily driver at all. If you're unsure why, feel free to reach out to me via email or social media and I will list the thousand reasons why :)

## Table of Contents

- [Core](#core)
- [Cloning](#cloning)
- [Additional Configuration](#additional-configuration)

## Cloning <a name="cloning"></a>

This guide is made under the assumption that you have already booted and set up the machine.

- Clone this repository to your home folder using the steps outlined below. It will prompt you to install developer tools, which you should approve.
  ```sh
  cd $HOME
  # security permissions
  umask 0077
  git clone --recursive https://github.com/bossley9/dotfiles.git dotfiles
  mv -v dotfiles/* ./
  mv -v dotfiles/.* ./
  rm -r dotfiles
  ```
- Log out and log back in from the MacOS menu in the top left corner.
- Run the install script I have created:
  ```sh
  # security permissions
  umask 0077
  $XDG_CONFIG_HOME/install/macos.sh
  ```
- Reboot the machine to allow changes to take effect.
