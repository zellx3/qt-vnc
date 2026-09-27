# qt-vnc

A minimal Qt6/QML app, set up to build and run inside GitHub Codespaces with
its window viewable in a browser over VNC.

## Open in a Codespace

Click **Code → Codespaces → Create codespace on main**. The devcontainer
builds an Ubuntu 24.04 image with Qt6, build tools, and a virtual X11 desktop
(Xvfb + fluxbox + x11vnc + noVNC), then starts that desktop automatically.

## Build

```bash
cmake --preset default
cmake --build --preset default
```

The binary is produced at `build/qt_vnc_app`.

## Run the GUI

The container runs a virtual display on `:1`, exposed over noVNC. Any new
terminal already has `DISPLAY=:1` exported; if not:

```bash
DISPLAY=:1 ./build/qt_vnc_app
```

Open the app's window from your local machine: in the Codespace's **Ports**
tab, find port `6080` ("VNC Desktop") and open it in a browser. That's a
noVNC client connected to the container's virtual desktop — the running app
window appears there and is fully interactive (click, type, resize).

## Troubleshooting

- **`qt.qpa.plugin: Could not load the Qt platform plugin "xcb"`** — force the
  platform explicitly: `QT_QPA_PLATFORM=xcb DISPLAY=:1 ./build/qt_vnc_app`.
  Add `QT_DEBUG_PLUGINS=1` to see which shared library is failing to load.
- **Blank/black noVNC page** — the VNC stack starts via `postStartCommand`
  (`.devcontainer/start-vnc.sh`), which only runs once the container has
  fully started; wait a few seconds and reload. Check `/tmp/x11vnc.log` and
  `/tmp/websockify.log` inside the container if it persists.
- **Window doesn't appear** — confirm `DISPLAY` is set (`echo $DISPLAY` →
  `:1`) in the terminal you launched the app from.

## Notes

- Qt6 comes from Ubuntu 24.04's apt packages (Qt 6.4), matching this
  project's `find_package(Qt6 6.4 ...)`. If a newer Qt6 minor version is ever
  required, switch to [aqtinstall](https://github.com/miurahr/aqtinstall)
  in the Dockerfile instead of building Qt from source.
- `x11vnc` runs with `-nopw` (no VNC password) since the port is only
  reachable through Codespaces' authenticated port forwarding, not directly
  from the internet.
