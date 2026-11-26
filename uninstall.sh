#!/usr/bin/env bash

set -euo pipefail

if ((EUID != 0)); then
    printf 'Please run this script as root (for example, with sudo).\n' >&2
    exit 1
fi

rm -f \
    /usr/local/bin/xfreerdp-gui \
    /usr/local/share/applications/xfreerdp-gui.desktop \
    /bin/xfreerdp-gui \
    /usr/share/applications/xfreerdp-gui.desktop
printf 'XFreeRDP GUI has been uninstalled. Saved profiles were left untouched.\n'
