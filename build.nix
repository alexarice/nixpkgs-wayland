let
  # TODO: convert to callPackages and non-overlay style? more reliable and usable by others, but can cause more pkg dupe?
  nixosUnstable = (import (import ./nixpkgs/nixos-unstable) { overlays = [ (import ./default.nix) ]; });
  nixpkgsUnstable = (import (import ./nixpkgs/nixos-unstable) { overlays = [ (import ./default.nix) ]; });
in
  {
    all = [ nixosUnstable.waylandPkgs nixpkgsUnstable.waylandPkgs ];
    inherit nixosUnstable.waylandPkgs nixpkgsUnstable.waylandPkgs;
  }

