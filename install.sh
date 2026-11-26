#!/usr/bin/env bash

set -euo pipefail

if ((EUID != 0)); then
    printf 'Please run this script as root (for example, with sudo).\n' >&2
    exit 1
fi

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
BIN_DIR=/usr/local/bin
APPLICATIONS_DIR=/usr/local/share/applications

if [[ ! -f "$SCRIPT_DIR/xfreerdp-gui" || ! -f "$SCRIPT_DIR/xfreerdp-gui.desktop" ]]; then
    printf 'The launcher or desktop entry is missing from %s.\n' "$SCRIPT_DIR" >&2
    exit 1
fi

install -d -m 755 "$BIN_DIR" "$APPLICATIONS_DIR"
install -m 755 "$SCRIPT_DIR/xfreerdp-gui" "$BIN_DIR/xfreerdp-gui"
install -m 644 "$SCRIPT_DIR/xfreerdp-gui.desktop" "$APPLICATIONS_DIR/xfreerdp-gui.desktop"

printf 'XFreeRDP GUI installed to %s.\n' "$BIN_DIR"
