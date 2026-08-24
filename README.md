<div align="center">

# Fluxer-Canary-AppImage 🐧

[![GitHub Downloads](https://img.shields.io/github/downloads/KevinRunforrestt/fluxer-canary-appimage/total?logo=github&label=GitHub%20Downloads)](https://github.com/KevinRunforrestt/fluxer-canary-appimage/releases/latest)
[![CI Build Status](https://github.com/KevinRunforrestt/fluxer-canary-appimage/actions/workflows/appimage.yml/badge.svg)](https://github.com/KevinRunforrestt/fluxer-canary-appimage/actions/workflows/appimage.yml)
[![Latest Release](https://img.shields.io/github/v/release/KevinRunforrestt/fluxer-canary-appimage)](https://github.com/KevinRunforrestt/fluxer-canary-appimage/releases/latest)

<p align="center">
  <img
    src="https://github.com/fluxerapp/fluxer/blob/main/fluxer_desktop/build_resources/icons-canary/512x512.png?raw=true"
    alt="Fluxer Canary icon"
    width="128"
  />
</p>

| Latest Release | Upstream Repository |
| :---: | :---: |
| [Download](https://github.com/KevinRunforrestt/fluxer-canary-appimage/releases/latest) | [Fluxer](https://github.com/fluxerapp/fluxer) |

</div>

---

An unofficial AppImage build of **Fluxer Canary** for Linux.

This AppImage is built using [sharun](https://github.com/VHSgunzo/sharun) and its wrapper, [quick-sharun](https://github.com/pkgforge-dev/Anylinux-AppImages/blob/main/useful-tools/quick-sharun.sh). These tools make it easy to turn binaries into reliable, portable packages without using containers or similar workarounds.

The AppImage bundles its dependencies and should work on most Linux distributions, including older and musl-based distributions.

It does not require FUSE to run, thanks to [uruntime](https://github.com/VHSgunzo/uruntime).

The CI automatically rebuilds the AppImage every seven days to include the latest Fluxer Canary updates from the official tarball.

For more information, visit [AnyLinux-AppImages](https://pkgforge-dev.github.io/Anylinux-AppImages/).

## Credits

Thanks to [Samueru-sama](https://github.com/Samueru-sama) and [fiftydinar](https://github.com/fiftydinar) for making AppImage builds quicker and easier with the [Anylinux-AppImages](https://github.com/pkgforge-dev/Anylinux-AppImages) tools.
