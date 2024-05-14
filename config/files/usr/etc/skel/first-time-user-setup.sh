#!/usr/bin/env bash

set -oue pipefail

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

# FLATPAK_BINS=/var/lib/flatpak/exports/bin
# mkdir ~/bin
# cd ~/bin
# ln -s $FLATPAK_BINS/com.discordapp.Discord discord
# ln -s $FLATPAK_BINS/im.riot.Riot element-desktop
# ln -s $FLATPAK_BINS/io.github.spacingbat3.webcord webcord
# ln -s $FLATPAK_BINS/org.audacityteam.Audacity audacity
# ln -s $FLATPAK_BINS/org.keepassxc.KeePassXC keepassxc
# ln -s $FLATPAK_BINS/org.signal.Signal signal-desktop
# cd -
