# Fume
My personal variant of [Fedora Atomic](https://fedoraproject.org/atomic-desktops/)
based off [wayblue](https://github.com/wayblueorg/wayblue/)
a variant of [BlueBuild](https://blue-build.org/)

Simply includes a few more packages that I'd add on a default system.

TODO: Migrate from home-manager to a simple repo based off chezmoi and use that
bluebuild module.
For now, run `home-manager switch -b backup` after creating a user.

# Usage
On an already running Fedora Atomic system
```
rpm-ostree rebase ostree-unverified-registry:ghcr.io/meptl/fume:40
```

# Test
To build locally:
```
bluebuild build ./recipes/recipe.yml
```


# Misc Tasks
## Generate Keys
If you ever need to regenerate keys `cosign generate-key-pair` and update
SIGNING_SECRET in GitHub Action secrets with the private key.

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
