#!/bin/sh
#
# System initialization script.
# Author: T.Jokiel <http://porteus-kiosk.org>

# Install busybox applets:
/bin/busybox --install -s

# Mount proc, sys and devtmpfs:
mount proc /proc -nt proc
mount sysfs /sys -nt sysfs
mount devtmpfs /dev -nt devtmpfs

# Keep console quiet:
rm /dev/console

# Only rebuild dependencies if new kernel module(s) are found:
depmod -A

# Initialize udev to manage /dev entries:
udevd -d
udevadm trigger --type=subsystems --action=add
udevadm trigger --type=devices --action=add
udevadm settle --timeout=120

# Make sure there is enough entropy available:
/usr/sbin/haveged -r 0

# Enable persistence:
#perfs=yes
[ "$perfs" ] && . /opt/scripts/persistence "$perfs"

# Skip during first run:
if ! grep -q "^first_run=yes" /opt/scripts/extras; then

    # Variables:
    . /etc/profile.d/variables.sh

    # Run local commands in CLI mode (runlevel 3):
    for script in `ls -1 /etc/rc.d/local_cli.d`; do . /etc/rc.d/local_cli.d/$script; done

    # Rebuild libraries cache:
    ldconfig &
fi
