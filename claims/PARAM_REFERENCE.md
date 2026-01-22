# Porteus Kiosk Parameter Reference

> **⚠️ STATUS: UNIMPLEMENTED PROPOSAL**
>
> This document describes a **PROPOSED** parameter handler system that was **NEVER IMPLEMENTED**. The handler scripts (`00-network.sh`, `10-proxy.sh`, etc.) and the `/opt/scripts/param-handlers/` directory do **NOT EXIST** in this codebase.
>
> **Current System:** Parameters are processed by individual scripts (autostart, daemon.sh, etc.) without a centralized handler system.

---

## Overview

This document was intended as a reference for remote config parameters for a proposed ARM64 port. The handler architecture described below was never implemented.

## Proposed Handler System (NOT IMPLEMENTED)

The following handler structure was proposed but never created:

```
/opt/scripts/param-handlers/     # DOES NOT EXIST
├── 00-network.sh                # DOES NOT EXIST
├── 10-proxy.sh                  # DOES NOT EXIST
├── 20-browser.sh                # DOES NOT EXIST
├── 30-display.sh                # DOES NOT EXIST
├── 40-input.sh                  # DOES NOT EXIST
├── 50-power.sh                  # DOES NOT EXIST
├── 60-audio.sh                  # DOES NOT EXIST
├── 70-services.sh               # DOES NOT EXIST
├── 80-system.sh                 # DOES NOT EXIST
└── 90-custom.sh                 # DOES NOT EXIST
```

## Actual Parameter Handling (CURRENT SYSTEM)

In the actual x86 codebase, parameters are handled by:

1. **autostart** (`/etc/xdg/openbox/autostart`) - Processes most UI/display parameters
2. **daemon.sh** (`/etc/rc.d/local_net.d/daemon.sh`) - Polls remote config, handles `daemon_*` parameters
3. **wizard scripts** - Handle initial configuration
4. **Individual scripts** in `/opt/scripts/` - Various specialized handlers

### Key Config Files (ACTUAL)

| File | Purpose |
|------|---------|
| `/opt/scripts/extras` | Runtime flags (first_run, boot_dev) - created at runtime |
| `/opt/scripts/files/lcon` | Local config (active configuration) - created at runtime |
| `/opt/scripts/files/rcon` | Remote config (downloaded) - created at runtime |

### Daemon Parameters (ACTUAL - handled by daemon.sh)

| Parameter | Description | Handler |
|-----------|-------------|---------|
| `kiosk_config` | Remote config URL | daemon.sh |
| `daemon_check` | Poll interval (minutes) | daemon.sh |
| `daemon_force_reboot` | Reboot on config change | daemon.sh |
| `daemon_message` | Display notification | daemon.sh |

## Official Porteus Kiosk Parameters

For the complete list of supported parameters in standard Porteus Kiosk, see:
- https://porteus-kiosk.org/parameters.html

---

## Implementation Status

| Proposed Component | Status |
|-------------------|--------|
| `/opt/scripts/param-handlers/` directory | ❌ NOT CREATED |
| `/opt/scripts/apply-config` script | ❌ NOT CREATED |
| Handler scripts (00-90) | ❌ NOT CREATED |
| Centralized parameter processing | ❌ NOT IMPLEMENTED |

---

**Document History:**
- Created: 2026-01-12 - Original proposal document
- Updated: 2026-01-22 - Corrected to reflect unimplemented status
