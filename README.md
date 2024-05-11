# Fume
My personal variant of [Fedora Atomic](https://fedoraproject.org/atomic-desktops/)
based off [BlueBuild](https://blue-build.org/)

# Generate Keys
If you ever need to regenerate keys

# Build
Github Actions should automatically build and push to ghcr.

To build locally:
```
bluebuild build ./recipes/recipe.yml
```

# Installation
```
rpm-ostree rebase ostree-unverified-registry:ghcr.io/meptl/fume:40
```
