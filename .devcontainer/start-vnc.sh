#!/usr/bin/env bash
# Idempotent: safe to re-run (e.g. on every Codespace resume via postStartCommand).
set -euo pipefail

DISPLAY_NUM=1
export DISPLAY=":${DISPLAY_NUM}"

# Make DISPLAY available to every future terminal in this container.
grep -qxF 'export DISPLAY=:1' /etc/bash.bashrc || echo 'export DISPLAY=:1' >> /etc/bash.bashrc

if ! pgrep -f "Xvfb :${DISPLAY_NUM}" >/dev/null; then
  Xvfb ":${DISPLAY_NUM}" -screen 0 1280x800x24 &
  sleep 1
fi

if ! pgrep -x fluxbox >/dev/null; then
  fluxbox >/tmp/fluxbox.log 2>&1 &
fi

if ! pgrep -x x11vnc >/dev/null; then
  x11vnc -display ":${DISPLAY_NUM}" -forever -shared -nopw -rfbport 5900 >/tmp/x11vnc.log 2>&1 &
fi

if ! pgrep -f "websockify.*6080" >/dev/null; then
  websockify --web=/usr/share/novnc 6080 localhost:5900 >/tmp/websockify.log 2>&1 &
fi

echo "VNC desktop ready on DISPLAY=:${DISPLAY_NUM}, noVNC on port 6080"
