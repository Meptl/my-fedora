# Fume
My personal variant of [Fedora Atomic](https://fedoraproject.org/atomic-desktops/)
based off [wayblue](https://github.com/wayblueorg/wayblue/)
a variant of [BlueBuild](https://blue-build.org/)

Simply includes a few more packages that I'd add on a default system.

TODO: Migrate from home-manager to a simple repo based off chezmoi and use that
bluebuild module.
For now, run `home-manager switch -b backup` after creating a user.

# Usage
## Iso
For new systems, we can create a LiveCD with the system pre-installed.
Manually trigger the build-iso github workflow.
Run `first-time-user-setup.sh` available in your user's home directory.
The script will install nix and setup home-manager.

## rpm-ostree
On an already running Fedora Atomic system, replace HOST for the hostname in:
```
rpm-ostree rebase ostree-unverified-registry:ghcr.io/meptl/HOST:latest
```
if you're already running off the image `rpm-ostree upgrade` is sufficient

# Test
The following builds the container image similar to github:
```
bluebuild build ./recipes/fume.yml
```
To build an iso image similar to github:
```
mkdir ./iso-output
sudo docker run --rm --privileged --volume ./iso-output:/build-container-installer/build --pull=always \
ghcr.io/jasonn3/build-container-installer:latest \
-e IMAGE_REPO=ghcr.io/meptl \
-e IMAGE_NAME=fume \
-e IMAGE_TAG=40 \
-e VARIANT=Hyprland
```

# Misc Tasks
## Generate Keys
If you ever need to regenerate keys `cosign generate-key-pair` and update
SIGNING_SECRET in GitHub Action secrets with the private key.
