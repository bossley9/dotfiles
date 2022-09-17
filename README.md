# nix

To recreate this configuration, subscribe to the following channels via `nix-channel`:

```sh
$ nix-channel --add https://nixos.org/channels/nixos-unstable nixos
$ nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
$ nix-channel --update
```

Then create a `secrets.nix` file containing secrets such as:

```nix
{
  username = "username";
  email = "email";
  hostname = "hostname";
  cpu = "intel or amd";
  ethEnabled = true;
  ethInterface = "em0";
  wifiEnabled = true;
  wifiInterface = "iwm0";
}
```

# Post-Boot

After booting for the first time, there are a few configurations that are cannot automatically be applied. This section is mostly reminders for me in the case I need to reclone my configuration.

1. Open Chromium and ensure that the extensions are loaded. Chromium (Chrome) likes to disable automatically-installed extensions.
2. Open `chrome://settings` in Chromium and change each option to sane defaults (be sure to look at all options - many are hidden under menus and sections).
3. Generate new ssh and gpg keys to be used on all machines.
