#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

echo "Removing xfreerdp-gui from /bin directory..."
rm -f /bin/xfreerdp-gui
echo "Done."

echo "Removing xfreerdp-gui.desktop from /usr/share/applications directory..."
rm -f /usr/share/applications/xfreerdp-gui.desktop
echo "Done."

echo "Uninstallation completed successfully."
