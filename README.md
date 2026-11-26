# XFreeRDP-GUI

A small Linux desktop front end for FreeRDP. It uses Bash and Zenity to collect connection details and launch `xfreerdp` (or `xfreerdp3`). It is not affiliated with or a replacement for the [FreeRDP project](https://www.freerdp.com/).

![Connection form](./Screenshot%20from%202024-02-09%2020-47-34.png)
![Feature selection](./Screenshot%20from%202024-02-09%2020-47-44.png)
![Save connection](./Screenshot%20from%202024-02-09%2020-47-51.png)
![Choose a saved connection](./Screenshot%20from%202024-02-09%2020-48-08.png)

## Requirements

- Linux with Bash
- Zenity
- FreeRDP with `xfreerdp` or `xfreerdp3`
- `base64`

## Install

Install FreeRDP and Zenity using your distribution's package manager, then run:

```sh
git clone https://github.com/nightmaregaurav/XFreeRDP-GUI.git
cd XFreeRDP-GUI
sudo bash ./install.sh
```

The installer places the launcher in `/usr/local/bin` and the desktop entry in `/usr/local/share/applications`. Start `xfreerdp-gui` from a terminal or your application menu.

## Usage

```text
xfreerdp-gui          Create a connection interactively
xfreerdp-gui --saved  Choose a saved profile
xfreerdp-gui --latest Use the most recently saved profile
xfreerdp-gui --recent Use the most recently used profile
xfreerdp-gui --help   Show help
```

Saved profiles contain the connection name, host, port, username, and selected options. Passwords are never saved; the password prompt appears when connecting to a saved profile. Credentials are sent to FreeRDP over standard input instead of being included in the process arguments or printed by this launcher. Profiles are stored with user-only permissions under `$XDG_CONFIG_HOME/xfreerdp-gui`, or `~/.config/xfreerdp-gui` when `XDG_CONFIG_HOME` is unset. Home-directory, clipboard, and microphone redirection are off by default and can be enabled in the feature list when needed.

Profiles created by older releases are not imported, because those files contain executable shell syntax. Recreate those profiles with the current version. Some FreeRDP versions cannot handle an interactive certificate-confirmation prompt while standard input is being used for credentials; use FreeRDP's supported certificate trust workflow before connecting, and do not disable certificate checks as a workaround.

## Uninstall

From the project directory, run `sudo bash ./uninstall.sh`. The launcher and desktop entry are removed; saved profiles are intentionally left in your user configuration directory.

## Development checks

Run the local shell tests with:

```sh
bash tests/test-xfreerdp-gui.sh
```

The project is licensed under GNU GPL v3; see [LICENSE](./LICENSE).
