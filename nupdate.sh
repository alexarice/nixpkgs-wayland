#!/usr/bin/env bash
set -euo pipefail
set -x

cachixremote="nixpkgs-wayland"

# update.sh v2:

# loop through all pkgs/* and update
# loop through all nixpkgs/* and update
# - get repo out of the metadata, if not get repo_hq and set mercurial=true
# - get branch out of metadata, else "master"
# - `git ls-remote ${repo} ${branch} | awk '{ print $1}'`
# - update metadata.nix minimally {rev}, {revdate}, {commit}, {sha256}?
#
# TODO: cargoSha256 will still not be automated
