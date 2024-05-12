#!/usr/bin/env bash

set -oue pipefail

# Install nix.
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install ostree --no-confirm
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

# Setup SSH keys for GitHub.
ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519
# Prompt the user to add the SSH key to their GitHub account.
echo
echo "Please add the following SSH key to your GitHub account:"
echo
cat ~/.ssh/id_ed25519.pub
echo
read -p "Press enter when you've added the key to your GitHub account: "


git clone git@gitlab.com:meptl/nixos-conf


# Install home-manager
nix-shell '<home-manager>' -A install
rm -rf ~/.config/home-manager
ln -s ~/nixos-conf/home ~/.config/home-manager
home-manager switch -b backup

# Waydroid. Mostly here as a reference.
# rpm-ostree install waydroid
# waydroid init -c https://ota.waydro.id/system -v https://ota.waydro.id/vendor -s GAPPS
