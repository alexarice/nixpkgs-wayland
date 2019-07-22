#!/usr/bin/env bash
set -euo pipefail
set -x

ROOT="$(pwd)"

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

cd $ROOT

dir=nixpkgs

function update_rev() {
  metadata="${d}/metadata.nix"
  pkgname="$(basename "${d}")"

  repo="$(nix eval --raw -f "${metadata}" repo)"
  mercurial=0
  if nix eval --raw -f "${metadata}" mercurial; then mercurial=1; fi  
  branch="$(nix eval --raw -f "${metadata}" branch)"

  nix-prefetch-url "${d}"
}

for d in nixpkgs/*; do
  # update the nixpkgs ref first
  update_ref "${d}"

  for p in pkgs/*; do
    
    repo="$(nix eval --raw -f "${metadata}" repo)"
    mercurial=0
    if nix eval --raw -f "${metadata}" mercurial; then
      mercurial=1
    fi
    
    branch="$(nix eval --raw -f "${metadata}" branch)"

    if [[ "${mercurial}" == 1 ]]; then
      rev="$(hg identify "${repo}" -r "${branch}")"
      sha256="$(nix-prefetch \
        -E "(import ./build.nix).${nixpkgsname}" \
        --fetchurl \
        --rev gh-pages)"
    else
      rev="$(git ls-remote "${repo}" "${branch}" | awk '{ print $1}')"
      sha256="$(nix-prefetch \
        -E "(import ./build.nix).${nixpkgsname}.${pkgname}" \
        --fetchurl \
        --rev gh-pages)"
    fi
  done
done