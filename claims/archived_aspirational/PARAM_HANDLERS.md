# ARM64 Port: Extensible Parameter Handler System

> **⚠️ STATUS: UNIMPLEMENTED PROPOSAL**
>
> This document describes a **PROPOSED** parameter handler architecture that was **NEVER IMPLEMENTED**. Despite claims of "Integration verified and deployed (2026-01-13)", none of the following exist:
> - `/opt/scripts/param-handlers/` directory
> - `/opt/scripts/apply-config` script
> - Any of the handler scripts (00-network.sh through 90-custom.sh)
>
> **Current System:** The x86 Porteus Kiosk codebase uses individual scripts for parameter handling, not a centralized handler system.

---

## Overview

This document described a proposed extensible parameter handler architecture for processing configuration parameters from remote config files. **This system was never implemented.**

## Proposed Architecture (NOT IMPLEMENTED)

### Proposed Directory Structure

```
/opt/scripts/
├── param-handlers/              # DOES NOT EXIST
│   ├── 00-network.sh            # DOES NOT EXIST
│   ├── 10-proxy.sh              # DOES NOT EXIST
│   ├── 20-browser.sh            # DOES NOT EXIST
│   ├── 30-display.sh            # DOES NOT EXIST
│   ├── 40-input.sh              # DOES NOT EXIST
│   ├── 50-power.sh              # DOES NOT EXIST
│   ├── 60-audio.sh              # DOES NOT EXIST
│   ├── 70-services.sh           # DOES NOT EXIST
│   ├── 80-system.sh             # DOES NOT EXIST
│   └── 90-custom.sh             # DOES NOT EXIST
├── apply-config                 # DOES NOT EXIST
└── ...
```

### Proposed apply-config Script (NOT IMPLEMENTED)

```bash
#!/bin/bash
# THIS SCRIPT DOES NOT EXIST - PROPOSAL ONLY
CONFIG="${1:-/opt/scripts/files/lcon}"
HANDLER_DIR="/opt/scripts/param-handlers"

[ -f "$CONFIG" ] && source "$CONFIG"
export CONFIG DISPLAY=:0

for handler in "$HANDLER_DIR"/*.sh; do
    [ -x "$handler" ] && "$handler"
done
```

## Actual System (WHAT EXISTS)

### Current Parameter Handling

The actual codebase handles parameters through:

1. **autostart** (`xzm/003-settings/etc/xdg/openbox/autostart`) - 292 lines
   - Processes display, input, power management settings
   - Hook execution at line 139 for `local_net.d` scripts

2. **daemon.sh** (`xzm/zz-settings/etc/rc.d/local_net.d/daemon.sh`) - 65 lines
   - Polls `kiosk_config` URL
   - Handles `daemon_check`, `daemon_force_reboot`, `daemon_message`
   - Does NOT call any apply-config script

3. **wizard scripts** - Handle initial device configuration

### Verified Files (ACTUAL)

| File | Location | Status |
|------|----------|--------|
| autostart | `xzm/003-settings/etc/xdg/openbox/autostart` | ✅ EXISTS |
| daemon.sh | `xzm/zz-settings/etc/rc.d/local_net.d/daemon.sh` | ✅ EXISTS |
| wizard | `xzm/zz-settings/opt/scripts/wizard` | ✅ EXISTS |
| welcome | `xzm/zz-settings/opt/scripts/welcome` | ✅ EXISTS |
| apply-config | `/opt/scripts/apply-config` | ❌ DOES NOT EXIST |
| param-handlers/ | `/opt/scripts/param-handlers/` | ❌ DOES NOT EXIST |

## Implementation Status

| Proposed Item | Claimed Status | Actual Status |
|---------------|----------------|---------------|
| "Integration verified and deployed (2026-01-13)" | Claimed DONE | ❌ FALSE - Never implemented |
| `/opt/scripts/apply-config` | Claimed EXISTS | ❌ DOES NOT EXIST |
| `/opt/scripts/param-handlers/*.sh` | Claimed "10 handlers" | ❌ NONE EXIST |
| daemon.sh calls apply-config | Claimed YES | ❌ NO - No such call exists |
| autostart calls apply-config | Claimed YES | ❌ NO - No such call exists |

## Hook Directories (THESE DO EXIST)

The following hook directories are real and functional:

| Directory | Execution Point | Status |
|-----------|-----------------|--------|
| `/etc/rc.d/local_cli.d/` | rc.S line 40 | ✅ EXISTS |
| `/etc/rc.d/local_gui.d/` | xinitrc line 16 | ✅ EXISTS |
| `/etc/rc.d/local_net.d/` | autostart line 139 | ✅ EXISTS |

---

**Document History:**
- Created: 2026-01-12 - Original proposal document
- Updated: 2026-01-22 - Corrected to reflect unimplemented status; false "deployed" claims removed
