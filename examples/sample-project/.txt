## **Struttura del nuovo repository**

```
git-upload-anything-ci/
├── README.md
├── LICENSE
├── git-upload-anything.sh
├── install.sh
├── .gitignore
├── examples/
│   └── sample-project/
│       └── main.txt
├── docs/
│   └── usage.md
└── .github/
    └── workflows/
        └── ci-upload.yml
```

---

## **1️⃣ git-upload-anything.sh** (versione CI/CD pronta)

```bash
#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# git-upload-anything (CI/CD version)
# -----------------------------------------------------------------------------
# Uploads a folder or zip to a new GitHub repo using a provided token
# Non-interactive authentication suitable for CI/CD
# -----------------------------------------------------------------------------

set -euo pipefail

show_help() {
cat <<EOF
Usage: git-upload-anything.sh [OPTIONS]

Options:
  --source <path>       Path to folder or zip file
  --repo <name>         GitHub repo name to create
  --private             Make repository private
  --cleanup             Remove temporary files after upload
  --token <token>       GitHub Personal Access Token (required in CI)
  --help                Show this help

Examples:
  ./git-upload-anything.sh --source ./myapp.zip --repo myapp --private --token \$GH_TOKEN
EOF
exit 0
}

log() { echo -e "[INFO] $*"; }
err() { echo -e "[ERR] $*" >&2; exit 1; }

# --------------------- Parse args ---------------------
SOURCE=""
REPO=""
PRIVATE=false
CLEANUP=false
TOKEN=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source) SOURCE="$2"; shift 2 ;;
    --repo) REPO="$2"; shift 2 ;;
    --private) PRIVATE=true; shift ;;
    --cleanup) CLEANUP=true; shift ;;
    --token) TOKEN="$2"; shift 2 ;;
    --help) show_help ;;
    *) err "Unknown argument: $1" ;;
  esac
done

[[ -z "$SOURCE" || -z "$REPO" ]] && show_help
[[ -z "$TOKEN" ]] && err "GitHub token required in CI/CD (--token <token>)"

# --------------------- Dependencies ---------------------
for dep in git curl unzip gh; do
  command -v $dep >/dev/null 2>&1 || err "Missing dependency: $dep"
done

# --------------------- Authenticate GH ---------------------
echo "$TOKEN" | gh auth login --with-token >/dev/null

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
  err "Failed to create/push repo"
}

# --------------------- Cleanup ---------------------
if $CLEANUP && [[ -n "${TMP_DIR:-}" ]]; then
  log "Cleaning up temporary files..."
  rm -rf "$TMP_DIR"
fi

log "✅ Repository '$REPO' successfully uploaded!"
```

---

## **2️⃣ install.sh**

```bash
#!/usr/bin/env bash
# Install script for git-upload-anything-ci

set -euo pipefail

TARGET="/usr/local/bin/git-upload-anything"

chmod +x git-upload-anything.sh
sudo cp git-upload-anything.sh "$TARGET"

echo "[INFO] Installation complete! Run 'git-upload-anything --help'"
```

---

## **3️⃣ README.md**

````markdown
# git-upload-anything-ci

Automated script to upload any folder or zip to a new GitHub repo, ready for CI/CD.

## Features

- Non-interactive CI/CD support with token
- Works with folders or zip files
- Can create public/private repos
- Cleanup temporary files
- GitHub Actions workflow included

## Usage

```bash
git-upload-anything --source ./project.zip --repo MyRepo --private --token $GH_TOKEN
````

---

## GitHub Actions

See `.github/workflows/ci-upload.yml` for example workflow.

````

---

## **4️⃣ LICENSE** (MIT)

```text
MIT License

Copyright (c) 2025

Permission is hereby granted, free of charge, to any person obtaining a copy
...
````

---

## **5️⃣ .gitignore**

```
*.zip
*.tmp
*.log
```

---

## **6️⃣ examples/sample-project/main.txt**

```
Hello World
Sample project for git-upload-anything-ci
```

---

## **7️⃣ docs/usage.md**

````markdown
# git-upload-anything CI/CD Usage

1. Make script executable
```bash
chmod +x git-upload-anything.sh
````

2. Run locally with token

```bash
git-upload-anything.sh --source ./examples/sample-project --repo MyRepo --private --token $GH_TOKEN
```

3. Or use GitHub Actions workflow

````

---

## **8️⃣ .github/workflows/ci-upload.yml**

```yaml
name: Auto Upload Repo

on:
  workflow_dispatch:
  push:
    branches:
      - main

jobs:
  upload:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Setup dependencies
        run: sudo apt update && sudo apt install -y git unzip curl gh

      - name: Run upload script
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          chmod +x git-upload-anything.sh
          ./git-upload-anything.sh \
            --source ./examples/sample-project \
            --repo "auto-upload-${GITHUB_RUN_ID}" \
            --private \
            --cleanup \
            --token $GH_TOKEN
````

---

Questo repository ora è **completo**, pronto per:

* Installazione locale
* Uso in pipeline CI/CD
* Esempi e documentazione

