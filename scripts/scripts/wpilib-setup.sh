#!/usr/bin/env bash
# Install WPILib tools on NixOS without the GUI installer.
#
# The official WPILibInstaller is a .NET Avalonia GUI that needs icu/libICE
# and other FHS libs NixOS doesn't provide out of the box, so instead this
# script replicates what the installer does for the tools payload:
#   1. extracts the inner -artifacts.tar.gz from the WPILib_Linux tarball
#      into ~/wpilib/<YEAR>/
#   2. runs ToolsUpdater.jar with the bundled JDK (runs natively, no FHS)
#      to unpack Glass/SysId/DataLogTool/etc. into ~/wpilib/<YEAR>/tools/
#
# The FHS environment for *running* the GUI tools lives in RainMaker26's
# flake.nix (packages.wpilib-fhs), not here -- this script only lays down
# the ~/wpilib/<YEAR> tree that the FHS env expects.
#
# Usage:
#   wpilib-setup.sh [path-to-tarball]
#   WPILIB_TARBALL=~/Downloads/WPILib_Linux-2026.2.1.tar.gz wpilib-setup.sh
#
# Safe to re-run: re-extracts and re-runs ToolsUpdater idempotently.
set -euo pipefail

TARBALL="${1:-${WPILIB_TARBALL:-}}"
if [[ -z "$TARBALL" ]]; then
  # Auto-pick the newest WPILib Linux tarball in Downloads.
  TARBALL="$(ls -t ~/Downloads/WPILib_Linux-*.tar.gz 2>/dev/null | head -n1 || true)"
fi
if [[ -z "${TARBALL:-}" || ! -f "$TARBALL" ]]; then
  echo "error: no WPILib tarball found." >&2
  echo "Download WPILib_Linux-<ver>.tar.gz from https://github.com/wpilibsuite/allwpilib/releases" >&2
  echo "into ~/Downloads/ (or pass its path as \$1)." >&2
  exit 1
fi

echo "Using tarball: $TARBALL"

# Find the inner artifacts tarball and the version file inside the outer tar.
INNER="$(tar tzf "$TARBALL" | grep -E 'artifacts\.tar\.gz$' | head -n1)"
VERSION_FILE="$(tar tzf "$TARBALL" | grep -E 'WPILibInstallerVersion\.txt$' | head -n1)"
if [[ -z "$INNER" || -z "$VERSION_FILE" ]]; then
  echo "error: $TARBALL doesn't look like a WPILib_Linux release tarball." >&2
  exit 1
fi
VERSION="$(tar xOzf "$TARBALL" "$VERSION_FILE" | tr -d '[:space:]')"
YEAR="${VERSION%%.*}"
DEST="$HOME/wpilib/$YEAR"

echo "WPILib version: $VERSION -> install dir: $DEST"
mkdir -p "$DEST"

echo "Extracting tools/JDK/maven payload (takes a bit, ~4-5G)..."
tar xzf "$TARBALL" -O "$INNER" | tar xz -C "$DEST"

UPDATER="$DEST/tools/ToolsUpdater.jar"
BUNDLED_JAVA="$DEST/jdk/bin/java"
if [[ ! -f "$UPDATER" ]]; then
  echo "error: $UPDATER missing after extraction." >&2
  exit 1
fi
if [[ ! -x "$BUNDLED_JAVA" ]]; then
  echo "error: bundled JDK missing at $BUNDLED_JAVA." >&2
  exit 1
fi

echo "Running ToolsUpdater (unpacks Glass/SysId/DataLogTool/... into tools/)..."
"$BUNDLED_JAVA" -jar "$UPDATER"

echo "Verifying..."
missing=0
for t in tools/glass tools/sysid tools/datalogtool tools/outlineviewer \
         elastic/elastic_dashboard advantagescope/advantagescope-wpilib utility/wpilibutility; do
  if [[ -e "$DEST/$t" ]]; then
    echo "  ok: $t"
  else
    echo "  MISSING: $t"
    missing=1
  fi
done
if ((missing)); then
  echo "error: some tools are missing, check output above." >&2
  exit 1
fi

cat <<EOF

WPILib $VERSION tools installed to $DEST.

Next (from ~/RainMaker26, whose flake.nix provides the FHS env):
  nix run .#wpilib-fhs -- -c '~/wpilib/$YEAR/tools/glass &'
  nix run .#wpilib-fhs -- -c '~/wpilib/$YEAR/elastic/elastic_dashboard &'
  nix run .#wpilib-fhs -- -c '~/wpilib/$YEAR/advantagescope/advantagescope-wpilib &'
  nix run .#wpilib-fhs   # FHS bash; run tools directly
EOF
