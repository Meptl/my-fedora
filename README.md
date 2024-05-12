# Fume
My personal variant of [Fedora Atomic](https://fedoraproject.org/atomic-desktops/)
based off [BlueBuild](https://blue-build.org/)

TODO: Migrate from home-manager to a simple repo based off chezmoi and use that
bluebuild module.
For now, run `home-manager switch -b backup` after creating a user.

# Generate Keys
If you ever need to regenerate keys `cosign generate-key-pair` and update
SIGNING_SECRET in GitHub Action secrets with the private key.

# Build
Github Actions should automatically build and push to ghcr.

To build locally:
```
bluebuild build ./recipes/recipe.yml
```

## Generate ISO
```
mkdir ./iso-output
sudo docker run --rm --privileged --volume ./iso-output:/build-container-installer/build --pull=always \
ghcr.io/jasonn3/build-container-installer:latest \
-e IMAGE_REPO=ghcr.io/meptl \
-e IMAGE_NAME=fume \
-e IMAGE_TAG=40 \
-e VARIANT=Sericea
```

# Installation
```
rpm-ostree rebase ostree-unverified-registry:ghcr.io/meptl/fume:40
```
