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

1. Open `about:preferences#search` in Firefox and set the default search engine to a more privacy-respecting search engine (maybe DuckDuckGo).
2. Install the following extensions for Firefox, making sure all run in private windows if applicable:
    * uBlock Origin by Raymond Hill
    * Firefox Multi-Account Containers by Mozilla Firefox
    * Bitwarden - Free Password Manager by Bitwarden Inc. (make sure to set the server URL)
    * Vimium-FF by Stephen Blott and Phil Crosby
3. Set your Bitwarden server: `bw config server https://myvault.example.com`.
4. Copy over Yubikey ecdsa keys using `ssh-keygen -K`.
