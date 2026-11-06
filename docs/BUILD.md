# Building Southbag Mobile OS

Southbag Mobile OS is a LineageOS distribution for the Google Pixel 4a
(`sunfish`), built with the standard LineageOS build flow plus the Southbag
product configuration. This guide adapts the official LineageOS build
instructions (https://wiki.lineageos.org/devices/sunfish/build/) and was
checked against the actual `lineage-24.0` sources on 2026-11-06.

## Requirements

Per the LineageOS build guide for `sunfish`:

- A relatively recent x86_64 computer running Linux (Ubuntu 20.04 LTS or
  newer recommended)
- 64 GB RAM or more (lineage-21 and up); enable ZRAM if short
- 400 GB free storage; an SSD is strongly recommended
- A decent internet connection (the source checkout is well over 100 GB)
- The Android build packages listed in the LineageOS build guide
  (`repo`, `git`, build tools, etc.)

GitHub-hosted CI runners are far too small for an AOSP/LineageOS build, so
the CI build job in `.github/workflows/build.yml` targets a self-hosted
runner with the `southbag-build` label and only runs on manual dispatch.
The `validate` job (static scaffold checks) runs on hosted runners.

## Steps

1. Initialize the LineageOS source tree (branch `lineage-24.0`):

   ```
   mkdir -p ~/android/southbag && cd ~/android/southbag
   repo init -u https://github.com/LineageOS/android.git -b lineage-24.0 --git-lfs --no-clone-bundle
   ```

2. Add the Southbag local manifest (this pins the Pixel 4a device tree,
   kernel, vendor blobs, and this repository as `vendor/southbag`):

   ```
   mkdir -p .repo/local_manifests
   curl -fsSL https://raw.githubusercontent.com/SouthbagHQ/southbag-mobile-os/main/manifest/southbag.xml \
     -o .repo/local_manifests/southbag.xml
   ```

   If this repository is private, both this fetch and the `repo sync` of the
   `southbag` project need GitHub authentication (a git credential helper or
   `gh auth login`). Never commit tokens to this repo.

3. Sync the source:

   ```
   repo sync -c -j$(nproc) --force-sync --no-clone-bundle --no-tags
   ```

4. Select the product and build:

   ```
   source build/envsetup.sh
   source vendor/lineage/vars/aosp_target_release
   lunch southbag_sunfish-${aosp_target_release}-userdebug
   mka bacon
   ```

   Do not use bare `breakfast southbag_sunfish` / `brunch southbag_sunfish`:
   on `lineage-24.0`, `breakfast` (vendor/lineage/build/envsetup.sh)
   hardcodes the `lineage_` product prefix, so the bare form resolves to a
   nonexistent `lineage_southbag_sunfish`. The snippet above resolves the
   release token exactly the way `breakfast` does
   (`aosp_target_release=cp2a` on `lineage-24.0` as of 2026-11-06) and
   lunches the full combo directly. The device tree and kernel are already
   synced by the local manifest, so `roomservice` (which only fetches
   dependencies for `lineage_*` products) is not needed.

   `scripts/build.sh` runs all of the above end to end.

5. When the build finishes, the installable zip and recovery `boot.img` are
   in `out/target/product/sunfish/`.

## Provenance and licensing

- LineageOS and AOSP sources: Apache License 2.0 (with some components under
  their own licenses); see the LineageOS project. Southbag Mobile OS's own
  files are Apache-2.0 (see LICENSE).
- The Pixel 4a vendor blobs (`TheMuppets/proprietary_vendor_google_sunfish`)
  are prebuilt, proprietary Google binaries extracted from the official
  factory images. They are NOT open source, are used the same way official
  LineageOS builds use them, and must not be relicensed or misrepresented.
- "LineageOS" is a trademark of the LineageOS project; this distribution is
  not an official LineageOS product.

## Installing (requires an actual Pixel 4a)

Follow the official LineageOS installation guide for `sunfish`. In short:

- The phone must be running the latest stock Android 13 firmware
  (`TQ3A.230805.001.x`) before installation; this is a hard requirement from
  the LineageOS install guide.
- Unlock the bootloader (`fastboot flashing unlock`) - this wipes the device.
- Flash the recovery: `fastboot flash boot boot.img`
- Sideload the OS zip from recovery.

Unsigned/own-key builds should be signed before real use; see the LineageOS
"Signing builds" guide. No Southbag signing keys exist yet.

## Current status and known gaps

- No build host is provisioned, so no image exists yet.
- The build flow (product registration, lunch combo resolution) has been
  verified against the `lineage-24.0` sources statically, but no end-to-end
  build has run. First build may surface ordinary integration issues.
- No signing keys generated.
- No device has been flashed or tested. Hardware validation requires a
  physical Pixel 4a.

Kevin is watching.
