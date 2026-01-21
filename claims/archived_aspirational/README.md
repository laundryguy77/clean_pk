# Archived Aspirational Documentation

This directory contains documentation files that describe features, architectures, or configurations that were **never implemented** in the TuxOS codebase. These documents were archived rather than deleted because they contain valuable planning and design work that may inform future development.

## Why These Files Were Archived

A documentation audit revealed that these files describe non-existent features:

| File | Issue |
|------|-------|
| `BOOT_STRUCTURE.md` | Describes an ARM64/RPi4 boot structure that does not exist in the codebase |
| `PARAM_REFERENCE.md` | References handler files (00-network.sh, 01-locale.sh, etc.) that do not exist |
| `PARAM_HANDLERS.md` | Describes a parameter handler architecture that was never implemented |
| `GUI_APP_BROWSER_FLAGS.md` | Documents Chromium browser flags, but gui-app actually uses Firefox |

## Archival Information

- **Date Archived:** 2026-01-21
- **Reason:** Documentation described planned/aspirational features that were never implemented
- **Full Details:** See `/home/user/clean_pk/AUDIT_REPORT.md` for the complete documentation audit findings

## Usage Notes

These documents may be useful for:
- Understanding original design intentions
- Planning future feature implementations
- Reference material if these features are eventually developed

**Do not reference these documents as current system documentation** - they do not reflect the actual state of the codebase.
