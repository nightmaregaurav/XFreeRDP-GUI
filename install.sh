#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

echo "Copying xfreerdp-gui to /bin directory..."
cp ./xfreerdp-gui /bin/xfreerdp-gui
chmod 755 /bin/xfreerdp-gui
echo "Done."

echo "Copying xfreerdp-gui.desktop to /usr/share/applications directory..."
cp ./xfreerdp-gui.desktop /usr/share/applications/xfreerdp-gui.desktop
chmod 755 /usr/share/applications/xfreerdp-gui.desktop
echo "Done."

echo "Installation completed successfully."
