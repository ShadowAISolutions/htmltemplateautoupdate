# ​‌‌‌‌‌‌‌​​‌‌‌‌‌​Auto Update HTML Template

A GitHub Pages deployment framework with automatic version polling, auto-refresh, and Google Apps Script (GAS) embedding support.

Last updated: `2026-03-04 06:41:06 PM EST` · Repo version: `v02.69r`

You are currently using the **htmltemplateautoupdate** developed by **ShadowAISolutions**<br>
Initialize your repository and Claude will update the live site link and QR code here

**This Template Repository's URL:** [github.com/ShadowAISolutions/htmltemplateautoupdate](https://github.com/ShadowAISolutions/htmltemplateautoupdate)

<p align="center">
  <img src="repository-information/readme-qr-code.png" alt="QR code to template repo" width="200">
</p>

## Copy This Repository

### Method 1: Use This Template (Recommended)

> <sub>**Tip:** Link below navigates away from this page. `Shift + click` (or `Right-click` → `Open link in new window`) to keep this ReadMe visible while you work.</sub>

1. Click the green **Use this template** button at the top of this page, or go to [**Create from template**](https://github.com/new?template_name=htmltemplateautoupdate&template_owner=ShadowAISolutions)
2. Fill in the **Repository name** field with a descriptive name of your choice
3. Click **Create repository**

### Method 2: GitHub Importer

1. Click the `⧉` button below to copy this template's URL:

```
https://github.com/ShadowAISolutions/htmltemplateautoupdate
```

   > <sub>**Tip:** Link below navigates away from this page. `Shift + click` (or `Right-click` → `Open link in new window`) to keep this ReadMe visible while you work.</sub>

2. Go to [**GitHub Importer**](https://github.com/new/import) and paste what you just copied into the `The URL for your source repository *` field
3. Fill in the `Repository name *` field with a descriptive name of your choice
4. Click the green `Begin import` button

## Initialize This Template

> **Important:** The links in steps 1 and 2 below point to the settings of **whichever repo you are viewing this page from**. Make sure you are using the links below while on `YOUR OWN COPY` of the repository, not on the original template repo — otherwise the links will lead to a 404 page.

> <sub>**Tip:** Links below navigate away from this page. `Right-click` → `Open link in new window` to keep this ReadMe visible while you work.</sub>

### 1. Enable GitHub Pages

Go to your repository's [**Pages settings**](../../settings/pages) and configure:

- **Source**: Select **GitHub Actions** (not "Deploy from a branch")

  This allows the included workflow to deploy your `live-site-pages/` directory automatically.

### 2. Configure the `github-pages` Environment

Go to your repository's [**Environments settings**](../../settings/environments), click into the `github-pages` environment, and:

- Select the dropdown next to the **Deployment branches and tags** heading and choose **No restriction**

### 3. Run Claude Code and Type `initialize`

> The initialization process takes approximately **~5 minutes** from when you send `initialize` to when Claude has finished all its actions.

Open the repo with Claude Code and type **`initialize`** as your first prompt. Claude will automatically:

&emsp;Detect your new repo name and org<br>
&emsp;Update all references throughout the codebase<br>
&emsp;Replace the placeholder text above with your live site link<br>
&emsp;Commit and push — triggering the workflow to deploy to GitHub Pages

Your site will be live at `https://<your-org>.github.io/<your-repo>/`

## How It Works

### Auto-Refresh via Version Polling
Every hosted page polls a lightweight `html.version.txt` file every 10 seconds. When a new version is deployed, the page detects the mismatch and auto-reloads — showing a green "Website Ready" splash with audio feedback.

### CI/CD Auto-Merge Flow
1. Push to a `claude/*` branch
2. GitHub Actions automatically merges into `main`, deploys to GitHub Pages, and cleans up the branch
3. No pull requests needed — the workflow handles everything

### GAS Embedding Architecture
Google Apps Script projects are embedded as iframes in GitHub Pages. The framework handles:

&emsp;Automatic GAS deployment via `doPost` when `.gs` files change<br>
&emsp;"Code Ready" blue splash on GAS updates (client-side polling)<br>
&emsp;Google Sign-In from the parent page (stable OAuth origin)

## GCP Project Setup & Troubleshooting

> **Tip:** Links below navigate away from this page. **Ctrl + click** (or right-click → *Open in new tab*) to keep this ReadMe visible while you work.

Each GAS web app deployment requires a Google Cloud Platform (GCP) project. To set up:

1. Go to [Google Cloud Console](https://console.cloud.google.com/) → create a **new project**
2. **Critical**: set the project **Location** to your organization root or "No organization" — do **not** place it inside any managed folder
3. Copy the **project number** (not project ID) from the project dashboard
4. In the GCP project, enable the **Apps Script API**: APIs & Services → Library → search "Apps Script API" → Enable
5. In Apps Script, go to Project Settings (gear icon) → Google Cloud Platform (GCP) Project → Change project → paste the project number

### "You cannot switch to a Cloud Platform project in an Apps Script-managed folder"

This error occurs when the GCP project you're targeting lives inside Google's hidden `apps-script` managed folder (`organization → system-gsuite → apps-script`). Even projects created from [console.cloud.google.com](https://console.cloud.google.com/) can end up there on Workspace accounts.

**How to diagnose:**
1. Go to [Google Cloud Console → Manage Resources](https://console.cloud.google.com/cloud-resource-manager)
2. Look for a folder hierarchy: **your org → system-gsuite → apps-script**
3. If your GCP project is inside the `apps-script` folder, that's the problem

**How to fix — Option A (move the project):**

Moving a project out of the managed folder requires the **Project Mover** IAM role, which you likely don't have by default — even as the organization owner/admin.

1. Go to [IAM & Admin](https://console.cloud.google.com/iam-admin/iam) → use the top dropdown to select your **organization** (not a project or folder)
2. Click **Grant Access** → enter your own email
3. In "Select a role" → **Resource Manager** → **Project Mover** → **Save**
4. Go to [Manage Resources](https://console.cloud.google.com/cloud-resource-manager) → find your project inside the `apps-script` folder
5. Click the three-dot menu → **Migrate**
6. Move it to your organization root or "No organization"
7. Retry changing the GCP project in Apps Script settings

**How to fix — Option B (create a new project):**
1. Go to [Google Cloud Console](https://console.cloud.google.com/) → create a new project
2. When setting the **Location**, explicitly choose your organization root or "No organization"
3. Verify the project number does **not** start with `sys-` (those are auto-created default projects and won't work)
4. Enable the Apps Script API in the new project
5. Use this project's number in Apps Script settings

**Key requirements:**
- The GCP project must be a **manually created, standard project** — not an auto-generated one
- It must live **outside** the `system-gsuite → apps-script` managed folder
- Project numbers starting with `sys-` are auto-created defaults and cannot be used
- You need **Project Browser** and **OAuth Config Editor** roles (or equivalent) on the project
- Moving projects requires the **Project Mover** role (`roles/resourcemanager.projectMover`) granted at the **organization level** — even org owners/admins don't have this by default
- Switching from a default project to a standard project is one-way — you cannot switch back
- On Google Workspace accounts, the GCP project must be in the **same Cloud Organization** as the script owner, just not inside the managed folder

### "Apps Script API has not been used in project X"

This error means the Apps Script API is not enabled in the GCP project associated with your script. Fix:
1. Note the project number from the error message
2. Go to [Google Cloud Console](https://console.cloud.google.com/) → select that project
3. APIs & Services → Library → search "Apps Script API" → **Enable**
4. If the project number doesn't match any project you own, your script is using a default GCP project that you can't access — follow the "cannot switch" fix above to assign your own GCP project first

## Project Structure

```
htmltemplateautoupdate/
├── live-site-pages/             # Deployed to GitHub Pages
│   ├── index.html              # Live landing page
│   ├── indexhtml.version.txt   # Version file for auto-refresh
│   ├── indexhtml.changelog.txt # Deployed changelog for popup
│   ├── test.html               # GAS Self-Update Dashboard test page
│   ├── testhtml.version.txt    # Version file for test page auto-refresh
│   ├── testhtml.changelog.txt  # Deployed changelog for popup
│   ├── soccer-ball.html        # Soccer ball animation page
│   ├── soccer-ballhtml.version.txt   # Version file for soccer ball page auto-refresh
│   ├── soccer-ballhtml.changelog.txt # Deployed changelog for popup
│   ├── gas-project-creator.html       # GAS project creator dashboard
│   ├── gas-project-creatorhtml.version.txt   # Version file for gas-project-creator page auto-refresh
│   ├── gas-project-creatorhtml.changelog.txt # Deployed changelog for popup
│   ├── gas-project-creator-code.js.txt # Shared GAS template source for all Copy Code.gs buttons
│   ├── gas-template.html              # GAS template embedding page
│   ├── gas-templatehtml.version.txt   # Version file for gas-template page auto-refresh
│   ├── gas-templatehtml.changelog.txt # Deployed changelog for popup
│   └── sounds/                 # Audio feedback files
├── live-site-templates/        # Templates for new pages
│   ├── HtmlTemplateAutoUpdate.html           # Template HTML page (no GAS)
│   ├── HtmlTemplateAutoUpdatehtml.version.txt # Template version file (frozen at v01.00w)
│   ├── GasTemplate.html                      # GAS-enabled template HTML page
│   └── GasTemplatehtml.version.txt           # GAS template version file (frozen at v01.00w)
├── googleAppsScripts/          # Google Apps Script projects
│   ├── Index/                 # GAS for live-site-pages/index.html
│   │   ├── index.gs           # Self-updating GAS web app
│   │   ├── index.config.json  # Project config (source of truth)
│   │   └── indexgs.version.txt  # GAS version file (mirrors VERSION var)
│   ├── Test/                  # GAS for live-site-pages/test.html
│   │   ├── test.gs            # Self-updating GAS web app
│   │   ├── test.config.json   # Project config (source of truth)
│   │   └── testgs.version.txt  # GAS version file (mirrors VERSION var)
│   ├── GasProjectCreator/       # GAS for live-site-pages/gas-project-creator.html
│   │   ├── gas-project-creator.gs      # GAS project creator web app
│   │   ├── gas-project-creator.config.json  # Project config (source of truth)
│   │   └── gas-project-creatorgs.version.txt  # GAS version file (mirrors VERSION var)
│   ├── GasTemplate/             # GAS template for new projects (used by gas-project-creator)
│   │   ├── gas-template.gs      # Template GAS web app (placeholder values)
│   │   ├── gas-template.config.json  # Template config (placeholders)
│   │   └── gas-templategs.version.txt  # Template GAS version file
│   └── HtmlTemplateAutoUpdate/  # Original GAS template (base for GasTemplate)
│       ├── HtmlTemplateAutoUpdate.gs           # Template GAS web app
│       ├── HtmlTemplateAutoUpdate.config.json  # Template config (placeholders)
│       └── HtmlTemplateAutoUpdategs.version.txt  # Template GAS version file
├── .claude/
│   ├── rules/                  # Always-loaded + path-scoped rules
│   │   ├── behavioral-rules.md        # Always loaded — execution style, pushback, etc.
│   │   ├── changelogs.md              # Path-scoped — CHANGELOG rules
│   │   ├── chat-bookends.md           # Always loaded — response formatting rules
│   │   ├── chat-bookends-reference.md # Always loaded — bookend examples & tables
│   │   ├── gas-scripts.md             # Path-scoped — GAS rules
│   │   ├── html-pages.md             # Path-scoped — HTML page rules
│   │   ├── init-scripts.md           # Path-scoped — init script rules
│   │   ├── output-formatting.md      # Always loaded — CLI styling, attribution
│   │   ├── repo-docs.md              # Path-scoped — documentation rules
│   │   └── workflows.md              # Path-scoped — workflow rules
│   ├── skills/                  # Invokable workflow skills
│   │   ├── imported--diff-review/       # /diff-review — pre-push differential review
│   │   │   └── SKILL.md
│   │   ├── imported--frontend-design/   # /frontend-design — distinctive UI creation
│   │   │   └── SKILL.md
│   │   ├── imported--git-cleanup/       # /git-cleanup — stale branch/worktree cleanup
│   │   │   └── SKILL.md
│   │   ├── imported--security-review/   # /security-review — OWASP/web security audit
│   │   │   └── SKILL.md
│   │   ├── imported--skill-creator/     # /skill-creator — create new skills
│   │   │   └── SKILL.md
│   │   ├── imported--webapp-testing/    # /webapp-testing — Playwright page testing
│   │   │   └── SKILL.md
│   │   ├── initialize/          # /initialize — first deployment setup
│   │   │   └── SKILL.md
│   │   ├── maintenance-mode/    # /maintenance-mode — toggle maintenance overlay
│   │   │   └── SKILL.md
│   │   ├── new-page/            # /new-page — create new HTML page with boilerplate
│   │   │   └── SKILL.md
│   │   ├── phantom-update/      # /phantom-update — timestamp alignment
│   │   │   └── SKILL.md
│   │   ├── reconcile/           # /reconcile — end multi-session mode
│   │   │   └── SKILL.md
│   │   └── remember-session/    # /remember-session — save session context
│   │       └── SKILL.md
│   └── settings.json           # Claude Code project settings
├── .github/
│   ├── workflows/              # CI/CD pipeline
│   ├── ISSUE_TEMPLATE/         # Bug report & feature request forms
│   ├── PULL_REQUEST_TEMPLATE.md # PR checklist
│   ├── FUNDING.yml             # Sponsor button config
│   └── last-processed-commit.sha # Inherited branch guard (commit SHA tracking)
├── repository-information/
│   ├── changelogs/             # Per-page and per-GAS changelogs (centralized)
│   │   ├── indexhtml.changelog.md           # User-facing changelog for landing page
│   │   ├── indexhtml.changelog-archive.md   # Older changelog sections (rotated)
│   │   ├── testhtml.changelog.md            # User-facing changelog for test page
│   │   ├── testhtml.changelog-archive.md    # Older changelog sections (rotated)
│   │   ├── soccer-ballhtml.changelog.md          # User-facing changelog for soccer ball page
│   │   ├── soccer-ballhtml.changelog-archive.md  # Older changelog sections (rotated)
│   │   ├── indexgs.changelog.md             # User-facing changelog for Index GAS
│   │   ├── indexgs.changelog-archive.md     # Older changelog sections (rotated)
│   │   ├── testgs.changelog.md              # User-facing changelog for Test GAS
│   │   ├── testgs.changelog-archive.md      # Older changelog sections (rotated)
│   │   ├── gas-project-creatorhtml.changelog.md          # User-facing changelog for GAS Project Creator page
│   │   ├── gas-project-creatorhtml.changelog-archive.md  # Older changelog sections (rotated)
│   │   ├── gas-project-creatorgs.changelog.md            # User-facing changelog for GAS Project Creator GAS
│   │   ├── gas-project-creatorgs.changelog-archive.md    # Older changelog sections (rotated)
│   │   ├── GasTemplatehtml.changelog.md          # GAS template page changelog
│   │   ├── GasTemplatehtml.changelog-archive.md  # GAS template page changelog archive
│   │   ├── GasTemplategs.changelog.md            # GAS template GAS changelog
│   │   ├── GasTemplategs.changelog-archive.md    # GAS template GAS changelog archive
│   │   ├── HtmlTemplateAutoUpdatehtml.changelog.md          # Template page changelog
│   │   ├── HtmlTemplateAutoUpdatehtml.changelog-archive.md  # Template page changelog archive
│   │   ├── HtmlTemplateAutoUpdategs.changelog.md            # Template GAS changelog
│   │   └── HtmlTemplateAutoUpdategs.changelog-archive.md    # Template GAS changelog archive
│   ├── backups/                # Temporary safety-net backups of critical files
│   │   └── CLAUDE.md.bak      # Latest CLAUDE.md backup
│   ├── ARCHITECTURE.md         # System diagram (Mermaid)
│   ├── CHANGELOG.md            # Version history
│   ├── CHANGELOG-archive.md    # Older changelog sections (rotated from CHANGELOG.md)
│   ├── CODING-GUIDELINES.md    # Domain-specific coding knowledge
│   ├── GOVERNANCE.md           # Project governance
│   ├── IMPROVEMENTS.md         # Potential improvements
│   ├── STATUS.md               # Project status dashboard
│   ├── TODO.md                 # Actionable to-do items
│   ├── readme-qr-code.png             # QR code linking to this repo
│   ├── REMINDERS.md            # Reminders for Developer (developer's own notes)
│   ├── SESSION-CONTEXT.md      # Previous Session Context (Claude-written session log)
│   ├── SKILLS-REFERENCE.md     # Complete Claude Code skills inventory (custom + imported + bundled)
│   ├── repository.version.txt  # Repo version (v01.XXr — bumps every push)
│   ├── TOKEN-BUDGETS.md        # Token cost reference for CLAUDE.md
│   └── SUPPORT.md              # Getting help
├── scripts/
│   └── init-repo.sh            # One-shot fork initialization script
├── .gitattributes              # Line ending normalization (LF)
├── CITATION.cff                # Citation metadata
├── CLAUDE.md                   # Developer instructions
├── CODE_OF_CONDUCT.md          # Community standards
├── CONTRIBUTING.md             # How to contribute
├── LICENSE                     # Proprietary license
└── SECURITY.md                 # Vulnerability reporting
```

## Documentation

> <sub>**Tip:** Links below navigate away from this page. `Right-click` → `Open link in new window` to keep this ReadMe visible while you work.</sub>

| Document | Description |
|----------|-------------|
| [ARCHITECTURE.md](repository-information/ARCHITECTURE.md) | Visual system diagram (Mermaid) |
| [CHANGELOG.md](repository-information/CHANGELOG.md) | Version history |
| [CHANGELOG-archive.md](repository-information/CHANGELOG-archive.md) | Older changelog sections |
| [CLAUDE.md](CLAUDE.md) | Developer instructions and conventions |
| [IMPROVEMENTS.md](repository-information/IMPROVEMENTS.md) | Potential improvements to explore |
| [REMINDERS.md](repository-information/REMINDERS.md) | Reminders for Developer (developer's own notes) |
| [SESSION-CONTEXT.md](repository-information/SESSION-CONTEXT.md) | Previous Session Context (Claude-written) |
| [STATUS.md](repository-information/STATUS.md) | Current project status and versions |
| [TODO.md](repository-information/TODO.md) | Actionable planned items |

## Community

> <sub>**Tip:** Links below navigate away from this page. `Right-click` → `Open link in new window` to keep this ReadMe visible while you work.</sub>

| Document | Description |
|----------|-------------|
| [Code of Conduct](CODE_OF_CONDUCT.md) | Community standards and expectations |
| [Contributing](CONTRIBUTING.md) | How to contribute to this project |
| [Security Policy](SECURITY.md) | How to report vulnerabilities |
| [Support](repository-information/SUPPORT.md) | Getting help |
| [Governance](repository-information/GOVERNANCE.md) | Project ownership and decision making |

Developed by: ShadowAISolutions
