#!/usr/bin/env bash

set -oue pipefail

# Set default shell
chsh -c /bin/zsh

# Install nix.
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install ostree --no-confirm
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

git clone https://gitlab.com/meptl/home-manager-conf ~/.config/home-manager

# Install home-manager
nix-shell '<home-manager>' -A install
home-manager switch -b backup

# Waydroid. Mostly here as a reference.
# rpm-ostree install waydroid
# waydroid init -c https://ota.waydro.id/system -v https://ota.waydro.id/vendor -s GAPPS
