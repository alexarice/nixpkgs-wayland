# nix-overlay-sway

Automated, pre-built packages for Wayland (sway/wlroots) tools for NixOS.

## NOTE: WARNING

This is still potentially unusable, certain vital commits are not in nixpkgs yet.
When they are this warning will be removed.

## Overview

This is a `nixpkgs` overlay containing `HEAD` revisions of:
 - `wlroots`
 - `sway-beta`
 - `wlstream`
 - `grim`
 - `slurp`
 - `waybar`
 - `redshift-wayland` (`redshift` (with `minus7` patches))

Feel free to run the update script and send a PR if something is out-of-date.

## Example Usage

This is what I use in my configuration. It should work regardless of if you've
cloned this overlay locally.

```nix
{ ... }:
let
  nos = "https://github.com/colemickens/nix-overlay-sway/archive/master.tar.gz";
  swayOverlay =
    if builtins.pathExists /etc/nix-overlay-sway
    then (import /etc/nix-overlay-sway)
    else (import (builtins.fetchTarball nos));
in
{
  nixpkgs.overlays = [ swayOverlay ];

  environment.systemPackages = with pkgs; [ sway-beta grim slurp ];
}
```

## Automation

* `./update.sh`
  * updates `./<pkg>/metadata.nix` with the latest commit+hash for each package.
  * updates `nixpkgs/metadata.nix` to `nixpkgs-channels#nixos-unstable`.

* `nix-build build.nix` builds all overlay packages with the nixpkgs specified in `./nixpkgs`.

* (Sidenote: [nixcfg/utils/azure](https://github.com/colemickens/nixcfg/tree/master/utils/azure) contains the script(s) used
  to upload the cached NARs to the binary mirror specified in this README.)

## Binary Cache

I run a cache. It sometimes, might contain packages as built by the process described above.

* cache: `https://nixcache.cluster.lol`
* public key: `nixcache.cluster.lol-1:DzcbPT+vsJ5LdN1WjWxJPmu+BeU891mgsrRa2X+95XM=`

```
--extra-binary-caches "https://nixcache.cluster.lol https://cache.nixos.org"
--option trusted-public-keys "nixcache.cluster.lol-1:DzcbPT+vsJ5LdN1WjWxJPmu+BeU891mgsrRa2X+95XM= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="'
```

## Notes

* This is meant to be used with a nixpkgs near `nixos-unstable`.

