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
}
```
