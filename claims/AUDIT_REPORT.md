# Documentation Audit Report

**Date:** 2026-01-21
**Auditor:** Claude (Opus 4.5)
**Scope:** All markdown documentation in /claims directory

---

## Executive Summary

A comprehensive audit of all 10 documentation files in the `/claims` directory reveals a **significant disconnect between documentation and implementation**. Multiple documents describe features, architectures, and files that do not exist in the codebase.

---

## Document Status Overview

| Document | Status | Key Finding |
|----------|--------|-------------|
| BOOT_STRUCTURE.md | ❌ CRITICAL | Describes non-existent ARM64 boot structure |
| BOOT_SEQUENCE.md | ⚠️ MIXED | Valid x86 analysis, false credential locations |
| PARAM_REFERENCE.md | ❌ CRITICAL | Handler files (00-network.sh, etc.) don't exist |
| PARAM_HANDLERS.md | ❌ CRITICAL | Entire handler architecture doesn't exist |
| SCRIPTS_REFERENCE.md | ⚠️ MIXED | Valid script inventory, false ARM64 claims |
| CORE_MODULE_ANALYSIS.md | ✅ ACCURATE | Good analysis of actual x86 binaries |
| BINARY_ANALYSIS.md | ⚠️ VALID | first-run/update-config are ELF binaries |
| GUI_APP_BROWSER_FLAGS.md | ❌ CRITICAL | Describes Chromium, but gui-app uses Firefox |
| TUXOS_UI_FLOW_SPECIFICATION.md | ⚠️ MIXED | Valid UI flow, first-run doesn't exist locally |
| ARM_PORTING_NOTES.md | ✅ ACCURATE | Valid x86 analysis for theoretical ARM port |

---

## Critical False Claims

### 1. Non-Existent ARM64 Port
Multiple documents describe an ARM64 Raspberry Pi 4 port that **does not exist**:
- No `arm64/boot/` directory
- No `config.txt`, `cmdline.txt`, `FIRMWARE_NEEDED.txt`
- No RPi firmware files
- Status tables claiming files are "CREATED" are false

### 2. Non-Existent Parameter Handler System
Documents claim an extensible parameter handler architecture that was **never implemented**:
- `/opt/scripts/apply-config` - **DOES NOT EXIST**
- `/opt/scripts/param-handlers/` directory - **DOES NOT EXIST**
- Handler files (00-network.sh through 90-custom.sh) - **NONE EXIST**
- daemon.sh does NOT call apply-config
- Claims of "Integration verified and deployed (2026-01-13)" are **fabricated**

### 3. Missing XZM Module
- `002-chrome.xzm` claimed to exist (65MB) - **DOES NOT EXIST**
- Module sizes documented are approximate, not exact

### 4. Incorrect Browser Implementation
- GUI_APP_BROWSER_FLAGS.md describes Chromium browser with Pi4-specific flags
- Actual `gui-app` script launches **Firefox** (`su - guest -c "firefox"`)
- Chrome wrapper exists but is not the default in gui-app

### 5. False Credential Locations
Document claims:
- Credentials at wizard lines 113-115, 212-214
- URLs: `pod9.gsiresource.com`, `carerite.greysignal.com`, `prestige.greysignal.com`

Actual code:
- Uses `cullerdigitalmedia.com` (lines 103, 110, 204-207)
- Password "P@ss3264" is at line 106 as fallback
- None of the claimed external URLs exist in wizard

### 6. Kernel Parameters Discrepancy
- Document claims: `quiet first_run run_splash mem_encrypt=off amd_iommu=off`
- Actual isolinux.cfg: `quiet first_run run_splash` (no AMD params)

---

## Verified Accurate Claims

### Scripts and Line Numbers
| Claim | Verification |
|-------|--------------|
| autostart line 97: first-run check | ✓ EXACT MATCH |
| autostart line 121: update-config check | ✓ EXACT MATCH |
| autostart line 124: update check | ✓ EXACT MATCH |
| autostart line 139: local_net.d hook | ✓ EXACT MATCH |
| rc.S line 40: local_cli.d hook | ✓ EXACT MATCH |
| xinitrc line 16: local_gui.d hook | ✓ EXACT MATCH |

### File Sizes and Counts
| Claim | Verification |
|-------|--------------|
| daemon.sh: 65 lines | ✓ EXACT MATCH |
| greyos_reboot: 23 lines | ✓ EXACT MATCH |
| wizard-functions: 2,259 lines | ✓ EXACT MATCH |
| gui-app: ~18 lines | ✓ (actual: 18) |
| autostart: 293 lines | Close (actual: 292) |
| welcome: 617 lines | Close (actual: 616) |
| wizard: ~385 lines | INACCURATE (actual: 299) |

### Module Analysis (CORE_MODULE_ANALYSIS.md)
| Claim | Verification |
|-------|--------------|
| 001-core total files: 4,524 | ✓ EXACT MATCH |
| 001-core symlinks: 696 | ✓ EXACT MATCH |
| monr: 6MB static-pie x86-64 | ✓ Confirmed |
| mkisofs: i386 32-bit static | ✓ Confirmed |
| glibc 2.32 | ✓ Confirmed (libc-2.32.so exists) |

### System Configuration
| Claim | Verification |
|-------|--------------|
| Kernel version: 5.10.25-kiosk | ✓ Confirmed |
| Boot uses isolinux/GRUB | ✓ Confirmed |
| pkget SSH password: 9Se-7c.fgLa | ✓ Confirmed |
| Hook directories exist | ✓ All three exist |

---

## Captured Scripts Analysis

Files in `/claims/captured_scripts/`:
- `first-run` - ELF binary (NOT a shell script), linked with uClibc
- `update-config` - ELF binary (NOT a shell script)
- `pkget` - Shell script (duplicate of the one in 003-settings)

These are the actual server-provisioned binaries captured from a running system.

---

## Recommendations

### Immediate Actions
1. **Delete or clearly mark as "ASPIRATIONAL/PLANNED":**
   - BOOT_STRUCTURE.md
   - PARAM_REFERENCE.md
   - PARAM_HANDLERS.md
   - GUI_APP_BROWSER_FLAGS.md

2. **Update with corrections:**
   - BOOT_SEQUENCE.md - Remove false kernel params and credential locations
   - SCRIPTS_REFERENCE.md - Remove ARM64 references

### Documentation Cleanup
3. **Keep as accurate reference:**
   - CORE_MODULE_ANALYSIS.md (accurate x86 analysis)
   - ARM_PORTING_NOTES.md (accurate x86 dependency analysis)
   - BINARY_ANALYSIS.md (correct about ELF binaries)

4. **Clarify scope:**
   - TUXOS_UI_FLOW_SPECIFICATION.md - Note that first-run is server-provisioned

---

## Methodology

Each document was audited by:
1. Reading the full document
2. Identifying specific claims (file paths, line numbers, sizes, etc.)
3. Using `find`, `grep`, `ls`, `wc`, `file` to verify against actual codebase
4. Cross-referencing multiple documents for consistency
5. Tracing code paths to verify described flows

---

## Conclusion

The documentation in `/claims` contains a mix of:
- **Accurate analysis** of the existing x86 codebase
- **Fabricated claims** about ARM64 ports and handler systems that don't exist
- **Outdated or incorrect** information about URLs and credentials
- **Aspirational designs** that were never implemented

Users of this documentation should verify all claims against the actual codebase before relying on them.
