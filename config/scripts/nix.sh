#!/usr/bin/env bash

set -oue pipefail

# Install nix.
sh <(curl -L https://nixos.org/nix/install) --daemon
# curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install ostree --no-confirm
# nix-channel --add https://nixos.org/channels/nixpkgs-unstable
# nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
# nix-channel --update

# # Install home-manager
# nix-shell '<home-manager>' -A install
# # home-manager switch -b backup
