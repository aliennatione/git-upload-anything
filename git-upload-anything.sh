#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# git-upload-anything
# -----------------------------------------------------------------------------
# Uploads any local directory or zip file to a new GitHub repository automatically
# -----------------------------------------------------------------------------
# Requirements: bash, curl, unzip, git, gh (GitHub CLI)
# Tested on: Termux, Ubuntu/Debian, Arch, macOS
# -----------------------------------------------------------------------------

set -euo pipefail

# --------------------- Help ---------------------
show_help() {
cat <<EOF
Usage: git-upload-anything [OPTIONS]

Options:
  --source <path>    Path to folder or zip file to upload
  --repo <name>      Repository name to create on GitHub
  --private          Make repository private (default: public)
  --cleanup          Remove temporary files after upload
  --help             Show this help and exit

Examples:
  ./git-upload-anything.sh --source ./myapp.zip --repo myapp --private
  ./git-upload-anything.sh --source ./folder --repo myrepo --cleanup
EOF
exit 0
}

# --------------------- Logging ---------------------
log() { echo -e "[INFO] $*"; }
err() { echo -e "[ERR] $*" >&2; exit 1; }

# --------------------- Parse CLI args ---------------------
SOURCE=""
REPO=""
PRIVATE=false
CLEANUP=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source) SOURCE="$2"; shift 2 ;;
    --repo) REPO="$2"; shift 2 ;;
    --private) PRIVATE=true; shift ;;
    --cleanup) CLEANUP=true; shift ;;
    --help) show_help ;;
    *) err "Unknown argument: $1" ;;
  esac
done

[[ -z "$SOURCE" || -z "$REPO" ]] && show_help

# --------------------- Dependency check ---------------------
check_dep() {
  local dep=$1
  if ! command -v "$dep" >/dev/null 2>&1; then
    echo "[WARN] Missing dependency: $dep"
    install_dep "$dep"
  fi
}

install_dep() {
  local dep=$1
  echo "[INFO] Installing $dep ..."
  if command -v pkg >/dev/null 2>&1; then
    pkg install -y "$dep"
  elif command -v apt >/dev/null 2>&1; then
    sudo apt update && sudo apt install -y "$dep"
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Sy "$dep" --noconfirm
  elif command -v brew >/dev/null 2>&1; then
    brew install "$dep"
  else
    err "No supported package manager found to install $dep"
  fi
}

for dep in git curl unzip; do
  check_dep "$dep"
done

# --------------------- Install GH if missing ---------------------
if ! command -v gh >/dev/null 2>&1; then
  log "Installing GitHub CLI..."
  if command -v brew >/dev/null 2>&1; then
    brew install gh
  else
    err "Automatic installation of gh not supported on this system. Install manually: https://cli.github.com/"
  fi
fi

# --------------------- Authenticate GH ---------------------
if ! gh auth status >/dev/null 2>&1; then
  log "GitHub CLI not authenticated. Starting login..."
  gh auth login
fi

# --------------------- Prepare workspace ---------------------
if [[ -f "$SOURCE" && "$SOURCE" == *.zip ]]; then
  TMP_DIR=$(mktemp -d)
  log "Extracting zip: $SOURCE -> $TMP_DIR"
  unzip -q "$SOURCE" -d "$TMP_DIR"
  cd "$TMP_DIR"
elif [[ -d "$SOURCE" ]]; then
  cd "$SOURCE"
else
  err "Invalid source: $SOURCE"
fi

# --------------------- Git & GH setup ---------------------
log "Initializing git repo in $(pwd)"
git init -q
git add .
git commit -m "Initial commit from git-upload-anything" >/dev/null

REPO_VISIBILITY="public"
$PRIVATE && REPO_VISIBILITY="private"

log "Creating GitHub repository '$REPO' ($REPO_VISIBILITY)"
gh repo create "$REPO" --"$REPO_VISIBILITY" --source=. --remote=origin --push || {
  err "Failed to create/push repo. Check GH authentication or name conflicts."
}

# --------------------- Cleanup ---------------------
if $CLEANUP; then
  log "Cleaning up temporary files..."
  [[ -n "${TMP_DIR:-}" ]] && rm -rf "$TMP_DIR"
fi

log "✅ Repository '$REPO' successfully uploaded to GitHub!"
