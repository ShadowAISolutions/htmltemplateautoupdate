# ​‌‌‌‌‌‌‌​​‌‌‌‌‌​Auto Update HTML Template

A GitHub Pages deployment framework with automatic version polling, auto-refresh, and Google Apps Script (GAS) embedding support.

Last updated: `2026-02-28 05:27:01 PM EST` · Repo version: `v01.28r`

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

## Project Structure

```
htmltemplateautoupdate/
├── live-site-pages/             # Deployed to GitHub Pages
│   ├── index.html              # Live landing page
│   ├── indexhtml.version.txt   # Version file for auto-refresh
│   ├── test.html               # GAS Self-Update Dashboard test page
│   ├── testhtml.version.txt    # Version file for test page auto-refresh
│   └── sounds/                 # Audio feedback files
├── live-site-templates/        # Template for new pages
│   ├── AutoUpdateOnlyHtmlTemplate.html           # Template HTML page
│   └── AutoUpdateOnlyHtmlTemplatehtml.version.txt # Template version file (frozen at v01.00w)
├── googleAppsScripts/          # Google Apps Script projects
│   ├── Index/                 # GAS for live-site-pages/index.html
│   │   ├── index.gs           # Self-updating GAS web app
│   │   ├── index.config.json  # Project config (source of truth)
│   │   └── indexgs.version.txt  # GAS version file (mirrors VERSION var)
│   ├── Test/                  # GAS for live-site-pages/test.html
│   │   ├── test.gs            # Self-updating GAS web app
│   │   ├── test.config.json   # Project config (source of truth)
│   │   └── testgs.version.txt  # GAS version file (mirrors VERSION var)
│   └── AutoUpdateOnlyHtmlTemplate/  # GAS template for new projects
│       ├── AutoUpdateOnlyHtmlTemplate.gs           # Template GAS web app
│       ├── AutoUpdateOnlyHtmlTemplate.config.json  # Template config (placeholders)
│       └── AutoUpdateOnlyHtmlTemplategs.version.txt  # Template GAS version file
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
│   │   ├── indexgs.changelog.md             # User-facing changelog for Index GAS
│   │   ├── indexgs.changelog-archive.md     # Older changelog sections (rotated)
│   │   ├── testgs.changelog.md              # User-facing changelog for Test GAS
│   │   ├── testgs.changelog-archive.md      # Older changelog sections (rotated)
│   │   ├── AutoUpdateOnlyHtmlTemplatehtml.changelog.md          # Template page changelog
│   │   ├── AutoUpdateOnlyHtmlTemplatehtml.changelog-archive.md  # Template page changelog archive
│   │   ├── AutoUpdateOnlyHtmlTemplategs.changelog.md            # Template GAS changelog
│   │   └── AutoUpdateOnlyHtmlTemplategs.changelog-archive.md    # Template GAS changelog archive
│   ├── ARCHITECTURE.md         # System diagram (Mermaid)
│   ├── CHANGELOG.md            # Version history
│   ├── CHANGELOG-archive.md    # Older changelog sections (rotated from CHANGELOG.md)
│   ├── CODING-GUIDELINES.md    # Domain-specific coding knowledge
│   ├── GOVERNANCE.md           # Project governance
│   ├── IMPROVEMENTS.md         # Potential improvements
│   ├── STATUS.md               # Project status dashboard
│   ├── TODO.md                 # Actionable to-do items
│   ├── readme-qr-code.png             # QR code linking to this repo
│   ├── REMINDERS.md            # Cross-session reminders for Claude
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
| [REMINDERS.md](repository-information/REMINDERS.md) | Cross-session reminders for Claude |
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
