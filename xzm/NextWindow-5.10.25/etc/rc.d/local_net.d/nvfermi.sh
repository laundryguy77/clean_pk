#!/bin/sh

# HW supported by nwfermi driver for some reason is not listed by 'xinput_calibrator' so we need to add relevant bindings to Chrome manually:
tdev=`xinput | grep -i Nextwindow | cut -d= -f2 | cut -d[ -f1`

if [ "$tdev" ]; then
    grep -q touch-devices $chflags || echo "--touch-devices=$tdev" >> $chflags
fi
