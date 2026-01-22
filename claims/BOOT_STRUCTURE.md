# TuxOS ARM64 Boot Structure for Raspberry Pi 4

> **⚠️ STATUS: UNIMPLEMENTED PROPOSAL**
>
> This document describes a **PROPOSED** boot structure for a Raspberry Pi 4 ARM64 port that was **NEVER IMPLEMENTED**. None of the ARM64 files, directories, or configurations described below exist in this codebase.
>
> **Current System:** This codebase contains an x86 Porteus Kiosk system using isolinux/GRUB boot with `boot/vmlinuz` and `boot/initrd.xz`.

---

## Overview

This document describes a proposed boot partition structure for TuxOS ARM64 on Raspberry Pi 4. The RPi boot mechanism differs significantly from x86 - instead of BIOS/UEFI with isolinux/GRUB, the RPi uses its VideoCore GPU to load firmware and kernel.

## Current x86 System (ACTUAL)

The actual codebase contains:

```
boot/
├── initrd.xz              # x86 Initial ramdisk
├── vmlinuz                # x86_64 Linux kernel (5.10.25-kiosk)
├── isolinux/
│   ├── isolinux.bin       # BIOS bootloader
│   ├── isolinux.cfg       # BIOS boot config
│   ├── grub.cfg           # UEFI boot config
│   └── efi/
│       └── efiboot.img    # EFI boot image
├── pxelinux.0             # PXE bootloader
└── pxelinux.cfg/
    └── default            # PXE config
```

**Kernel parameters (actual):** `quiet first_run run_splash`

## Proposed ARM64 Structure (NOT IMPLEMENTED)

The following was proposed but never created:

```
arm64/boot/                  # DOES NOT EXIST
├── config.txt               # DOES NOT EXIST
├── cmdline.txt              # DOES NOT EXIST
├── kernel8.img              # DOES NOT EXIST
├── initrd.img               # DOES NOT EXIST
├── start4.elf               # DOES NOT EXIST
├── fixup4.dat               # DOES NOT EXIST
└── bcm2711-rpi-4-b.dtb      # DOES NOT EXIST
```

## Boot Chain Comparison

### x86 (Current System)
```
BIOS/UEFI -> isolinux/GRUB -> vmlinuz -> initrd.xz -> /init -> switch_root
```

### Raspberry Pi 4 ARM64 (Proposed)
```
GPU bootloader -> start4.elf -> kernel8.img -> initrd.img -> /init -> switch_root
```

## Key Differences from x86

| Aspect | x86 TuxOS (ACTUAL) | RPi ARM64 TuxOS (PROPOSED) |
|--------|-------------------|---------------------------|
| Boot firmware | BIOS/UEFI | VideoCore GPU |
| Bootloader | isolinux/GRUB | config.txt + start4.elf |
| Kernel format | bzImage | Image (uncompressed) |
| Kernel location | boot/vmlinuz | boot/kernel8.img |
| Initramfs | boot/initrd.xz | boot/initrd.img |
| Boot config | isolinux.cfg/grub.cfg | config.txt |
| Kernel params | In bootloader config | cmdline.txt |
| Device discovery | PCI enumeration (lspci) | Device tree |
| Graphics driver | i915/nouveau/uvesafb | vc4-drm |

## Implementation Status

| Item | Status |
|------|--------|
| arm64/ directory | ❌ NOT CREATED |
| config.txt | ❌ NOT CREATED |
| cmdline.txt | ❌ NOT CREATED |
| overlays/ directory | ❌ NOT CREATED |
| RPi firmware files | ❌ NOT DOWNLOADED |
| kernel8.img | ❌ NOT BUILT |
| initrd.img | ❌ NOT BUILT |
| Device tree blobs | ❌ NOT DOWNLOADED |

## References

- ARM_PORTING_NOTES.md - Technical analysis of x86 dependencies (accurate)
- https://www.raspberrypi.com/documentation/computers/config_txt.html
- https://github.com/raspberrypi/firmware

---

**Document History:**
- Created: 2026-01-12 - Original proposal document
- Updated: 2026-01-22 - Corrected to reflect unimplemented status
