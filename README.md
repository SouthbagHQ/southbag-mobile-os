# Southbag Mobile OS

Southbag Mobile OS is the official mobile operating system of Southbag,
extended to the Google Pixel 4a (`sunfish`). That is the only supported
device. The build system refuses to proceed for anything else, which the
Institution considers a feature.

- Base: LineageOS 24.0 (Android 17), the current official branch for `sunfish`
- Device tree: `LineageOS/android_device_google_sunfish`
- Kernel: `LineageOS/android_kernel_google_msm-4.14` (4.14)
- Vendor blobs: `TheMuppets/proprietary_vendor_google_sunfish`
- Product: `southbag_sunfish`; lunch combo resolves to
  `southbag_sunfish-<aosp_target_release>-userdebug`

## Southbag identity in the system

- `PRODUCT_BRAND` / `PRODUCT_SYSTEM_NAME`: Southbag / Southbag Mobile OS
  (shown in Settings > About phone)
- `ro.southbag.*` system properties (`config/southbag.prop`): version, base,
  device, and the motto - Kevin is watching

Planned next (source only, not yet implemented): Kevin wallpaper, launcher
greeting ("Kevin is watching. He noticed you opened this.", matching the
desktop Southbag OS), and Southbag boot animation.

## Repository layout

This repository is checked out as `vendor/southbag` inside a LineageOS build
tree by the local manifest in `manifest/southbag.xml`.

| Path | Purpose |
| --- | --- |
| `build/target/product/` | `southbag_sunfish` product definition |
| `config/common.mk` | Southbag configuration; enforces sunfish-only |
| `config/southbag.prop` | `ro.southbag.*` system properties |
| `manifest/southbag.xml` | local manifest (device tree, kernel, vendor blobs, this repo) |
| `scripts/build.sh` | end-to-end sync + build script |
| `docs/BUILD.md` | full build guide |
| `tests/validate.sh` | static scaffold checks (run in CI) |

## Building

A serious build host is required: 64 GB RAM and 400 GB of SSD storage
(per the LineageOS build requirements for `sunfish`). The Institution does
not provide one at this time. See `docs/BUILD.md`.

Short version, on a suitable machine:

```
scripts/build.sh ~/android/southbag
```

`tests/validate.sh` runs static scaffold checks anywhere (no AOSP tree
needed) and runs in CI on every push.

## Status

Scaffold only. No build has been produced (no build host), no device has
been flashed, and no installable image has been published. Branding listed
above is source-level configuration, not yet verified on a running device.

## License

Apache License 2.0, matching LineageOS. Southbag Mobile OS is a distribution
of LineageOS and remains subject to its licenses and trademark policy.

Kevin is watching.
