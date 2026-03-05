#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────
# setup-gas-project.sh — Automate GAS project file creation
#
# Creates all files needed for a new GAS project:
#   - HTML embedding page (from GasTemplate.html)
#   - .gs script (from gas-template.gs)
#   - .config.json
#   - Version files (html + gs)
#   - Changelogs (html + gs, plus archives)
#   - Deployment changelog copy
#   - GAS Projects table registration
#
# Usage:
#   bash scripts/setup-gas-project.sh <<'CONFIG'
#   { "PROJECT_ENVIRONMENT_NAME": "myapp", "TITLE": "My App", ... }
#   CONFIG
#
#   bash scripts/setup-gas-project.sh config.json
#
# After running: Claude handles ARCHITECTURE.md, README.md tree,
# STATUS.md, and commit/push.
# ──────────────────────────────────────────────────────────────────
set -euo pipefail

# ── Repo root ────────────────────────────────────────────────────
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

# ── Color helpers ────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}[INFO]${NC} $*"; }
ok()    { echo -e "${GREEN}[OK]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
err()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }

# ── Phase 0: Parse Input ────────────────────────────────────────
info "Phase 0: Parsing input..."

JSON_INPUT=""
if [ $# -ge 1 ] && [ -f "$1" ]; then
    JSON_INPUT="$(cat "$1")"
    info "Reading config from file: $1"
elif ! [ -t 0 ]; then
    JSON_INPUT="$(cat)"
    info "Reading config from stdin"
else
    err "No input provided. Pipe JSON via stdin or pass a config file path."
    echo ""
    echo "Usage:"
    echo "  bash scripts/setup-gas-project.sh <<'CONFIG'"
    echo '  { "PROJECT_ENVIRONMENT_NAME": "myapp", "TITLE": "My App", ... }'
    echo "  CONFIG"
    echo ""
    echo "  bash scripts/setup-gas-project.sh config.json"
    exit 1
fi

# Parse JSON fields using Python (already a dependency for QR codes)
parse_json() {
    python3 -c "
import json, sys
data = json.loads(sys.stdin.read())
key = sys.argv[1]
default = sys.argv[2] if len(sys.argv) > 2 else ''
print(data.get(key, default))
" "$@" <<< "$JSON_INPUT"
}

ENV_NAME="$(parse_json PROJECT_ENVIRONMENT_NAME)"
TITLE="$(parse_json TITLE 'CHANGE THIS PROJECT TITLE GAS TEMPLATE')"
DEPLOYMENT_ID="$(parse_json DEPLOYMENT_ID 'YOUR_DEPLOYMENT_ID')"
SPREADSHEET_ID="$(parse_json SPREADSHEET_ID 'YOUR_SPREADSHEET_ID')"
SHEET_NAME="$(parse_json SHEET_NAME 'Live_Sheet')"
SOUND_FILE_ID="$(parse_json SOUND_FILE_ID '')"
SPLASH_LOGO_URL="$(parse_json SPLASH_LOGO_URL 'https://www.shadowaisolutions.com/SAIS_Logo.png')"

if [ -z "$ENV_NAME" ]; then
    err "PROJECT_ENVIRONMENT_NAME is required and cannot be empty."
    exit 1
fi

# ── Auto-detect repo info ───────────────────────────────────────
REMOTE_URL="$(git remote get-url origin 2>/dev/null || echo '')"
GITHUB_OWNER="$(echo "$REMOTE_URL" | sed -E 's|.*[:/]([^/]+)/[^/]+(\.git)?$|\1|')"
GITHUB_REPO="$(echo "$REMOTE_URL" | sed -E 's|.*[:/][^/]+/([^/]+?)(\.git)?$|\1|')"
GITHUB_BRANCH="main"

# ── Derive project directory name ────────────────────────────────
# Capitalize first letter of each segment separated by _ or -
# e.g. test_link → TestLink, my-app → MyApp
derive_project_dir() {
    echo "$1" | sed -E 's/(^|[_-])([a-z])/\U\2/g' | sed 's/[_-]//g'
}

PROJECT_DIR="$(derive_project_dir "$ENV_NAME")"

info "Environment name: $ENV_NAME"
info "Project directory: $PROJECT_DIR"
info "Title: $TITLE"
info "GitHub: $GITHUB_OWNER/$GITHUB_REPO (branch: $GITHUB_BRANCH)"

# ── Path constants ───────────────────────────────────────────────
HTML_PAGE="live-site-pages/${ENV_NAME}.html"
HTML_VERSION="live-site-pages/${ENV_NAME}html.version.txt"
GAS_DIR="googleAppsScripts/${PROJECT_DIR}"
GAS_FILE="${GAS_DIR}/${ENV_NAME}.gs"
GAS_CONFIG="${GAS_DIR}/${ENV_NAME}.config.json"
GAS_VERSION="${GAS_DIR}/${ENV_NAME}gs.version.txt"
CL_DIR="repository-information/changelogs"
HTML_CL="${CL_DIR}/${ENV_NAME}html.changelog.md"
HTML_CL_ARCHIVE="${CL_DIR}/${ENV_NAME}html.changelog-archive.md"
GAS_CL="${CL_DIR}/${ENV_NAME}gs.changelog.md"
GAS_CL_ARCHIVE="${CL_DIR}/${ENV_NAME}gs.changelog-archive.md"
HTML_CL_DEPLOY="live-site-pages/${ENV_NAME}html.changelog.txt"
GAS_SCRIPTS_RULES=".claude/rules/gas-scripts.md"

# ── Template sources ─────────────────────────────────────────────
TPL_HTML="live-site-templates/GasTemplate.html"
TPL_GS="googleAppsScripts/GasTemplate/gas-template.gs"
TPL_CFG="googleAppsScripts/GasTemplate/gas-template.config.json"

# ── Phase 1: Pre-flight Checks ──────────────────────────────────
info "Phase 1: Pre-flight checks..."

for f in "$TPL_HTML" "$TPL_GS" "$TPL_CFG"; do
    if [ ! -f "$f" ]; then
        err "Template file not found: $f"
        exit 1
    fi
done
ok "Template files exist"

# Check if project already exists
UPDATE_MODE=false
if [ -f "$HTML_PAGE" ] || [ -d "$GAS_DIR" ] || [ -f "$GAS_CONFIG" ]; then
    UPDATE_MODE=true
    warn "Project already exists — switching to UPDATE mode"
    warn "Will sync config values into existing files without recreating"
fi

if [ "$UPDATE_MODE" = true ]; then
    # ── Update Mode ──────────────────────────────────────────────
    info "Updating existing project: $ENV_NAME"

    # Update config.json
    if [ -f "$GAS_CONFIG" ]; then
        cat > "$GAS_CONFIG" <<CFGEOF
{
  "TITLE": "${TITLE}",
  "DEPLOYMENT_ID": "${DEPLOYMENT_ID}",
  "SPREADSHEET_ID": "${SPREADSHEET_ID}",
  "SHEET_NAME": "${SHEET_NAME}",
  "SOUND_FILE_ID": "${SOUND_FILE_ID}"
}
CFGEOF
        ok "Updated $GAS_CONFIG"
    fi

    # Update .gs file config vars
    if [ -f "$GAS_FILE" ]; then
        sed -i "s|var TITLE = .*;|var TITLE = \"${TITLE}\";|" "$GAS_FILE"
        sed -i "s|var DEPLOYMENT_ID = .*;|var DEPLOYMENT_ID = \"${DEPLOYMENT_ID}\";|" "$GAS_FILE"
        sed -i "s|var SPREADSHEET_ID = .*;|var SPREADSHEET_ID = \"${SPREADSHEET_ID}\";|" "$GAS_FILE"
        sed -i "s|var SHEET_NAME     = .*;|var SHEET_NAME     = \"${SHEET_NAME}\";|" "$GAS_FILE"
        sed -i "s|var SOUND_FILE_ID = .*;|var SOUND_FILE_ID = \"${SOUND_FILE_ID}\";|" "$GAS_FILE"
        ok "Updated config vars in $GAS_FILE"
    fi

    # Update HTML page title and var _e
    if [ -f "$HTML_PAGE" ]; then
        # Update <title>
        sed -i "s|<title>.*</title>|<title>${TITLE}</title>|" "$HTML_PAGE"

        # Update var _e (encoded deployment URL)
        if [ "$DEPLOYMENT_ID" != "YOUR_DEPLOYMENT_ID" ] && [ -n "$DEPLOYMENT_ID" ]; then
            ENCODED=$(echo -n "https://script.google.com/macros/s/${DEPLOYMENT_ID}/exec" | rev | base64 -w0)
            sed -i "s|var _e = '[^']*';|var _e = '${ENCODED}';|" "$HTML_PAGE"
        else
            sed -i "s|var _e = '[^']*';|var _e = '';|" "$HTML_PAGE"
        fi
        ok "Updated $HTML_PAGE"
    fi

    echo ""
    ok "Update complete. Files modified:"
    [ -f "$GAS_CONFIG" ] && echo "  - $GAS_CONFIG"
    [ -f "$GAS_FILE" ] && echo "  - $GAS_FILE"
    [ -f "$HTML_PAGE" ] && echo "  - $HTML_PAGE"
    exit 0
fi

# ── Create Mode ──────────────────────────────────────────────────
info "Creating new project: $ENV_NAME"
echo ""

# ── Phase 2: Create Directory Structure ──────────────────────────
info "Phase 2: Creating directories..."
mkdir -p "$GAS_DIR"
mkdir -p "live-site-pages/sounds"
ok "Directories created"

# ── Phase 3: Copy & Substitute Templates ─────────────────────────
info "Phase 3: Copying and substituting templates..."

# --- HTML page ---
cp "$TPL_HTML" "$HTML_PAGE"
sed -i "s|CHANGE THIS PROJECT TITLE TEMPLATE|${TITLE}|g" "$HTML_PAGE"

# Set meta build-version (should already be v01.00w from template, but ensure)
sed -i 's|<meta name="build-version" content="[^"]*">|<meta name="build-version" content="v01.00w">|' "$HTML_PAGE"

# Update splash logo URL if provided and different from default
if [ "$SPLASH_LOGO_URL" != "YOUR_SPLASH_LOGO_URL" ] && [ -n "$SPLASH_LOGO_URL" ]; then
    sed -i "s|var DEVELOPER_LOGO_URL = '[^']*';|var DEVELOPER_LOGO_URL = '${SPLASH_LOGO_URL}';|" "$HTML_PAGE"
fi

# Encode and set var _e (deployment URL)
if [ "$DEPLOYMENT_ID" != "YOUR_DEPLOYMENT_ID" ] && [ -n "$DEPLOYMENT_ID" ]; then
    ENCODED=$(echo -n "https://script.google.com/macros/s/${DEPLOYMENT_ID}/exec" | rev | base64 -w0)
    sed -i "s|var _e = '[^']*';|var _e = '${ENCODED}';|" "$HTML_PAGE"
else
    sed -i "s|var _e = '[^']*';|var _e = '';|" "$HTML_PAGE"
fi
ok "Created $HTML_PAGE"

# --- GAS script ---
cp "$TPL_GS" "$GAS_FILE"
# Reset VERSION to initial
sed -i 's|var VERSION = "[^"]*";|var VERSION = "01.00g";|' "$GAS_FILE"
# Set config-tracked variables
sed -i "s|var TITLE = .*;|var TITLE = \"${TITLE}\";|" "$GAS_FILE"
sed -i "s|var DEPLOYMENT_ID = .*;|var DEPLOYMENT_ID = \"${DEPLOYMENT_ID}\";|" "$GAS_FILE"
sed -i "s|var SPREADSHEET_ID = .*;|var SPREADSHEET_ID = \"${SPREADSHEET_ID}\";|" "$GAS_FILE"
sed -i "s|var SHEET_NAME     = .*;|var SHEET_NAME     = \"${SHEET_NAME}\";|" "$GAS_FILE"
sed -i "s|var SOUND_FILE_ID = .*;|var SOUND_FILE_ID = \"${SOUND_FILE_ID}\";|" "$GAS_FILE"
# Set repo-derived variables
sed -i "s|var GITHUB_OWNER  = .*;|var GITHUB_OWNER  = \"${GITHUB_OWNER}\";|" "$GAS_FILE"
sed -i "s|var GITHUB_REPO   = .*;|var GITHUB_REPO   = \"${GITHUB_REPO}\";|" "$GAS_FILE"
sed -i "s|var GITHUB_BRANCH = .*;|var GITHUB_BRANCH = \"${GITHUB_BRANCH}\";|" "$GAS_FILE"
sed -i "s|var FILE_PATH     = .*;|var FILE_PATH     = \"${GAS_FILE}\";|" "$GAS_FILE"
EMBED_URL="https://${GITHUB_OWNER}.github.io/${GITHUB_REPO}/${ENV_NAME}.html"
sed -i "s|var EMBED_PAGE_URL = .*;|var EMBED_PAGE_URL = \"${EMBED_URL}\";|" "$GAS_FILE"
if [ "$SPLASH_LOGO_URL" != "YOUR_SPLASH_LOGO_URL" ] && [ -n "$SPLASH_LOGO_URL" ]; then
    sed -i "s|var SPLASH_LOGO_URL = .*;|var SPLASH_LOGO_URL = \"${SPLASH_LOGO_URL}\";|" "$GAS_FILE"
fi
ok "Created $GAS_FILE"

# --- Config JSON ---
cat > "$GAS_CONFIG" <<CFGEOF
{
  "TITLE": "${TITLE}",
  "DEPLOYMENT_ID": "${DEPLOYMENT_ID}",
  "SPREADSHEET_ID": "${SPREADSHEET_ID}",
  "SHEET_NAME": "${SHEET_NAME}",
  "SOUND_FILE_ID": "${SOUND_FILE_ID}"
}
CFGEOF
ok "Created $GAS_CONFIG"

# ── Phase 4: Create Version Files ────────────────────────────────
info "Phase 4: Creating version files..."
echo -n '|v01.00w|' > "$HTML_VERSION"
echo -n '01.00g' > "$GAS_VERSION"
ok "Created $HTML_VERSION"
ok "Created $GAS_VERSION"

# ── Phase 5: Create Changelog Files ─────────────────────────────
info "Phase 5: Creating changelog files..."

# HTML changelog
cat > "$HTML_CL" <<CLEOF
# Changelog — ${TITLE}

All notable user-facing changes to this page are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Older sections are rotated to [${ENV_NAME}html.changelog-archive.md](${ENV_NAME}html.changelog-archive.md) when this file exceeds 50 version sections.

\`Sections: 0/50\`

## [Unreleased]

*(No changes yet)*

Developed by: ShadowAISolutions
CLEOF
ok "Created $HTML_CL"

# HTML changelog archive
cat > "$HTML_CL_ARCHIVE" <<CLEOF
# Changelog Archive — ${TITLE}

Older version sections rotated from [${ENV_NAME}html.changelog.md](${ENV_NAME}html.changelog.md). Full granularity preserved — entries are moved here verbatim when the main changelog exceeds 50 version sections.

## Rotation Logic

Same rotation logic as the repository changelog archive — see [CHANGELOG-archive.md](../CHANGELOG-archive.md) for the full procedure. In brief: count version sections, skip if ≤50, never rotate today's sections, rotate the oldest full date group together.

---

*(No archived sections yet)*

Developed by: ShadowAISolutions
CLEOF
ok "Created $HTML_CL_ARCHIVE"

# GAS changelog
cat > "$GAS_CL" <<CLEOF
# Changelog — ${TITLE} (Google Apps Script)

All notable user-facing changes to this script are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Older sections are rotated to [${ENV_NAME}gs.changelog-archive.md](${ENV_NAME}gs.changelog-archive.md) when this file exceeds 50 version sections.

\`Sections: 0/50\`

## [Unreleased]

*(No changes yet)*

Developed by: ShadowAISolutions
CLEOF
ok "Created $GAS_CL"

# GAS changelog archive
cat > "$GAS_CL_ARCHIVE" <<CLEOF
# Changelog Archive — ${TITLE} (Google Apps Script)

Older version sections rotated from [${ENV_NAME}gs.changelog.md](${ENV_NAME}gs.changelog.md). Full granularity preserved — entries are moved here verbatim when the main changelog exceeds 50 version sections.

## Rotation Logic

Same rotation logic as the repository changelog archive — see [CHANGELOG-archive.md](../CHANGELOG-archive.md) for the full procedure. In brief: count version sections, skip if ≤50, never rotate today's sections, rotate the oldest full date group together.

---

*(No archived sections yet)*

Developed by: ShadowAISolutions
CLEOF
ok "Created $GAS_CL_ARCHIVE"

# Deployment changelog copy
cp "$HTML_CL" "$HTML_CL_DEPLOY"
ok "Created $HTML_CL_DEPLOY"

# ── Phase 6: Register in GAS Projects Table ──────────────────────
info "Phase 6: Registering in GAS Projects table..."

TABLE_ROW="| ${PROJECT_DIR} | \`${GAS_FILE}\` | \`${GAS_CONFIG}\` | \`${HTML_PAGE}\` |"

if grep -q "| ${PROJECT_DIR} |" "$GAS_SCRIPTS_RULES" 2>/dev/null; then
    warn "Project ${PROJECT_DIR} already registered in GAS Projects table — skipping"
else
    # Find the last row of the table (line starting with |, not the header separator)
    LAST_TABLE_LINE=$(grep -n '^| ' "$GAS_SCRIPTS_RULES" | grep -v '|---' | tail -1 | cut -d: -f1)
    if [ -n "$LAST_TABLE_LINE" ]; then
        sed -i "${LAST_TABLE_LINE}a\\${TABLE_ROW}" "$GAS_SCRIPTS_RULES"
        ok "Registered ${PROJECT_DIR} in GAS Projects table"
    else
        warn "Could not find GAS Projects table — manual registration needed"
    fi
fi

# ── Phase 7: Sounds Directory ────────────────────────────────────
info "Phase 7: Ensuring sounds directory..."
if [ -f "live-site-pages/sounds/Website_Ready_Voice_1.mp3" ]; then
    ok "Sounds directory already populated"
else
    warn "Sound file not found — live-site-pages/sounds/Website_Ready_Voice_1.mp3 missing"
fi

# ── Phase 8: Verification ────────────────────────────────────────
info "Phase 8: Verification..."
echo ""

ERRORS=0

# Check all expected files exist
EXPECTED_FILES=(
    "$HTML_PAGE"
    "$HTML_VERSION"
    "$GAS_FILE"
    "$GAS_CONFIG"
    "$GAS_VERSION"
    "$HTML_CL"
    "$HTML_CL_ARCHIVE"
    "$GAS_CL"
    "$GAS_CL_ARCHIVE"
    "$HTML_CL_DEPLOY"
)

for f in "${EXPECTED_FILES[@]}"; do
    if [ -f "$f" ]; then
        ok "  $f"
    else
        err "  MISSING: $f"
        ERRORS=$((ERRORS + 1))
    fi
done

# Check for remaining template placeholders in new files
echo ""
info "Checking for remaining template placeholders..."
PLACEHOLDER_CHECK=$(grep -rn "CHANGE THIS PROJECT TITLE TEMPLATE\|gas-template\.gs\|GasTemplate/" \
    "$HTML_PAGE" "$GAS_FILE" "$GAS_CONFIG" 2>/dev/null || true)

if [ -n "$PLACEHOLDER_CHECK" ]; then
    warn "Remaining template references found (may need manual review):"
    echo "$PLACEHOLDER_CHECK"
else
    ok "No template placeholders found in new files"
fi

# ── Summary ──────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ "$ERRORS" -eq 0 ]; then
    echo -e "${GREEN}✓ Project '${ENV_NAME}' created successfully (${#EXPECTED_FILES[@]} files)${NC}"
else
    echo -e "${RED}✗ Project creation completed with ${ERRORS} error(s)${NC}"
fi
echo ""
echo "Files created:"
for f in "${EXPECTED_FILES[@]}"; do
    echo "  $f"
done
echo ""
echo "Registered as: ${PROJECT_DIR} in GAS Projects table"
echo ""
echo "Claude still needs to update:"
echo "  - repository-information/ARCHITECTURE.md (Mermaid diagram)"
echo "  - README.md (ASCII structure tree)"
echo "  - repository-information/STATUS.md (version tracking)"
echo "  - Pre-Commit checklist + commit + push"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

exit "$ERRORS"
# Developed by: ShadowAISolutions
