# TuxOS Browser Configuration Reference

> **⚠️ STATUS: DOCUMENTATION MISMATCH**
>
> This document originally described a Chromium-based gui-app for a proposed ARM64 port. However, the **actual gui-app script launches Firefox**, not Chromium.
>
> **Current System:** The gui-app script at `xzm/003-settings/opt/scripts/gui-app` runs `su - guest -c "firefox"`.

---

## Actual gui-app Script

**Location:** `xzm/003-settings/opt/scripts/gui-app`

```bash
#!/bin/sh
#
# Start kiosk application in a loop.
# Author: T.Jokiel <http://porteus-kiosk.org>

# Disable backup of the /home folder (just in case the session is restarted):
sed -i 's_^cp -a /home/guest_#cp -a /home/guest_g' /etc/xdg/openbox/autostart

# Start application in a loop:
while true; do
    rm -rf /home/guest /tmp/*; cp -a /opt/scripts/guest /home; sync
    # Session manager:
    #/opt/scripts/session-manager
    # Bottom panel:
    #/opt/scripts/start-panel
    su - guest -c "firefox"
    sync
done
```

**Key Points:**
- Launches **Firefox** (not Chromium)
- Runs in an infinite loop
- Cleans /home/guest before each session
- Does NOT parse config files or apply browser flags

## Chrome Configuration Files (UNUSED)

Chrome policy/config files exist in the codebase but are **not used** by the current gui-app:

| File | Location | Status |
|------|----------|--------|
| chrome.json | `xzm/003-settings/etc/opt/chrome/policies/managed/chrome.json` | EXISTS but UNUSED |
| chrome-flags.conf | `xzm/003-settings/opt/google/chrome/chrome-flags.conf` | EXISTS but UNUSED |

These files would only be used if:
1. Chrome/Chromium was installed (it's not in the base modules)
2. gui-app was modified to launch Chrome instead of Firefox

## Firefox Configuration

Firefox settings would be configured through:
- Mozilla preference files in `/home/guest/.mozilla/firefox/`
- The `pprofile` variable points to: `/opt/scripts/guest/.mozilla/firefox/c3pp43bg.default`

## Proposed Chromium Flags (NOT IMPLEMENTED)

The following Chromium flags were proposed for an ARM64 port but were never implemented:

### Kiosk Flags (Proposed)
- `--kiosk` - Fullscreen kiosk mode
- `--no-first-run` - Skip first-run wizard
- `--disable-infobars` - Disable info bars
- `--noerrdialogs` - Suppress error dialogs

### Pi4 Specific Flags (Proposed)
- `--use-gl=egl` - Use EGL for OpenGL
- `--enable-features=VaapiVideoDecoder` - Hardware video decoding
- `--disable-dev-shm-usage` - Limited /dev/shm on Pi

## Summary

| Aspect | Documentation Claim | Actual Implementation |
|--------|--------------------|-----------------------|
| Browser | Chromium | **Firefox** |
| Flags parsing | Yes | **No** |
| Config file support | `/tmp/kiosk_url.env`, lcon | **Not implemented in gui-app** |
| Chrome policy files | Used | **Exist but unused** |

---

**Document History:**
- Created: January 2026 - Original Chromium proposal
- Updated: 2026-01-22 - Corrected to reflect actual Firefox implementation
