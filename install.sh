#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Install script for git-upload-anything
# -----------------------------------------------------------------------------

set -euo pipefail

TARGET="/usr/local/bin/git-upload-anything"

echo "[INFO] Copying script to $TARGET ..."
sudo cp git-upload-anything.sh "$TARGET"

echo "[INFO] Making $TARGET executable..."
chmod +x $TARGET

echo "[INFO] Installation complete! You can now run:"
echo "      git-upload-anything --help"
