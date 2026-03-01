# Claude Code Instructions


## Template Variables

These variables are the **single source of truth** for repo-specific values. When a variable value is changed here, Claude Code must propagate the new value to every file in the repo that uses it.

| Variable | Value | Where it appears | Description |
|----------|-------|------------------|-------------|
| `YOUR_ORG_NAME` | YourOrgName | README<br>CITATION.cff<br>STATUS.md<br>ARCHITECTURE.md<br>issue template config | GitHub org or username that owns this repo.<br>Auto-detected from `git remote -v` on forks.<br>Frozen as a placeholder on the template repo so drift checks can detect forks and replace `ShadowAISolutions` with the fork's actual org |
| `YOUR_ORG_LOGO_URL` | https://logoipsum.com/logoipsum-avatar.png | `index.html`<br>template HTML | URL to the org's logo image.<br>Used in HTML pages for branded logos.<br>Replace with your org's actual logo URL after forking |
| `YOUR_REPO_NAME` | YourRepoName | README<br>CITATION.cff<br>STATUS.md<br>ARCHITECTURE.md<br>issue template config | Name of this GitHub repository.<br>Auto-detected from `git remote -v` on forks.<br>Frozen as a placeholder on the template repo so drift checks can detect forks and replace `htmltemplateautoupdate` with the fork's actual name |
| `YOUR_PROJECT_TITLE` | CHANGE THIS PROJECT TITLE TEMPLATE | `<title>` tag in<br>`index.html`<br>and template HTML | Human-readable project title shown in browser tabs.<br>Independent of the repo name — set this to whatever you want users to see as the page title |
| `DEVELOPER_NAME` | ShadowAISolutions | LICENSE<br>README<br>CITATION.cff<br>FUNDING.yml<br>GOVERNANCE.md<br>CONTRIBUTING.md<br>PR template<br>"Developed by:" footers<br>(all files) | Name used for attribution, copyright, and branding throughout the repo.<br>On forks, defaults to the new org name unless explicitly overridden by the user |
| `DEVELOPER_LOGO_URL` | https://www.shadowaisolutions.com/SAIS%20Logo.png | HTML splash screen<br>`LOGO_URL` variable<br>(in `index.html`<br>and template) | URL to the developer's logo shown on the "Code Ready" and "Website Ready" splash screens.<br>Replace with your own logo URL after forking |
| `IS_TEMPLATE_REPO` | htmltemplateautoupdate | CLAUDE.md<br>workflow deploy<br>job condition | Controls whether this repo is treated as the template or a fork.<br>Compared against the actual repo name from `git remote -v` — if they match, this is the template repo (drift checks, version bumps, and deployment are all skipped).<br>If `No` or doesn't match, it's a fork.<br>Drift checks set this to `No` as their first step |
| `CHAT_BOOKENDS` | On | CLAUDE.md | Controls whether mid-response bookends are output.<br>`On` = all bookends are emitted as documented.<br>`Off` = **skip** every bookend marker **except** the end-of-response block (UNAFFECTED URLS through CODING COMPLETE) and its prerequisite timestamps/durations.<br>When `Off`, the response reads as plain work output — no CODING PLAN, CODING START, RESEARCHING, NEXT PHASE, CHECKLIST, BLOCKED, VERIFYING, CHANGES PUSHED, AWAITING HOOK, HOOK FEEDBACK, time estimates, revised estimates, or `⏱️` duration lines are emitted. The end-of-response block is governed independently by `END_OF_RESPONSE_BLOCK` |
| `END_OF_RESPONSE_BLOCK` | On | CLAUDE.md | Controls whether the end-of-response block is output.<br>`On` = the full block is emitted (divider, UNAFFECTED URLS, AGENTS USED, FILES CHANGED, COMMIT LOG, WORTH NOTING, SUMMARY, AFFECTED URLS, ESTIMATE CALIBRATED, ACTUAL TOTAL COMPLETION TIME, CODING COMPLETE).<br>`Off` = the entire end-of-response block is **skipped** — no divider, no summary sections, no CODING COMPLETE line.<br>This variable is independent of `CHAT_BOOKENDS` — either, both, or neither can be active |
| `TEMPLATE_DEPLOY` | On | CLAUDE.md<br>workflow deploy<br>job condition | Controls whether GitHub Pages deployment runs on the template repo.<br>`On` = deploy runs even when `IS_TEMPLATE_REPO` matches the repo name (allows seeing the live site on the template).<br>`Off` = deploy is skipped on the template repo (default behavior for templates).<br>Has no effect on forks — forks always deploy normally regardless of this toggle.<br>**Toggle takes effect on the same commit** — the workflow reads this value from the pushed branch, so switching to `On` triggers deployment on that commit's push, and switching to `Off` skips deployment on that commit's push |

### How variables work
- **In code files** (HTML, YAML, Markdown, etc.): use the **resolved value** (e.g. write `MyOrgName`, not `YOUR_ORG_NAME`)
- **In CLAUDE.md instructions**: the placeholder names (`YOUR_ORG_NAME`, `DEVELOPER_NAME`, etc.) may appear in examples and rules — Claude Code resolves them using the table above

---
> **--- END OF TEMPLATE VARIABLES ---**
---

> **Output formatting** — see Chat Bookends section (near end of file) for mandatory response formatting: CODING PLAN → CODING START → work → CODING COMPLETE with timestamps on every response.

## Session Start Checklist (MANDATORY — RUN FIRST)
> **MANDATORY FIRST ACTION — DO NOT SKIP**
> Complete ALL checks below and commit any fixes BEFORE reading or acting on the user's request.
> If checklist items produce changes, commit them as a separate commit with message:
> `Session start: fix template drift`
> **The user's task is NOT urgent enough to skip this. Do it first. Every time.**

### Always Run (every repo, every session — NEVER skip)
These rules apply universally — they are **NOT** skipped by the template repo short-circuit.

**Session isolation** — before acting on ANY instructions, verify this session is not contaminated by stale context from a prior session or a different repo. Run these checks in order:
- **Repo identity**: run `git remote -v` and extract the full `org/repo` identity (e.g. `github.com/MyOrg/my-project` → `MyOrg/my-project`). Compare this against any repo-specific references carried over in the session context — branch names (e.g. `claude/...`), commit SHAs, remote URLs, or org/repo identifiers from prior instructions. If the current repo's `org/repo` does **not** match references from prior session context, those references are stale cross-repo contamination — **discard all prior commit, push, and branch instructions entirely** and act only on the user's explicit current request. Do NOT replay commits, cherry-pick changes, push to branches, or continue work that originated in a different repo
- **Clean working state**: run `git status`. If there are uncommitted changes (staged or unstaged) that were NOT made by this session, they are leftovers from a prior session — do NOT commit them. Ask the user how to handle them (stash, discard, or incorporate). If there are local `claude/*` branches that don't match this session's branch, they are stale — ignore them (do NOT push to or continue work on a stale branch)
- **Auto memory cross-check**: if auto memory (`~/.claude/projects/*/memory/MEMORY.md`) contains references to a different `org/repo` than the current one, those entries are stale — ignore them entirely when making decisions about commits, branches, or repo structure
- **Session continuity**: if this session was started via `--continue` or `--fork-session` from a prior session that worked on a **different repo**, treat all inherited conversation context as informational only — do NOT execute any commits, pushes, or file changes carried over from the prior session's repo. Verify the current repo identity before every destructive or write action
- **Context compaction recovery**: when the conversation context has been compacted (indicated by a session summary replacing earlier messages), output `🔃🔃CONTEXT COMPACTION RECOVERY🔃🔃` as the first line (with timestamp, like any bookend). This is a **mid-session recovery**, not a new session — **skip reminders** (they were already surfaced earlier in this session) and skip any checklist items that only need to run once per session (they already ran). The goal is to **resume the interrupted task as efficiently as possible**, not to restart from scratch. **Re-read the actual rules in CLAUDE.md** before producing any output — do not rely on patterns, formats, or behaviors carried over from the compacted summary. Summaries describe what was done but do not encode the rules that governed those actions; defaulting to "how the summary described it" instead of "what CLAUDE.md currently says" causes drift (e.g. wrong URL formats, skipped checklist steps, stale variable values). Specifically: re-derive all output formatting from the current CLAUDE.md rules (Chat Bookends, URL display patterns, timestamp formats, end-of-response block structure), re-read the Template Variables table, and use the compacted summary as context for what was already accomplished — do not redo completed work. **After re-reading the rules, resume the interrupted work immediately** — do not treat compaction as task completion. If a response was mid-flight (e.g. push succeeded but the end-of-response block wasn't written), complete it using available state (git log for commit SHAs, file reads for current versions, summary context for what was done). The user's task is not finished until the response that was interrupted is fully closed out

**Branch hygiene** — run `git remote set-head origin main` to ensure `origin/HEAD` points to `main`. If a local `master` branch exists and points to the same commit as `origin/main`, delete it with `git branch -D master`. This prevents the auto-merge workflow from failing with exit code 128 due to branch misconfiguration.

**Deployment Flow**
- Never push directly to `main`
- Push to `claude/*` branches only
- `.github/workflows/auto-merge-claude.yml` handles everything automatically:
  1. Guards against stale inherited branches (from template forks) via commit-timestamp-vs-repo-creation check, IS_TEMPLATE_REPO mismatch (reads from both main and pushed branch), and already-merged check — deletes them without merging
  2. Merges the claude branch into main
  3. Deletes the claude branch
  4. Sweeps and deletes any other stale claude/* branches already merged into main
  5. Deploys to GitHub Pages
- **Trigger design** — the template ships with only `claude/**` in the push trigger (no `main`). During initialization, `scripts/init-repo.sh` adds `main` back:
  - **Why no `main` on the template**: GitHub's "Use this template" creates a fresh commit on `main` in the new repo. If `main` were in the push trigger, the workflow would fire on every template copy — producing a workflow run in the Actions tab before the user has even set up Pages
  - **Why add `main` after init**: once initialized, direct-to-main pushes (e.g. a user editing `index.html` on GitHub.com) should auto-deploy. The `is-initialized` gate (`IS_TEMPLATE_REPO = No`) provides defense-in-depth
  - `workflow_dispatch` is also available for manual re-deploys
  - The auto-merge job's push to `main` (after merging) uses `[skip ci]` in the commit message, so it doesn't re-trigger the workflow
  - **On the template repo**: `main` stays excluded from the push trigger. Do NOT add it manually — the init script handles this on forks
- The "Create a pull request" message in push output is just GitHub boilerplate — ignore it, the workflow handles merging automatically
- **Multiple pushes per session are safe** — pushing to the same `claude/*` branch name multiple times in a session works correctly as long as each push waits for the previous workflow to finish (merge + branch deletion). Pre-Push Checklist item #5 handles this: it checks `git ls-remote` to confirm the branch no longer exists on the remote before pushing again. The "Rebase before push commit" rule in the Pre-Commit Checklist ensures the branch is rebased onto the updated `origin/main` before each push commit cycle. **Do NOT push while the branch still exists on the remote** — this would queue a second workflow run, and if the first run merges and deletes the branch, the queued run fails with exit code 128
- **Pre-push verification** — before executing any `git push`, run the Pre-Push Checklist (see below). This is mandatory even when the Deployment Flow rules are satisfied

**Template repo short-circuit** — check the `IS_TEMPLATE_REPO` variable in the Template Variables table. If its value matches the actual repo name (extracted from `git remote -v`), this is the template repo itself — skip the Template Drift Checks below and proceed directly to the user's request. If the value is `No` or does not match the actual repo name, continue to the next check.

**Initialized repo short-circuit** — check if `README.md` contains the placeholder text `You are currently using the **`. If it does NOT, the repo has already been initialized — skip the Template Drift Checks below and proceed directly to the user's request. If it DOES, the repo is a fresh fork that needs initialization — continue to the Template Drift Checks.

**Reminders** — read `repository-information/REMINDERS.md`. If the `## Active Reminders` section contains any entries, surface them to the user before proceeding to their request. Format: output `📌 Reminders from last session:` followed by each reminder as a bullet point. After surfacing, proceed normally — do not wait for acknowledgment. If the user says "remind me next time" (or similar phrasing like "next session remember", "don't let me forget") about anything during a session, add it to the `## Active Reminders` section with a timestamp. When a reminder has been addressed or the user dismisses it, move it to `## Completed Reminders` with a completion timestamp.

### Template Drift Checks (forks/clones only)
These checks catch template drift that accumulates when the repo is cloned/forked into a new name. They do **not** apply to the template repo itself.

> **Token budget:** *See `repository-information/TOKEN-BUDGETS.md` — section "Template Drift Checks"*

> **Centralized init script:** The drift checks are fully automated by `scripts/init-repo.sh`. The script handles all find-and-replace propagation across 23+ files, README restructuring, STATUS.md placeholder replacement, CLAUDE.md table updates (including `IS_TEMPLATE_REPO` → `No`), README timestamp, and QR code generation. Steps 1–3 below are all that's needed.

1. **Run init script** — execute `bash scripts/init-repo.sh`. The script auto-detects the org and repo name from `git remote -v` and performs all initialization in one execution:
   - Deletes any inherited `claude/*` branches (local and remote) from the template — prevents the auto-merge workflow from running on stale branches
   - Replaces all occurrences of `ShadowAISolutions` → new org name across 23 target files (URLs, branding, content, "Developed by:" footers)
   - Replaces all occurrences of `htmltemplateautoupdate` → new repo name across the same files
   - If `DEVELOPER_NAME` differs from org name, pass it as a third argument: `bash scripts/init-repo.sh ORG REPO DEVELOPER_NAME`. The script will correct "Developed by:" lines and content references. By default `DEVELOPER_NAME` equals the org name
   - Updates the CLAUDE.md Template Variables table (`YOUR_ORG_NAME`, `YOUR_REPO_NAME`, `DEVELOPER_NAME`, `IS_TEMPLATE_REPO` → `No`)
   - Replaces the STATUS.md `*(deploy to activate)*` placeholder with the live site URL
   - Restructures README.md: replaces the title, swaps the placeholder block for the live site link, and removes the "Copy This Repository" and "Initialize This Template" sections
   - Updates the `Last updated:` timestamp in README.md to the current time
   - Generates `repository-information/readme-qr-code.png` with the fork's live site URL (installs `qrcode[pil]` if needed; skips gracefully if Python is unavailable)
   - Runs a smart verification grep: on same-org forks (org unchanged), only checks repo-name replacements; on different-org forks, checks both. Excludes "Developed by:" branding lines and provenance markers from warnings
   - **Relative links** in `SECURITY.md`, `SUPPORT.md`, and `README.md` that use `../../` paths are NOT modified — they resolve correctly on any fork via GitHub's blob-view URL structure
2. **Handle script warnings** — if the verification step reports files with remaining old values, inspect them manually. They are likely provenance markers (expected) or edge cases the script didn't cover (fix manually). On a clean run, the script exits with zero warnings
3. **Unresolved placeholders** — scan for any literal `YOUR_ORG_NAME`, `YOUR_REPO_NAME`, `YOUR_PROJECT_TITLE`, or `DEVELOPER_NAME` strings in code files (not CLAUDE.md) and replace them with resolved values
4. **Confirm completion** — after all checks pass, briefly state to the user: "Session start checklist complete — no issues found" (or list what was fixed). Then proceed to their request

### Token Budget Reference
*See `repository-information/TOKEN-BUDGETS.md` — section "Session Start Checklist"*

---
> **--- END OF SESSION START CHECKLIST ---**
---

## Template Repo Guard
> When the actual repo name (from `git remote -v`) matches the `IS_TEMPLATE_REPO` value in the Template Variables table (i.e. this is the template repo itself, not a fork/clone):
> - **Session Start Checklist template drift checks are skipped** — the "Template repo short-circuit" in the Always Run section skips the entire numbered checklist. The "Always Run" section (branch hygiene and deployment flow) still applies every session
> - **Version bumps are conditional on `TEMPLATE_DEPLOY`**:
>   - When `TEMPLATE_DEPLOY` = `On`: version bumps ARE performed — Pre-Commit items #1 (`.gs` version bump), #2 (html.version.txt bump), #3 (html.version.txt single source), #5 (STATUS.md), #6 (ARCHITECTURE.md structural changes), #7 (CHANGELOG.md), #9 (version prefix in commit message), #16 (repo version bump), and #17 (page changelog) all run normally, so that deployed pages auto-refresh after changes and changelogs track version history. Item **#14 (QR code generation)** is still skipped regardless — QR codes use placeholder URLs on the template
>   - When `TEMPLATE_DEPLOY` = `Off`: all version bumps are skipped — items #1, #2, #3, #5, #6 (version-bump portion), #7, #9, #14, #16, and #17 are all skipped (the original behavior). Additionally, if any versions were previously bumped above `v01.00w` / `"01.00g"` / `v01.00r`, **reset them to initial values**: html.version.txt files → `|v01.00w|`, HTML meta tags → `v01.00w`, `.gs` VERSION → `"01.00g"`, `repository.version.txt` → `v01.00r`, STATUS.md versions → initial. **Also reset `repository-information/CHANGELOG.md`** — remove all versioned release sections (`## [vXX.XX*]` sections), remove all entries and category headings under `## [Unreleased]`, replace with `*(No changes yet)*`, and remove the date from the section header (→ `## [Unreleased]`). Also reset `repository-information/CHANGELOG-archive.md` — remove all archived sections and restore the `*(No archived sections yet)*` placeholder. **Also reset all page and GAS changelogs** — reset every `<page-name>html.changelog.md` and `<page-name>gs.changelog.md` in `repository-information/changelogs/` and their corresponding archive files the same way (clear version sections, restore `*(No changes yet)*` / `*(No archived sections yet)*`). Also reset GAS `<page-name>gs.version.txt` files in `googleAppsScripts/*/` to `01.00g`. This ensures forks inherit clean starting versions and a blank change history
> - **GitHub Pages deployment is skipped by default** — the workflow's `deploy` job reads `IS_TEMPLATE_REPO` from `CLAUDE.md` and compares it against the repo name; deployment is skipped when they match. **Override**: set `TEMPLATE_DEPLOY` to `On` in the Template Variables table to enable deployment on the template repo (the workflow reads this toggle and allows deploy when it's `On`). Set it to `Off` to restore the default skip behavior. **The toggle takes effect on the same commit** — the `check-template` job reads `TEMPLATE_DEPLOY` from the pushed branch (not from `main`), so switching to `On` triggers deployment on that commit's push, and switching to `Off` skips deployment on that commit's push
> - **`YOUR_ORG_NAME` and `YOUR_REPO_NAME` are frozen as placeholders** — in the Template Variables table, these values must stay as `YourOrgName` and `YourRepoName` (generic placeholders). Do NOT update them to match the actual org/repo (`ShadowAISolutions`/`htmltemplateautoupdate`). The code files throughout the repo use the real `ShadowAISolutions/htmltemplateautoupdate` values so that links are functional. On forks, the Session Start drift checks detect the mismatch between the placeholder table values and the actual `git remote -v` values, then find and replace the template repo's real values (`ShadowAISolutions`/`htmltemplateautoupdate`) in the listed files with the fork's actual org/repo
> - Pre-Commit items #0, #4, #6, #8, #10, #11, #12, #13, #15, #18 still apply normally (plus #1, #2, #3, #5, #7, #9, #16, #17 when `TEMPLATE_DEPLOY` = `On`)
> - **Pre-Push Checklist is never skipped** — all 5 items apply on every repo including the template repo

---
> **--- END OF TEMPLATE REPO GUARD ---**
---

## Pre-Commit Checklist
**Before every commit, verify ALL of the following:**

> **Push commit vs. intermediate commits** — the **push commit** is the final commit in a session before `git push`, excluding the SHA backfill commit (which is a mechanical follow-up to the push commit — see #7). Items #7 (CHANGELOG version sections), #9 (repo version prefix in message), #16 (repo version bump), and #17 (page changelog version sections) only run their full behavior on the push commit. The SHA backfill commit follows the push commit and is exempt from all push commit rules. Intermediate commits (earlier commits in the same session) still run the rest of the checklist but skip the per-push portions of those items. This reduces CHANGELOG growth from one version section per commit to one per push.

> **Rebase before push commit** — at the start of **every** push commit cycle, before any version bumps or CHANGELOG edits, check whether the branch needs rebasing onto `origin/main`. This is a direct state check — not based on tracking whether a push happened earlier in the session. Sequence: (1) commit all pending work so the working tree is clean (staged and unstaged changes become intermediate commits), (2) `git fetch origin main`, (3) check ancestry: `git merge-base --is-ancestor origin/main HEAD` — if this returns 0 (true), the branch is already up to date and no rebase is needed; if it returns 1 (false), `origin/main` has advanced and a rebase is required, (4) if rebase needed: `git rebase origin/main`, (5) start the push commit cycle (version bump, CHANGELOG, README timestamp, etc.). **Why this matters for SHA backfill** — rebase rewrites commit SHAs, so rebasing after the push commit invalidates the backfilled SHA. The correct order is always: rebase (if needed) → push commit → SHA backfill → push.

> **Push commit efficiency** — to minimize overhead, batch the push commit operations: (1) run `date` **once** at the start of the push commit cycle and reuse the timestamp for all files (CHANGELOG version section header, README `Last updated:` line, and any page/GAS changelog version sections), (2) once the new version number and timestamp are determined, issue independent edits as **parallel tool calls** — `repository.version.txt`, `README.md`, `CHANGELOG.md`, and `STATUS.md` (if applicable) can all be edited in the same tool-call batch since they have no dependencies on each other.

> **TEMPLATE REPO GATE** — before running any numbered item, check: does the actual repo name (from `git remote -v`) match `IS_TEMPLATE_REPO` in the Template Variables table? If **yes**, check `TEMPLATE_DEPLOY`:
> - `TEMPLATE_DEPLOY` = `On`: only #14 (QR code) is skipped. Items #1, #2, #3, #5, #6, #7, #9, #16, and #17 run normally — version bumps are needed so deployed pages auto-refresh, and changelogs track version history
> - `TEMPLATE_DEPLOY` = `Off`: items #1, #2, #3, #5, #7, #9, #14, #16, and #17 are **all skipped** — do NOT bump versions, update version-tracking files, add CHANGELOG entries, use version prefixes in commit messages, or generate QR codes. Additionally, reset the CHANGELOG to clean state (see Template Repo Guard). Proceed directly to the items that still apply (#0, #4, #6, #8, #10, #11, #12, #13, #15, #18)
>
> This gate also applies during `initialize` — initialization never bumps versions on any repo

0. **Commit belongs to this repo and task** — before staging or committing ANY changes, verify: (a) `git remote -v` still matches the repo you are working on — if it doesn't, STOP and do not commit; (b) every file being staged was modified by THIS session's task, not inherited from a prior session or a different repo; (c) the commit message describes work you actually performed in this session — never commit with a message copied from a prior session's commit. If any of these checks fail, discard the stale changes and proceed only with the user's current request. **This item is never skipped** — it applies on every repo including the template repo
1. **Version bump (.gs)** — if any `.gs` file was modified, increment its `VERSION` variable by 0.01 (e.g. `"01.13g"` → `"01.14g"`) **and** update the corresponding `<page-name>gs.version.txt` in the same GAS project directory to match (e.g. `01.13g` → `01.14g`). The `VERSION` variable in the `.gs` file is the **single source of truth** — the `gs.version.txt` file mirrors it for external reference
2. **Version bump (html.version.txt + meta tag)** — if any embedding HTML page in `live-site-pages/` was modified, increment the version in its `<page-name>html.version.txt` by 0.01 (e.g. `|v01.01w|` → `|v01.02w|`) **and** update the `<meta name="build-version" content="vXX.XXw">` tag in the HTML to match (the meta tag uses just the version string, no pipes). The html.version.txt file is the **single source of truth** for the auto-refresh polling — the meta tag is informational only (not read by the polling logic), so changing only html.version.txt still triggers a reload correctly. **Every commit that modifies an HTML page must bump its version** — even if the version was already bumped for that page in a prior commit within the same session. The auto-refresh polling only detects version *changes* relative to what the browser has cached; if a fix commit deploys with the same version as the broken commit, the browser never reloads and the user sees stale (broken) content. **Skip on template repo when `TEMPLATE_DEPLOY` = `Off`**
3. **Htmlversion.txt is single source** — the polling logic reads html.version.txt on page load to establish the current version, then polls for changes. The `<meta name="build-version">` tag in the HTML is **informational only** — it is kept in sync with html.version.txt for visibility but is never read by the polling logic. Version bumps happen in both html.version.txt and the meta tag, but only html.version.txt drives the auto-refresh. The format uses pipe delimiters: `|v01.00w|` (version is always the middle field). **Skip on template repo when `TEMPLATE_DEPLOY` = `Off`**
4. **Template version freeze** — never bump `live-site-templates/AutoUpdateOnlyHtmlTemplatehtml.version.txt` — its version must always stay at `|v01.00w|`
5. **STATUS.md** — if any version was bumped, update the matching version in `repository-information/STATUS.md`. **Skip on template repo when `TEMPLATE_DEPLOY` = `Off`**
6. **ARCHITECTURE.md** — if the project structure changed (files or directories added, moved, or deleted), update the diagram in `repository-information/ARCHITECTURE.md`. This item applies on every repo including the template repo. **Version numbers are NOT shown in the diagram** — ARCHITECTURE.md is a structural overview, not a version dashboard. STATUS.md serves as the version dashboard. Mermaid nodes show filenames only (no version strings)
7. **CHANGELOG.md** — every user-facing change must have an entry under `## [Unreleased]` in `repository-information/CHANGELOG.md`, grouped under the appropriate Keep a Changelog category: `### Added` (new features), `### Changed` (changes to existing functionality), `### Fixed` (bug fixes), `### Deprecated` (soon-to-be removed features), `### Removed` (removed features), `### Security` (vulnerability fixes). Only include categories that have entries — do not add empty category headings. Entries are plain descriptions — no per-entry timestamps (the version section header carries the timestamp for the entire push). Format: `- Description`. **Versioned release sections** — on the **push commit** (the final commit before `git push`), move all entries from `## [Unreleased]` into a new version section. The repo version (Pre-Commit #16) bumps on the push commit, so each push produces one version section — not one per commit. Intermediate commits within the same session add entries to `[Unreleased]` without creating a version section. The version section header includes a full EST timestamp and a commit SHA link. **Timestamps must be real** — run `TZ=America/New_York date '+%Y-%m-%d %I:%M:%S %p EST'` to get the actual current time; never fabricate or increment timestamps. Format: `## [vXX.XXr] — YYYY-MM-DD HH:MM:SS AM/PM EST — [SHORT_SHA](https://github.com/ORG/REPO/commit/FULL_SHA)` (repo-only changes), `## [vXX.XXr vXX.XXg] — YYYY-MM-DD HH:MM:SS AM/PM EST — [SHORT_SHA](URL)` (repo + GAS), `## [vXX.XXr vXX.XXw] — YYYY-MM-DD HH:MM:SS AM/PM EST — [SHORT_SHA](URL)` (repo + page), or `## [vXX.XXr vXX.XXg vXX.XXw] — YYYY-MM-DD HH:MM:SS AM/PM EST — [SHORT_SHA](URL)` (all three). Order in header: `r` first, then `g`, then `w`. **SHA backfill** — the SHA cannot be known until after the push commit is created, so it is added in a separate mechanical step: (1) create the push commit with the version section header (no SHA yet), (2) run `git rev-parse --short HEAD` and `git rev-parse HEAD` to get the short and full SHAs, (3) edit the CHANGELOG to insert ` — [SHORT_SHA](https://github.com/ORG/REPO/commit/FULL_SHA)` at the end of the version section header line, (4) stage and commit with message `Backfill CHANGELOG SHA` — this **SHA backfill commit** is exempt from all push commit rules (no version bump, no version prefix, no CHANGELOG entry, no README timestamp update). Resolve `ORG/REPO` from `git remote -v`. Both the push commit and the SHA backfill commit are pushed together. The SHA link points to the push commit, which will exist on the remote after push. **Rebase interaction** — if a rebase is needed (second push in session), it MUST happen BEFORE the push commit, not after. Rebase rewrites commit SHAs, so rebasing after the push commit invalidates the backfilled SHA. See "Rebase before push commit" rule above. The `g` and `w` versions in the header reflect the **latest values at push time** — if multiple commits in the session bumped `g` or `w`, use the final bumped version. The version section keeps its category groupings intact. `## [Unreleased]` is then left empty (no placeholder text needed — it will accumulate entries from the next session onward). Latest versions appear first (reverse chronological). **One version, one set of entries** — each version section contains only the entries for changes introduced by that specific push. Once entries are moved from `[Unreleased]` into a version section and pushed, they belong to that version permanently. Later pushes must NOT duplicate or re-include entries from prior version sections — only new changes go into the new version section. **Skip on template repo when `TEMPLATE_DEPLOY` = `Off`** — when skipped, the CHANGELOG must stay clean with `*(No changes yet)*` under a bare `## [Unreleased]` so forks start with a blank history. When `TEMPLATE_DEPLOY` = `On`, CHANGELOG entries are added normally to track version changes on the deployed template. **When `TEMPLATE_DEPLOY` is switched from `On` to `Off`**, reset the CHANGELOG: remove all version sections, remove all entries and category headings under `## [Unreleased]`, replace with `*(No changes yet)*`, and remove the date from the section header (see Template Repo Guard). **Archive rotation** — on the push commit, after creating the new version section, check whether rotation is needed. The full logic is documented in `repository-information/CHANGELOG-archive.md` (see "Rotation Logic" section). In brief: count version sections, skip if ≤50, never rotate today's sections, rotate the oldest full date group together. The archive file's `*(No archived sections yet)*` placeholder is removed on first rotation. **Capacity counter** — the CHANGELOG header includes a `` `Sections: X/50` `` line showing the current count of version sections vs. the rotation limit. Update this counter on every push commit after creating the new version section (and after any archive rotation). Count all `## [vXX.XX*]` lines in the file (excluding `## [Unreleased]`). When `TEMPLATE_DEPLOY` is switched `Off` and the CHANGELOG is reset, reset the counter to `` `Sections: 0/50` ``
8. **README.md structure tree** — if files or directories were added, moved, or deleted, update the ASCII tree in `README.md`
9. **Commit message format** — the **push commit** message must start with the repo version prefix `v{REPO_VERSION}` (e.g. `v01.03r`). If `.gs` or HTML versions were also bumped on the push commit, append those prefixes in order: `r`, `g`, `w` (e.g. `v01.05r v01.14g v01.02w Fix bug`). **Intermediate commits** (earlier commits in the same session, before the push commit) use `g`/`w` prefixes only if those versions were bumped on that specific commit; if no `g`/`w` versions were bumped, use a plain descriptive message with no version prefix. **SHA backfill commit exception** — the `Backfill CHANGELOG SHA` commit that follows the push commit (see #7) uses a fixed message with no version prefix — it is exempt from all push commit formatting rules. **Skip on template repo when `TEMPLATE_DEPLOY` = `Off`**
10. **Developer branding** — any newly created file must have `Developed by: DEVELOPER_NAME` as the last line (using the appropriate comment syntax for the file type), where `DEVELOPER_NAME` is resolved from the Template Variables table
11. **README.md `Last updated:` line** — on every commit, update the `Last updated:` timestamp near the top of `README.md` to the real current time (run `TZ=America/New_York date '+%Y-%m-%d %I:%M:%S %p EST'`), and update the `Repo version:` value on the same line to match `repository-information/repository.version.txt`. Format: `` Last updated: `TIMESTAMP` · Repo version: `vXX.XXr` ``. Since the repo version only bumps on the push commit (#16), intermediate commits will naturally show the existing version — this is expected. When `TEMPLATE_DEPLOY` = `Off` (no repo version bump), keep the version display at `v01.00r`. **This rule always applies — it is NOT skipped by the Template Repo Guard**
12. **Internal link integrity** — if any markdown file is added, moved, or renamed, verify that all internal links (`[text](path)`) in the repo still resolve to existing files. Pay special attention to cross-directory links — see the Internal Link Reference section for the correct relative paths
13. **README section link tips** — every `##` section in `README.md` that contains (or will contain) any clickable links must have this blockquote as the first line after the heading (before any other content): `> **Tip:** Links below navigate away from this page. **Ctrl + click** (or right-click → *Open in new tab*) to keep this ReadMe visible while you work.` — Sections with no links (e.g. a section with only a code block or plain text) do not need the tip
14. **QR code generation** — if the commit changes the live site URL in `README.md` (i.e. the `https://YOUR_ORG_NAME.github.io/YOUR_REPO_NAME` link — typically during initialization or org/repo name changes), regenerate `repository-information/readme-qr-code.png` to encode the **live site URL** (the `https://YOUR_ORG_NAME.github.io/YOUR_REPO_NAME` GitHub Pages URL — NOT the GitHub repo URL). Use the Python `qrcode` library: `python3 -c "import qrcode; qrcode.make('https://YOUR_ORG_NAME.github.io/YOUR_REPO_NAME').save('repository-information/readme-qr-code.png')"` (with resolved values). If `qrcode` is not installed, install it first with `pip install qrcode[pil]`. Stage the updated PNG alongside the other changes so it lands in the same commit. **Skip if Template Repo Guard applies** — the template repo uses placeholder URLs, so no QR code should be generated for them
15. **GAS config sync** — if any `<page-name>.config.json` file under `googleAppsScripts/` was modified, sync its values to the corresponding `<page-name>.gs` and embedding HTML page. `<page-name>.config.json` is the **single source of truth** for project-unique GAS variables (`TITLE`, `DEPLOYMENT_ID`, `SPREADSHEET_ID`, `SHEET_NAME`, `SOUND_FILE_ID`). Sync targets: (a) the `<page-name>.gs` in the same directory — update the matching `var` declarations, (b) the embedding HTML page (from the GAS Projects table) — update `<title>` (from `TITLE`) and `var _e` inside the GAS iframe IIFE (the obfuscated deployment URL — when `DEPLOYMENT_ID` is not a placeholder, construct the full URL `https://script.google.com/macros/s/{DEPLOYMENT_ID}/exec`, reverse the string, then base64-encode the result; when `DEPLOYMENT_ID` is a placeholder, set `_e` to `''`). To generate the encoded value: `echo -n 'https://script.google.com/macros/s/{DEPLOYMENT_ID}/exec' | rev | base64 -w0`. **Reverse sync**: if `<page-name>.gs` was edited and a config-tracked variable was changed directly in the code, update `<page-name>.config.json` to match — the config file must always reflect the current values. **This item is never skipped** — it applies on every repo including the template repo
17. **Page & GAS changelogs** — if any embedding HTML page in `live-site-pages/` or any `.gs` file in `googleAppsScripts/` was modified, add a user-facing entry to the corresponding changelog in `repository-information/changelogs/` (`<page-name>html.changelog.md` for pages, `<page-name>gs.changelog.md` for GAS scripts). These changelogs are **user-facing** — they describe what a visitor to the webpage would notice or what a user of the script would experience, not internal/backend details. **Writing style**: describe changes from the user's perspective. Say "Faster page loading" not "Optimized database queries". Say "Fixed login button not responding on mobile" not "Fixed event listener delegation in auth.js". Never mention file names, function names, commit SHAs, deployment IDs, or internal architecture. Categories follow Keep a Changelog: `### Added`, `### Changed`, `### Fixed`, `### Removed`. Format: `- Description` (no timestamps per entry). **Versioned release sections** — on the push commit, move entries from `## [Unreleased]` into a new version section. For page changelogs use the page version with repo cross-reference: `## [vXX.XXw] (vXX.XXr) — YYYY-MM-DD HH:MM:SS AM/PM EST`. For GAS changelogs use the GAS version with repo cross-reference: `## [XX.XXg] (vXX.XXr) — YYYY-MM-DD HH:MM:SS AM/PM EST`. The repo version in parentheses lets the developer trace which push introduced the change. No SHA backfill — these are user-facing, not developer-facing. `## [Unreleased]` is then left empty. **Archive rotation** — same 50-section rotation logic as the repo CHANGELOG (documented in `repository-information/CHANGELOG-archive.md`). Rotate to `<page-name>html.changelog-archive.md` or `<page-name>gs.changelog-archive.md` respectively (both in `repository-information/changelogs/`). **Capacity counter** — update the `` `Sections: X/50` `` counter after creating the new version section. **When no user-visible change occurred** — if the HTML/GAS change is purely internal (e.g. code refactoring with no visible effect), skip the changelog entry. Only add entries when the user's experience is affected. **Skip on template repo when `TEMPLATE_DEPLOY` = `Off`** — when skipped, keep changelogs clean with `*(No changes yet)*` under `## [Unreleased]`. **When `TEMPLATE_DEPLOY` is switched `Off`**, reset all page and GAS changelogs and their archives the same way as the repo CHANGELOG
18. **Unique file naming** — when creating or renaming a file, no two files anywhere in the repo may share the same filename (basename). If a new file would collide with an existing filename in a different directory, add a distinguishing identifier to the name. The convention follows what is already established: `html` for HTML-page-related files (e.g. `indexhtml.changelog.md`, `indexhtml.version.txt`), `gs` for GAS-related files (e.g. `indexgs.changelog.md`, `indexgs.version.txt`), and descriptive prefixes for other categories. Files that track similar concepts across different subsystems (e.g. changelogs for a page vs. changelogs for its GAS script) must always be disambiguated — the reader should be able to identify which subsystem a file belongs to from its name alone, without needing the directory path. **This item is never skipped** — it applies on every repo including the template repo
16. **Repo version bump** — on the **push commit** (the final commit before `git push`), increment the version in `repository-information/repository.version.txt` by 0.01 (e.g. `v01.00r` → `v01.01r`). The `r` suffix stands for "repository" and distinguishes it from page versions (`w`) and GAS versions (`g`). This version is the **single source of truth** for the overall repository version — it bumps once per push, not on every commit. Intermediate commits within the same session do NOT bump the repo version. **Skip on template repo when `TEMPLATE_DEPLOY` = `Off`** — when skipped, reset `repository.version.txt` to `v01.00r` so forks inherit a clean starting version

### Maintaining these checklists
- The Session Start, Pre-Commit, and Pre-Push checklists are the **single source of truth** for all actionable rules. Detailed sections below provide reference context only
- When adding new rules to CLAUDE.md, add the actionable check to the appropriate checklist and put supporting details in a reference section — do not duplicate the rule in both places
- When editing CLAUDE.md, check whether any existing reference section restates a checklist item — if so, remove the duplicate and add a `*Rule: see ... Checklist item #N*` pointer instead
- **Content placement** — CLAUDE.md must stay focused on rules and process that Claude enforces every session (checklists, behavioral rules, formatting requirements). Domain-specific coding knowledge, architectural reference, and detailed technical context that Claude only needs when working on specific features should live in separate reference files (e.g. `repository-information/CODING-GUIDELINES.md`, `repository-information/TOKEN-BUDGETS.md`). Replace the extracted content with a one-line pointer: `*See \`repository-information/FILE.md\` — section "X"*`. Claude reads these files on demand when the relevant feature area is being worked on
- **Section positioning** — when adding a new `##` section, place it in the correct attention zone per the Section Placement Guide (see below). Mandatory per-session actions go in the primacy zone; behavioral/meta-rules in the upper body; reference material in the lower body; high-frequency per-response formatting in the recency zone
- **Section separators** — every `##` section in CLAUDE.md must end with a double-ruled banner. When adding a new `##` section, add the following block between the end of its content and the next `##` heading:
  ```
  ---
  > **--- END OF SECTION NAME ---**
  ---
  ```
  Replace `SECTION NAME` with the section's heading in ALL CAPS. The only exception is Developer Branding (the final section), which has no separator after it

### Token Budget Reference
*See `repository-information/TOKEN-BUDGETS.md` — section "Pre-Commit Checklist"*

---
> **--- END OF PRE-COMMIT CHECKLIST ---**
---

## Pre-Push Checklist
**Before every `git push`, verify ALL of the following:**

1. **Branch name** — confirm the branch being pushed is the `claude/*` branch assigned to THIS session. If a different branch name is checked out (e.g. `main`, or a `claude/*` branch from a prior session), STOP — do not push. Switch to the correct branch or ask the user for guidance. **This item is never skipped** — it applies on every repo including the template repo
2. **Remote URL** — run `git remote -v` and verify the origin URL matches the repo this session is working on. If the URL has changed or does not match (e.g. context drifted mid-session to a different repo), STOP — do not push. This catches context drift that occurred after the Session Start Checklist and after Pre-Commit item #0
3. **Commit audit** — run `git log origin/main..HEAD --oneline` and verify that every commit listed was created by THIS session. Look for commit messages, timestamps, or SHAs that do not match work performed in this session. If any commit appears to be inherited from a prior session or a different repo, STOP — do not push. Remove the stale commits (interactive rebase or reset) before proceeding, or ask the user for guidance
4. **No cross-repo content** — run `git diff origin/main..HEAD` and scan for references to a different org/repo than the current one. Specifically, look for hardcoded org names or repo names in URLs, import paths, or configuration that do not match the current repo's `org/repo` identity (from `git remote -v`). References to `ShadowAISolutions/htmltemplateautoupdate` are expected when `IS_TEMPLATE_REPO` matches the current repo name and in provenance markers — only flag references to a *third* repo that is neither the current repo nor the template origin. If suspicious cross-repo content is found, STOP and ask the user to verify before pushing
5. **Push-once enforcement** — verify that the `claude/*` branch does not currently exist on the remote. Run `git ls-remote origin <branch-name>` — if the branch does not exist, pushing is safe (it creates the branch fresh with no queued-workflow collision). If the branch still exists, the workflow hasn't finished yet — wait ~5 seconds and check again (up to 4 checks, ~20s max wait). Only if the branch **still exists after retries** should you flag a `🚧🚧BLOCKED🚧🚧` to the user explaining push-once enforcement. There is one additional exception:
   - **Failed workflow recovery** — the branch still exists on the remote but the merge did not happen (workflow failed). In this case a re-push is needed to re-trigger the workflow

### Abort protocol
If any pre-push check fails, do NOT proceed with `git push`. Instead:
- State which check failed and why
- Do NOT silently fix the issue and push — the failure may indicate context contamination that requires user judgment
- Ask the user how to proceed (discard commits, fix and retry, or abandon the push)

### Token Budget Reference
*See `repository-information/TOKEN-BUDGETS.md` — section "Pre-Push Checklist"*

---
> **--- END OF PRE-PUSH CHECKLIST ---**
---

## Initialize Command
If the user's prompt is just **"initialize"** (after the Session Start Checklist has completed):
1. **Verify placeholders are resolved** — confirm that `repository-information/STATUS.md` no longer contains `*(deploy to activate)*` (drift check step #4 should have replaced it). If it's still there, replace it now with `[View](https://YOUR_ORG_NAME.github.io/YOUR_REPO_NAME/)` (resolved values)
2. Update the `Last updated:` timestamp in `README.md` to the real current time
3. Commit with message `Initialize deployment`
4. Push to the `claude/*` branch (Pre-Push Checklist applies)
5. **Affected URLs** — upon initialization, all pages in `live-site-pages/` are treated as **affected** (marked with `✏️`) because the deployment makes them live for the first time. Even though the HTML files themselves were not edited, the user-facing experience changed — the pages went from non-existent to deployed. This is an indirect affect similar to how editing a `.gs` file affects its embedding page

**No version bumps** — initialization never bumps any version: not `html.version.txt` files, not `repository.version.txt`, not `gs.version.txt` files, not `.gs` VERSION, not HTML meta tags — no version-tracking files of any kind. It deploys whatever versions already exist. This applies on both the template repo and forks.

This triggers the auto-merge workflow, which merges into `main` and deploys to GitHub Pages — populating the live site for the first time. No other changes are needed.

---
> **--- END OF INITIALIZE COMMAND ---**
---

## Execution Style
- For clear, straightforward requests: **just do it** — make the changes, commit, and push without asking for plan approval
- Only ask clarifying questions when the request is genuinely ambiguous or has multiple valid interpretations
- Do not use formal plan-mode approval workflows for routine tasks (version bumps, file moves, feature additions, bug fixes, etc.)
- **Large file writes** — when creating a new file >500 lines, a single Write tool call can take 30-60+ seconds of wall-clock time during which no visible progress appears to the user, creating the impression of a stall. To mitigate this: (1) **always** output a brief status message before the Write call (e.g. "Writing ~1200-line file, this will take a moment...") so the user knows work is in progress, and (2) when practical, Write a smaller skeleton first then use Edit calls to fill in sections — but do not force this if a single Write is simpler and less error-prone. For existing files this is a non-issue — Edit calls are already incremental by nature

---
> **--- END OF EXECUTION STYLE ---**
---

## Page-Scope Commands
Commands that can target individual pages (maintenance mode, deactivate maintenance, and any future per-page commands) require the user to specify **which pages** to act on. Rules:

- **"all pages"** — if the user explicitly says "all pages" (or equivalent: "every page", "all of them"), apply to all pages in `live-site-pages/`. No need to ask
- **Specific pages named** — if the user names specific pages (e.g. "maintenance mode on index" or "put test in maintenance"), apply only to those pages
- **No specification** — if the user gives a page-scope command without specifying which pages or saying "all" (e.g. just "maintenance mode"), **ask which pages** using `AskUserQuestion`. List all available pages as options, plus an "All pages" option
- **Repo-wide commands are exempt** — commands that inherently apply to the entire repo (e.g. "phantom update", "initialize") are not page-scope commands and do not require page specification. These always apply to all files by definition

This rule applies to any future commands that could target a subset of pages — when adding a new per-page command, it automatically inherits this scope-checking behavior.

---
> **--- END OF PAGE-SCOPE COMMANDS ---**
---

## Pushback & Reasoning
- When you have a well-founded technical or design opinion, **make your case and defend it** — do not fold at the first sign of disagreement. Explain the reasoning clearly, cite concrete consequences, and hold your position until one of two things happens: (a) the user presents a counterargument that genuinely changes the calculus, or (b) the user explicitly overrides the decision (e.g. "do it anyway", "I understand, but I want X")
- A user questioning your recommendation is not the same as overriding it — questions are an invitation to explain further, not to capitulate
- If you are eventually convinced the user is right, say so honestly and explain what changed your mind
- If the user overrides you despite your reasoning, comply without passive-aggression — state the tradeoff once, then execute cleanly

---
> **--- END OF PUSHBACK & REASONING ---**
---

## Continuous Improvement
- When you encounter a struggle, mistake, or missed step during a session — something that took extra effort to debug, a rule you misapplied, a checklist item you forgot, or a pattern that tripped you up — **bring it up to the user** before silently moving on
- Propose a specific addition or modification to CLAUDE.md that would prevent the same issue in future sessions. Explain what went wrong, why, and how the proposed change fixes it
- **Wait for user approval** before making the CLAUDE.md change — the user decides whether the fix is worth adding. Some struggles are one-off and don't need a permanent rule; others reveal a systemic gap that should be documented
- This applies to any type of difficulty: ambiguous instructions that led to the wrong action, missing context that caused a wrong assumption, procedural steps that are error-prone in practice, or edge cases that the current rules don't cover
- **Conflict cleanup** — when adding or modifying a rule (whether from self-improvement or a user request), scan the rest of CLAUDE.md for any existing text that directly conflicts with the new rule. Remove or update the conflicting text in the same commit. A new rule that says "do X" must not coexist with an old rule that says "do not-X" — the old rule must be deleted or modified to align. This applies to both explicit contradictions (opposite instructions) and implicit ones (e.g. a format spec that references a removed field). The improvement is incomplete if conflicting instructions remain elsewhere in the file
- Recent examples of this pattern in action:
  - SHA backfill after rebase: `git log -1` returns the workflow's commit, not the version commit → ultimately resolved by removing SHA from CHANGELOG headers entirely (SHA is available via `git log` and the COMMIT LOG section in chat output)
  - Confident wrong assertion (twice): stated "Yes — I absolutely can" see a commit SHA before pushing, then hit "Wait. No." mid-reasoning when the chicken-and-egg problem emerged. Did the same thing again in the follow-up ("Yes — I can insert the SHA after committing") before catching the amend-changes-SHA problem → added "Validate Before Asserting" rule covering both opening assertions and mid-reasoning assertions, with explicit "Wait. No." pattern warning

---
> **--- END OF CONTINUOUS IMPROVEMENT ---**
---

## Solution Depth
- When troubleshooting a problem or designing a solution, **do not stop at the first plausible approach**. The first idea is often surface-level — it addresses symptoms rather than root causes, or it works but with visible tradeoffs (eaten clicks, noticeable overlays, timing hacks). Before proposing solutions to the user, go deeper:
  1. **Research the problem space** — read the relevant code, understand the full lifecycle, and identify the actual root cause. Use subagents and web searches proactively to explore browser APIs, specs, and platform behaviors that might offer a cleaner path
  2. **Exhaust creative angles** — consider approaches from different layers of the stack (CSS, JS, browser APIs, spec-level behaviors, server-side). The best solutions often come from discovering that the platform already solves the problem at a lower level (e.g. User Activation v2 propagating activation across frames) rather than building workarounds at a higher level
  3. **Optimize for user experience and security** — rank solutions by how invisible they are to the user and how few side effects they introduce. A solution that requires zero user awareness and zero wasted interactions always beats one that "works but you'll notice a flash" or "works but eats the first click"
  4. **Present the strongest option first** — when presenting choices, lead with the most elegant solution. Include alternatives for completeness, but make it clear which one you'd ship
- **The default depth is maximum depth.** Do not wait for the user to say "think harder" or "be more creative" — that level of rigor should be the baseline for every troubleshooting and design task. Quick tasks (version bumps, timestamp updates, straightforward edits) do not need this treatment — apply it when the problem has genuine design space to explore

---
> **--- END OF SOLUTION DEPTH ---**
---

## Confidence Disclosure
- When proposing a solution, **explicitly flag the confidence level** — distinguish between behavior you have confirmed (documentation, tested, directly observed) and behavior you have inferred by combining separate facts into an untested conclusion
- This is broader than the Web Search Confidence rule (which covers web search results specifically). This applies to **any** solution — whether derived from research, reasoning, code reading, or experience. If the solution depends on two or more individually-confirmed facts working together in a way no source explicitly confirms, that combination is an untested inference and must be disclosed
- **Format**: when presenting a solution that involves logical leaps, include a brief confidence note — e.g. *"Each piece is documented individually, but I haven't found confirmation they work together in this exact scenario"* or *"This is a logical inference — [specific assumption] is unverified"*
- **Do not bury caveats** — place them prominently near the recommendation, not in a footnote or afterthought. The user should see the confidence level before deciding to adopt the approach
- Quick tasks with well-established patterns (version bumps, standard API usage, documented configurations) do not need disclosure — apply this when the solution involves novel combinations or edge-case reasoning

---
> **--- END OF CONFIDENCE DISCLOSURE ---**
---

## Validate Before Asserting
- **Reason first, conclude second.** When answering a factual question (especially one involving technical mechanics, feasibility, or "can this be done?"), walk through the reasoning *before* stating a conclusion. The conclusion should emerge from the analysis, not precede it. When exploring a multi-step solution mid-response, trace each step to its consequence *before* asserting it works. If step 3 depends on step 2 not invalidating step 1, verify that before writing "Yes — I can"
- **The test:** before writing "Yes", "No", "Absolutely", "I can", or any definitive claim — whether as a response opener or mid-reasoning — ask yourself: "Have I actually traced this to its conclusion, or am I pattern-matching to a plausible answer?" If the full chain of implications hasn't been verified, present the reasoning as exploration ("Let me think through whether...") rather than assertion ("Yes, here's how")
- **"Wait. No." moments are acceptable — and valuable.** If you find yourself writing "Wait", "Actually", "Hmm, but", or any self-correction mid-stream, that's a **"Wait. No." moment** — evidence that you asserted before fully validating. These moments are fine; what matters is what you do with them. Every "Wait. No." moment is a **Continuous Improvement trigger**: after resolving the issue, flag it to the user and propose a CLAUDE.md addition or modification that would prevent the same incorrect initial assumption in future sessions (per the Continuous Improvement section). The goal is not to eliminate "Wait. No." moments entirely — it's to learn from each one so the same mistake doesn't recur
- This does not apply to well-established facts or routine operations (e.g. "Yes, I can edit that file") — only to claims that require non-trivial reasoning or involve edge cases, feasibility questions, or technical mechanics

---
> **--- END OF VALIDATE BEFORE ASSERTING ---**
---

## User-Perspective Reasoning
- When organizing, ordering, or explaining anything in this repo, **always reason from the user's perspective** — how they experience the flow, read the output, or understand the structure. Never reason from internal implementation details (response-turn boundaries, tool-call mechanics, API round-trips) when the user-facing view tells a different story
- The trap: internal mechanics can suggest one ordering/grouping, while the user's actual experience suggests another. When these conflict, the user's experience wins every time
- Before finalizing any structural decision (ordering lists, grouping related items, naming things), ask: "does this match what the user sees and expects?" If the answer requires knowing implementation details to make sense, the structure is wrong
- **Example — bookend ordering:** the Bookend Summary table is ordered by the chronological flow as the user experiences it. AWAITING HOOK and HOOK FEEDBACK may technically span two response turns, but the user sees them as consecutive events before the final summary. The end-of-response sections (UNAFFECTED URLS through SUMMARY/AFFECTED URLS) always come last before CODING COMPLETE because that's the user's experience — the wrap-up happens once, at the very end, after all work including hook resolution is done

---
> **--- END OF USER-PERSPECTIVE REASONING ---**
---

## Section Placement Guide (CLAUDE.md Structure)
When adding, moving, or reorganizing `##` sections in this file, follow the attention zone model below. LLMs process long documents with uneven attention — instructions near the top (**primacy zone**) and bottom (**recency zone**) are recalled most reliably, while the middle (**body zone**) receives progressively less attention as the file grows.

### Attention zones

| Zone | Position | What belongs here | Recall reliability |
|------|----------|-------------------|--------------------|
| **Primacy zone** | Sections 1–6 | Mandatory checklists, safety gates, and instructions that must execute every session without exception (Template Variables, Session Start Checklist, Template Repo Guard, Pre-Commit Checklist, Pre-Push Checklist, Initialize Command) | Highest — first ~15% of content is almost never missed |
| **Upper body** | Sections 7–10 | Behavioral rules and meta-rules that shape how work is done — execution style, pushback policy, user-perspective reasoning, and this placement guide | High — still in the first third of the file |
| **Lower body** | Sections 11–N-3 | Reference material, detailed specifications, and context needed only when working on specific features (version bumping, build version, commit naming, architecture nodes, documentation sync, link reference, merge prevention, etc.) | Moderate to low — the "dead zone" where instructions are most likely to be missed on long files |
| **Recency zone** | Sections N-2 to N | High-volume formatting rules that are needed on every response and benefit from recency bias (Chat Bookends, Developer Branding) | High — last ~15% of content gets a recall boost |

### Placement rules for new content
1. **Mandatory per-session actions** (checklists, gates, safety checks) → primacy zone. These must execute reliably every session regardless of context length
2. **Behavioral constraints** (how to reason, when to push back, execution approach) → upper body. These shape decision-making and must be internalized early in processing
3. **Meta-rules about CLAUDE.md itself** (this section, "Maintaining these checklists") → upper body. Structural rules must be loaded before any content modification begins
4. **Feature-specific reference material** (version formats, directory layouts, link patterns, architectural details) → lower body. These are consulted on-demand when the relevant feature is being worked on — they don't need high baseline recall
5. **High-frequency per-response formatting** (bookend markers, timestamps, end-of-response blocks) → recency zone. Chat Bookends is ~220 lines and applies to every single response — placing it last leverages recency bias to ensure formatting compliance
6. **Developer Branding always stays last** — this is a fixed constraint (the section itself says so)

### When to re-evaluate positioning
- If CLAUDE.md grows past ~900 lines, the dead zone expands — consider extracting lower-body sections to `repository-information/` reference files with one-line pointers (per the "Content placement" rule in "Maintaining these checklists")
- If a lower-body section starts being missed in practice (instructions skipped or forgotten), move it toward the primacy or recency zone — observed misses override theoretical positioning
- After any major reorganization, verify the section order still follows this zone model by running `grep -n '^## ' CLAUDE.md` and checking the sequence

### What this does NOT control
- **Within-section ordering** (e.g. the order of items inside Pre-Commit Checklist) is governed by the section's own logic, not by attention zones
- **Content extraction to reference files** is governed by the "Content placement" rule in "Maintaining these checklists" — this section only governs where `##` sections appear in CLAUDE.md itself

---
> **--- END OF SECTION PLACEMENT GUIDE ---**
---

## Version Bumping
*Rule: see Pre-Commit Checklist item #1. Reference details below.*
- The `VERSION` variable is near the top of each `.gs` file (look for `var VERSION = "..."`)
- Format includes a `g` suffix: e.g. `"01.13g"` → `"01.14g"`
- Each GAS project also has a `<page-name>gs.version.txt` that mirrors the `VERSION` variable value (e.g. `01.00g`). This file is bumped alongside `VERSION` by Pre-Commit #1
- Do NOT bump VERSION if the commit doesn't touch the `.gs` file

### GAS Projects
Each GAS project has a code file and a corresponding embedding page. Register them in the table below as you add them. *For step-by-step instructions on adding a new GAS deploy step to the workflow, see the "HOW TO ADD A NEW GAS PROJECT" comment block at the top of `.github/workflows/auto-merge-claude.yml`.*

| Project | Code File | Config File | Embedding Page |
|---------|-----------|-------------|----------------|
| Index | `googleAppsScripts/Index/index.gs` | `googleAppsScripts/Index/index.config.json` | `live-site-pages/index.html` |
| Test | `googleAppsScripts/Test/test.gs` | `googleAppsScripts/Test/test.config.json` | `live-site-pages/test.html` |

---
> **--- END OF VERSION BUMPING ---**
---

## Build Version (Auto-Refresh for embedding pages)
*Rules: see Pre-Commit Checklist items #2, #3, #4. Reference details below.*
- The version lives **solely** in `<page-name>html.version.txt` — the HTML contains no hardcoded version
- Format uses pipe delimiters with the version in the middle field: e.g. `|v01.11w|` → `|v01.12w|`
- Each embedding page fetches `html.version.txt` on load to establish its baseline version, then polls every 10 seconds — when the deployed version differs from the loaded version, it auto-reloads

### Auto-Refresh via html.version.txt Polling
- **All embedding pages must use the `html.version.txt` polling method** — do NOT poll the page's own HTML
- **Version file naming**: the version file must be named `<page-name>html.version.txt`, matching the HTML file it tracks (e.g. `index.html` → `indexhtml.version.txt`, `dashboard.html` → `dashboardhtml.version.txt`). The `html.version.txt` extension distinguishes HTML page version files from GAS version files (`<page-name>gs.version.txt`) and the repo version file (`repository.version.txt`)
- Each version file uses pipe delimiters: `|v01.08w|`. The version is always the middle field (between the pipes). The polling logic splits on `|` and reads `parts[1]`, stripping the `v` prefix for internal comparison. The pipes stay in place at all times — switching to maintenance mode only changes the first field
- **html.version.txt is the single source of truth** — the HTML pages contain a `<meta name="build-version">` tag for informational purposes, but the polling logic does **not** read it. On page load, the polling logic immediately fetches html.version.txt, stores the version as the baseline, creates the version indicator pill, and begins the 10-second polling loop. This means bumping the version in html.version.txt alone (without editing the HTML meta tag) will trigger a reload correctly — after the reload, the page establishes the new version as its baseline, preventing an infinite loop. The meta tag is kept in sync with html.version.txt during commits for visibility, but it is never involved in the reload mechanism
- The polling logic fetches the version file (~7 bytes) instead of the full HTML page, reducing bandwidth per poll from kilobytes to bytes
- URL resolution: derive the version file URL relative to the current page's directory, using the page's own filename. See the template file (`live-site-templates/AutoUpdateOnlyHtmlTemplate.html`) for the implementation
- **The `if (!pageName)` fallback is critical** — when a page is accessed via a directory URL (e.g. `https://example.github.io/myapp/`), `pageName` resolves to an empty string. Without the fallback to `'index'`, the poll fetches `html.version.txt` (wrong file) and triggers an infinite reload loop
- Cache-bust with a query param: `fetch(versionUrl + '?_cb=' + Date.now(), { cache: 'no-store' })`
- The template in `live-site-templates/AutoUpdateOnlyHtmlTemplate.html` already implements this pattern — use it as a starting point for new projects

### Maintenance Mode via html.version.txt
The html.version.txt polling system supports a **maintenance mode** that displays a full-screen orange overlay when the first field is `maintenance`. The format always uses pipe (`|`) delimiters — you never need to add or remove pipes, just edit the fields:
- **Activate**: change the first field from empty to `maintenance` **and** fill the third field with the **exact display string** — the JS renders it verbatim with no reformatting. Use `As of:` prefix and pre-formatted date (e.g. `|v01.02w|` → `maintenance|v01.02w|As of: 10:00:00 PM EST 02/26/2026`). To get the value, run `TZ=America/New_York date '+As of: %I:%M:%S %p EST %m/%d/%Y'`. Custom messages also work (e.g. `maintenance|v01.02w|Back online soon!` → displays "Back online soon!")
- **Deactivate**: clear the first field back to empty (e.g. `maintenance|v01.02w|` → `|v01.02w|`)
- When the polling logic detects the `maintenance` prefix, it displays an orange full-screen overlay with the developer logo centered and a "🔧This Webpage is Undergoing Maintenance🔧" title — similar to the green "Website Ready" splash but persistent
- The overlay stays visible as long as the html.version.txt content starts with `maintenance` — it does not auto-dismiss
- The version indicator pill remains visible on top of the maintenance overlay (the maintenance overlay uses `z-index: 9998`, below the version indicator's `z-index: 9999`)
- When the `maintenance` prefix is removed: if the underlying version also changed, the page auto-reloads; if the version is unchanged, the overlay fades out gracefully
- **No version bump for standalone maintenance activation** — if the user's request is solely to activate (or deactivate) maintenance mode and nothing else, do NOT bump the version in html.version.txt or the HTML meta tag. Only edit the first and third fields of html.version.txt (the `maintenance` prefix and the timestamp/message). The version field (middle) stays unchanged. If the user requests maintenance mode **combined** with other changes that would normally trigger a version bump (e.g. editing the HTML page, updating a `.gs` file), then bump the version as usual per Pre-Commit Checklist item #2

### New Embedding Page Setup Checklist
When creating a **new** HTML embedding page, follow every step below:

1. **Copy the template** — start from `live-site-templates/AutoUpdateOnlyHtmlTemplate.html`, which already includes:
   - Version file polling logic (fetches html.version.txt on load, then polls every 10 seconds)
   - Version indicator pill (bottom-right corner)
   - Green "Website Ready" splash overlay + sound playback
   - Orange "Under Maintenance" splash overlay (triggered by `maintenance|` prefix in html.version.txt)
   - AudioContext handling and screen wake lock
2. **Choose the directory** — create a new subdirectory under `live-site-pages/` named after the project (e.g. `live-site-pages/my-project/`)
3. **Create the version file** — place a `<page-name>html.version.txt` file in the **same directory** as the HTML page (e.g. `indexhtml.version.txt` for `index.html`), containing the initial version string in pipe-delimited format (e.g. `|v01.00w|`). This is the **single source of truth** for the page version — the HTML contains no hardcoded version
4. **Update the polling URL in the template** — ensure the JS version-file URL derivation matches the HTML filename (the template defaults to deriving it from the page's own filename)
5. **Create `sounds/` directory** — copy the `sounds/` folder (containing `Website_Ready_Voice_1.mp3`) into the new page's directory so the splash sound works
6. **Set the initial version** — set `<page-name>html.version.txt` to `|v01.00w|`
7. **Update the page title** — replace `YOUR_PROJECT_TITLE` in `<title>` with the actual project name
8. **Register in GAS Projects table** — if this page embeds a GAS iframe, add a row to the GAS Projects table in the Version Bumping section above
9. **Create GAS config file** — if this page embeds a GAS iframe, copy `googleAppsScripts/AutoUpdateOnlyHtmlTemplate/AutoUpdateOnlyHtmlTemplate.config.json` into the new GAS project directory, renaming it to `<page-name>.config.json` (e.g. `googleAppsScripts/MyProject/my-project.config.json`). Fill in the project-specific values. This is the single source of truth for `TITLE`, `DEPLOYMENT_ID`, `SPREADSHEET_ID`, `SHEET_NAME`, and `SOUND_FILE_ID` — Pre-Commit item #15 syncs these values to `<page-name>.gs` and the embedding HTML
10. **Create GAS version file and changelog** — if this page has a GAS project, copy `AutoUpdateOnlyHtmlTemplategs.version.txt` into the GAS project directory as `<page-name>gs.version.txt` (initial value `01.00g`). Also copy `repository-information/changelogs/AutoUpdateOnlyHtmlTemplategs.changelog.md` and `repository-information/changelogs/AutoUpdateOnlyHtmlTemplategs.changelog-archive.md` into `repository-information/changelogs/` as `<page-name>gs.changelog.md` and `<page-name>gs.changelog-archive.md`, replacing `YOUR_PROJECT_TITLE` with the project name
11. **Add developer branding** — ensure `<!-- Developed by: DEVELOPER_NAME -->` is the last line of the HTML file
12. **Create page changelog** — copy `repository-information/changelogs/AutoUpdateOnlyHtmlTemplatehtml.changelog.md` into `repository-information/changelogs/` as `<page-name>html.changelog.md`. Replace `YOUR_PROJECT_TITLE` with the page's human-readable title and update the archive link filename. Also copy `repository-information/changelogs/AutoUpdateOnlyHtmlTemplatehtml.changelog-archive.md` as `<page-name>html.changelog-archive.md` and update its title and changelog link filename

### Directory Structure (per embedding page)
```
live-site-pages/
├── <page-name>/
│   ├── index.html               # The embedding page (from template)
│   ├── indexhtml.version.txt     # Tracks index.html version (e.g. "|v01.00w|")
│   └── sounds/
│       └── Website_Ready_Voice_1.mp3
```
For pages that live directly in `live-site-pages/` (not in a subdirectory), the version file and `sounds/` folder sit alongside the HTML file (e.g. `live-site-pages/index.html` + `live-site-pages/indexhtml.version.txt`).

Per-page and per-GAS changelogs are centralized in `repository-information/changelogs/` (e.g. `indexhtml.changelog.md`, `indexgs.changelog.md`) — see Pre-Commit item #17.

---
> **--- END OF BUILD VERSION ---**
---

## Commit Message Naming
*Rule: see Pre-Commit Checklist item #9. Reference details below.*
- All version types use the `v` prefix — suffix indicates type: `r` = repository, `g` = Google Apps Script, `w` = website
- The **push commit** (final commit before `git push`) starts with the repo version prefix (`v01.XXr`) since repo version bumps on the push commit
- When `.gs` or HTML versions are also bumped on the push commit, append them in order: `r`, `g`, `w`
- **Intermediate commits** (earlier commits in the same session) use `g`/`w` prefixes only if those versions were bumped on that commit; otherwise, use a plain descriptive message
- Push commit examples:
  - `v01.05r Fix typo in CLAUDE.md` (repo-only change)
  - `v01.06r v01.19g Fix sign-in popup to auto-close after authentication`
  - `v01.07r v01.19g v01.12w Add auth wall with build version bump`
- Intermediate commit examples:
  - `v01.14g Fix sign-in popup timing` (GAS change, no repo version)
  - `v01.02w Update page layout` (HTML change, no repo version)
  - `Fix typo in CLAUDE.md` (no version bumps at all)
- SHA backfill commit: always uses `Backfill CHANGELOG SHA` — no version prefix, exempt from all push commit rules (see Pre-Commit #7)

---
> **--- END OF COMMIT MESSAGE NAMING ---**
---

## ARCHITECTURE.md Structural Updates
*Rule: see Pre-Commit Checklist item #6. Reference details below.*

The Mermaid diagram in `repository-information/ARCHITECTURE.md` shows the project's file structure and relationships. It is updated only when the project structure changes (files added, moved, or deleted) — **not** on version bumps. Version numbers are not displayed in diagram nodes; STATUS.md serves as the version dashboard.

### Adding new pages
When a new embedding page is created (see New Embedding Page Setup Checklist), add corresponding nodes to the diagram:
- A page node: `NEWPAGE["page-name.html"]`
- A version file node: `NEWVER["page-namehtml.version.txt"]`

---
> **--- END OF ARCHITECTURE.MD STRUCTURAL UPDATES ---**
---

## GAS Project Config (config.json)
*Rule: see Pre-Commit Checklist item #15. Reference details below.*

Each GAS project directory contains a `<page-name>.config.json` file that is the **single source of truth** for project-unique variables. This mirrors the `version.txt` pattern — one small file to edit, with sync rules that propagate values to `<page-name>.gs` and the embedding HTML page.

### Naming convention
All GAS files are named after the HTML page they serve — mirroring the `indexhtml.version.txt` pattern:
- `index.gs` — GAS code for `index.html`
- `index.config.json` — config for `index.html`
- `dashboard.gs` — GAS code for `dashboard.html`
- `dashboard.config.json` — config for `dashboard.html`

The `.config.json` double extension ensures the config file sorts **after** the `.gs` file alphabetically (same reasoning as `html.version.txt` sorting after `.html`).

### Config file contents

| Key | Description | Syncs to |
|-----|-------------|----------|
| `TITLE` | Project title shown in browser tabs and GAS UI | `<page-name>.gs` `var TITLE`, HTML `<title>` tag |
| `DEPLOYMENT_ID` | GAS deployment ID (`AKfycb...` string) | `<page-name>.gs` `var DEPLOYMENT_ID`, HTML `var _e` inside GAS IIFE (reverse+base64 encoded) |
| `SPREADSHEET_ID` | Google Sheets ID for version tracking | `<page-name>.gs` `var SPREADSHEET_ID` |
| `SHEET_NAME` | Sheet tab name | `<page-name>.gs` `var SHEET_NAME` |
| `SOUND_FILE_ID` | Google Drive file ID for deploy notification sound | `<page-name>.gs` `var SOUND_FILE_ID` |

### What is NOT in config.json
- `VERSION` — auto-bumped by Pre-Commit item #1, lives only in `<page-name>.gs`
- `GITHUB_OWNER`, `GITHUB_REPO`, `FILE_PATH` — derived from repo structure, managed by init script
- `EMBED_PAGE_URL`, `SPLASH_LOGO_URL` — repo-wide settings, managed by init script
- `GITHUB_BRANCH` — always `main`

### Obfuscated deployment URL (var _e inside GAS IIFE)
The encoded deployment URL lives in `var _e` inside the GAS iframe IIFE — not as a global variable. This keeps it out of the browser console and DevTools Sources panel. The decode logic is inline (no named function). Derivation from `DEPLOYMENT_ID`:
- If `DEPLOYMENT_ID` is not a placeholder:
  1. Construct the full URL: `https://script.google.com/macros/s/{DEPLOYMENT_ID}/exec`
  2. Reverse the URL string
  3. Base64-encode the reversed string
  4. Store as `var _e = 'encoded_value';` inside the GAS IIFE
- If `DEPLOYMENT_ID` is a placeholder (`YOUR_DEPLOYMENT_ID`) → `var _e = '';` (empty, IIFE exits early)

To generate via command line: `echo -n 'https://script.google.com/macros/s/{DEPLOYMENT_ID}/exec' | rev | base64 -w0`

The inline decode reverses this: `atob()` then string-reverse. The iframe is created dynamically via srcdoc trampoline (no `src` attribute set). This is obfuscation, not security — the Network tab still shows the URL

### Template config
`googleAppsScripts/AutoUpdateOnlyHtmlTemplate/AutoUpdateOnlyHtmlTemplate.config.json` contains placeholder values. When creating a new GAS project, copy it to the new project directory and fill in the real values.

---
> **--- END OF GAS PROJECT CONFIG ---**
---

## Keeping Documentation Files in Sync
*Mandatory rules: see Pre-Commit Checklist items #5, #6, #7, #8. Reference table below for additional files to consider.*

| File | Update when... |
|------|---------------|
| `.gitignore` | New file types or tooling is introduced that generates artifacts (e.g. adding Node tooling, Python venvs, build outputs) |
| `.editorconfig` | New file types are introduced that need specific formatting rules |
| `CONTRIBUTING.md` | Development workflow changes, new conventions are added to CLAUDE.md that contributors need to know |
| `SECURITY.md` | New attack surfaces are added (e.g. new API endpoints, new OAuth flows, new deployment targets) |
| `CITATION.cff` | Project name, description, authors, or URLs change |
| `.github/ISSUE_TEMPLATE/*.yml` | New project areas are added (update the "Affected Area" / "Area" dropdown options) |
| `.github/PULL_REQUEST_TEMPLATE.md` | New checklist items become relevant (e.g. new conventions, new mandatory checks) |

Update these only when the change is genuinely relevant — don't force unnecessary edits.

---
> **--- END OF KEEPING DOCUMENTATION FILES IN SYNC ---**
---

## Internal Link Reference
*Rule: see Pre-Commit Checklist item #12. Correct relative paths below.*

Files live in three locations: repo root, `.github/`, and `repository-information/`. Cross-directory links must use `../` to traverse up before descending into the target directory.

### Why community health files live at root (not `.github/`)
Community health files (`CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`) live at root so relative links resolve correctly in both GitHub blob-view and sidebar-tab contexts — files inside `.github/` break in the sidebar tab because `../` traverses GitHub's URL structure differently there.

### File locations
| File | Actual path |
|------|-------------|
| README.md | `./README.md` (root) |
| CLAUDE.md | `./CLAUDE.md` (root) |
| LICENSE | `./LICENSE` (root) |
| CODE_OF_CONDUCT.md | `./CODE_OF_CONDUCT.md` (root) |
| CONTRIBUTING.md | `./CONTRIBUTING.md` (root) |
| SECURITY.md | `./SECURITY.md` (root) |
| PULL_REQUEST_TEMPLATE.md | `.github/PULL_REQUEST_TEMPLATE.md` |
| ARCHITECTURE.md | `repository-information/ARCHITECTURE.md` |
| CHANGELOG.md | `repository-information/CHANGELOG.md` |
| CHANGELOG-archive.md | `repository-information/CHANGELOG-archive.md` |
| GOVERNANCE.md | `repository-information/GOVERNANCE.md` |
| IMPROVEMENTS.md | `repository-information/IMPROVEMENTS.md` |
| STATUS.md | `repository-information/STATUS.md` |
| SUPPORT.md | `repository-information/SUPPORT.md` |
| TODO.md | `repository-information/TODO.md` |
| Per-page changelogs | `repository-information/changelogs/<name>.changelog.md` |
| Per-page changelog archives | `repository-information/changelogs/<name>.changelog-archive.md` |

### Common cross-directory link patterns
| From directory | To file in `repository-information/` | Correct relative path |
|----------------|--------------------------------------|----------------------|
| `.github/` | `repository-information/SUPPORT.md` | `../repository-information/SUPPORT.md` |
| `.github/` | `repository-information/CHANGELOG.md` | `../repository-information/CHANGELOG.md` |

| From directory | To root files | Correct relative path |
|----------------|--------------|----------------------|
| `repository-information/` | `README.md` | `../README.md` |
| `repository-information/` | `CLAUDE.md` | `../CLAUDE.md` |
| `repository-information/` | `CONTRIBUTING.md` | `../CONTRIBUTING.md` |
| `repository-information/` | `SECURITY.md` | `../SECURITY.md` |
| `repository-information/` | `CODE_OF_CONDUCT.md` | `../CODE_OF_CONDUCT.md` |
| `.github/` | `README.md` | `../README.md` |
| `.github/` | `CLAUDE.md` | `../CLAUDE.md` |

---
> **--- END OF INTERNAL LINK REFERENCE ---**
---

## Merge Conflict Prevention (Auto-Merge Workflow)
The auto-merge workflow merges `claude/*` branches into `main` using `git merge --ff-only` with a `-X theirs` fallback. The `-X theirs` strategy auto-resolves content conflicts by preferring the incoming branch.

**Why this matters:** Every `claude/*` push triggers the workflow. If a prior workflow already merged a different claude branch into `main` (advancing `main` beyond this branch's fork point), a fast-forward is no longer possible. The fallback merge can hit content conflicts — especially in `CHANGELOG.md`, which is modified on every commit by the Pre-Commit Checklist. Without `-X theirs`, the merge fails with exit code 1, the auto-merge job fails, and the deploy job is skipped (its condition requires auto-merge success).

**Why `-X theirs` is safe:** The claude branch is always branched from `main` and contains strictly newer changes. When both sides modify the same lines (e.g. `CHANGELOG.md`'s `[Unreleased]` header timestamp), the claude branch's version is always the one we want. The `-X theirs` strategy resolves exactly this class of conflict — same-line edits where the incoming branch has the latest content.

**What this does NOT cover:** If the conflict is structural (e.g. a file was deleted on `main` but modified on the branch), `-X theirs` may not produce the desired result. These cases are rare in the `claude/*` workflow and would need manual intervention.

---
> **--- END OF MERGE CONFLICT PREVENTION ---**
---

## Commit SHA Tracking (Inherited Branch Guard)
The file `.github/last-processed-commit.sha` stores the SHA of the last commit that was successfully merged into `main` by the auto-merge workflow. This provides a deterministic guard against inherited branches on forks and imports.

**How it works:**
1. When a `claude/*` branch is pushed, the workflow reads `.github/last-processed-commit.sha` from **two sources**: the checked-out branch AND `origin/main` (after fetching)
2. If the incoming commit SHA (`github.sha`) matches the stored SHA from **either source**, the branch is inherited — it carries the exact same commit from the template repo. The workflow deletes the branch and skips
3. After a successful merge, the workflow updates the file with the new `HEAD` SHA on `main` **in the same push as the merge** — this is critical to eliminate the race window

**Why atomic merge+SHA update?** Previously, the merge and SHA update were two separate pushes. If a fork/import copied the repo between push 1 (merge) and push 2 (SHA update), the copy got the branch but the `.sha` file was stale — the guards couldn't detect it. Now the merge and SHA update land in a single `git push`, so there's no window for an inconsistent copy.

**Why two sources in the check?** The branch's copy of `.sha` has the value from when the branch was created. `origin/main`'s copy has the latest post-merge value. On a fork/copy, which copy the inherited branch carries depends on timing — checking both catches either scenario.

**Why this is bulletproof:**
- Git SHAs are deterministic — a fork/import inherits the exact same SHAs from the source repo
- A new legitimate commit always produces a different SHA (different author, timestamp, parent, etc.)
- The file travels with the repo on copy, carrying the "already processed" marker with it
- The atomic merge+SHA update eliminates the timing race between updates and copies
- The dual-source check (branch + origin/main) eliminates timing races between the SHA file value and the branch copy
- No API calls needed — the check is a file read and string compare, making it the fastest guard in the chain

**Relationship to other guards:** This is **Check 0a** in the guard chain. The branch-source check runs before the origin/main fetch (fast path — catches exact matches immediately). The origin/main-source check runs after the fetch (catches cases where the branch's copy is stale but main's copy is current). Both run before the already-merged check, the timestamp check, and the IS_TEMPLATE_REPO mismatch check.

**File management:** The `.sha` file is managed exclusively by the workflow — Claude Code does not modify it. The only exception is during initial repository creation, where the file is seeded with the current HEAD SHA.

---
> **--- END OF COMMIT SHA TRACKING ---**
---

## Phantom Edit (Timestamp Alignment)
- When the user asks for a **phantom edit** or **phantom update**, touch every file in the repo with a no-op change so all files share the same commit timestamp on GitHub
- **Skip all version bumps** — do NOT increment versions in `html.version.txt` files, `gs.version.txt` files, or `VERSION` in `.gs` files
- For text files: add a trailing newline. Also normalize any CRLF (`\r\n`) line endings to LF (`\n`) — run `sed -i 's/\r$//' <file>` on each text file before the no-op touch
- For binary files (e.g. `.mp3`): append a null byte
- **Reset `repository-information/CHANGELOG.md`** — remove all versioned release sections and all entries/category headings under `[Unreleased]`, leaving a fresh template (header, version suffix note, and an empty `## [Unreleased]` section with `*(No changes yet)*`). Also reset `repository-information/CHANGELOG-archive.md` — remove all archived sections and restore the `*(No archived sections yet)*` placeholder. **Also reset all page and GAS changelogs** — reset every `<page-name>html.changelog.md` and `<page-name>gs.changelog.md` in `repository-information/changelogs/` and their corresponding archive files the same way. Also reset GAS `<page-name>gs.version.txt` files to `01.00g`. This gives the repo a clean history starting point
- **Update `Last updated:` in `README.md`** — set the timestamp to the real current time (run `TZ=America/New_York date '+%Y-%m-%d %I:%M:%S %p EST'`). This is the only substantive edit besides the no-op touches
- Commit message: `Auto Update HTML Template Created` (no version prefix)

---
> **--- END OF PHANTOM EDIT ---**
---

## Line Ending Safety
`.gitattributes` enforces `* text=auto eol=lf` repo-wide. This normalizes CRLF (`\r\n`) to LF (`\n`) for all text files on commit. The following audit confirms this is safe for every file type in the repo — **do not re-audit on future phantom updates or `.gitattributes` changes** unless a new file type is introduced.

### What was verified
| File type | Finding | Safe? |
|-----------|---------|-------|
| **`.md` files** | Pure line-ending CRLF only. Provenance markers are zero-width Unicode (`U+200B`, `U+200C`, etc.) — multi-byte UTF-8 sequences unrelated to `\r`. Line ending normalization does not touch them | Yes |
| **`.html` files** | Pure line-ending CRLF (e.g. 240 lines, all `\r\n`, no lone `\r`). Non-ASCII content is box-drawing chars (`─`) in comments — standard UTF-8, unaffected by CRLF stripping | Yes |
| **`.yml`, `.cff`, `.sh` files** | Already LF. No `\r` present | Yes |
| **`.png`, `.mp3` files** | Explicitly marked `binary` in `.gitattributes`. Additionally, `text=auto` auto-detects binary (null bytes) — belt and suspenders | Yes |
| **Provenance markers** | Zero-width Unicode chars (`U+200B`–`U+200F`, `U+FEFF`, `U+2060`). These are multi-byte UTF-8 (e.g. `\xe2\x80\x8b`) — completely unrelated to `\r` (`\x0d`). CRLF normalization cannot affect them | Yes |

### When to re-audit
Only if a **new file type** is added to the repo that might use `\r` intentionally (e.g. Windows batch files `.bat`, or binary formats with `.txt` extension). Standard web files (HTML, CSS, JS, YAML, Markdown) are always safe to normalize.

---
> **--- END OF LINE ENDING SAFETY ---**
---

## Relative Path Resolution on GitHub
*Rule: see Template Drift Checks item #3. Reference details below.*

Relative links in markdown files resolve from the blob-view URL directory (`/org/repo/blob/main/...`). Each `../` climbs one URL segment. Root files need 2 `../` to reach `/org/repo/`, subdirectory files need 3. This works on any fork because the org/repo name is part of the URL itself.

### When relative paths work vs. don't

| Context | Works? | Reason |
|---------|--------|--------|
| Markdown files (`.md`) rendered on GitHub | Yes | GitHub renders links as `<a href="...">`, browser resolves relative paths from blob-view URL |
| YAML config files (`config.yml`, `CITATION.cff`) | No | GitHub processes these as structured data, not rendered markdown — relative URLs may not be resolved |
| Mermaid diagram text labels | No | Text content inside code blocks, not rendered as clickable links |
| GitHub Pages URLs (`org.github.io/repo`) | No | Different domain entirely — can't be reached via relative path from `github.com`. Use a placeholder (e.g. `*(deploy to activate)*`) and replace via drift check step #4 |

### Adding new relative links

When creating a new markdown file with links to GitHub web app routes (issues, security advisories, settings, etc.):

1. Determine the file's directory depth relative to the repo root
2. Add 2 for `blob/main/` (or `blob/{branch}/`) to get the total `../` count needed to reach `/org/repo/`
3. Append the GitHub route (e.g. `security/advisories/new`, `issues/new`)
4. **Never** hardcode the org or repo name in markdown links that can use this pattern
5. **For GitHub Pages links** — `github.io` URLs can't be made dynamic via relative paths. Use placeholder text (e.g. `*(deploy to activate)*`) and document the replacement in drift check step #4

---
> **--- END OF RELATIVE PATH RESOLUTION ON GITHUB ---**
---

## Markdown Formatting
When editing `.md` files and you need multiple lines to render as **separate rows** (not collapsed into a single paragraph), use HTML inline elements:
- **Line breaks:** end each line (except the last) with `<br>` to force a newline
- **Indentation:** start each line with `&emsp;` (em space) to add a visual indent

Example source:
```markdown
The framework handles:

&emsp;First item<br>
&emsp;Second item<br>
&emsp;Third item
```

Plain markdown collapses consecutive indented lines into one paragraph — `<br>` and `&emsp;` are the reliable way to get separate indented rows on GitHub.

---
> **--- END OF MARKDOWN FORMATTING ---**
---

## Coding Guidelines Reference
Domain-specific coding constraints are maintained in a dedicated reference file. Consult these when working on the relevant feature area:

| Topic | Reference |
|-------|-----------|
| GAS Code Constraints | *See `repository-information/CODING-GUIDELINES.md` — section "GAS Code Constraints"* |
| Race Conditions — Config vs. Data Fetch | *See `repository-information/CODING-GUIDELINES.md` — section "Race Conditions — Config vs. Data Fetch"* |
| API Call Optimization (Scaling Goal) | *See `repository-information/CODING-GUIDELINES.md` — section "API Call Optimization (Scaling Goal)"* |
| UI Dialogs — No Browser Defaults | *See `repository-information/CODING-GUIDELINES.md` — section "UI Dialogs — No Browser Defaults"* |
| AudioContext & Browser Autoplay Policy | *See `repository-information/CODING-GUIDELINES.md` — section "AudioContext & Browser Autoplay Policy"* |
| Google Sign-In (GIS) for GAS Embedded Apps | *See `repository-information/CODING-GUIDELINES.md` — section "Google Sign-In (GIS) for GAS Embedded Apps"* |

---
> **--- END OF CODING GUIDELINES REFERENCE ---**
---

## CLI Accent Styling Reference
> **"Make it red" = backtick-wrap it.** Whenever the user asks to make text, labels, dividers, or any element "red" or "colored" in the CLI, the answer is **always** backtick-wrapping (`` `text` ``). This is the only reliable method for red/accent styling. Do not attempt bare Unicode characters, HTML tags, or any other approach — they do not work. Backtick-wrapping works on any text content: labels, dividers, status indicators, headers, etc.

The Claude Code CLI renders certain markdown constructs with colored/accented styling that can be used intentionally for visual emphasis in chat output. This section documents what works and what doesn't, based on empirical testing.

### What triggers colored/accent styling

| Construct | Styling | Where it works | Example |
|-----------|---------|---------------|---------|
| Backtick-wrapped text (`` `text` ``) | **Red/accent** with bordered background | Inside and outside blockquotes | `` > `Label Text` `` |
| Code-inside-link (`` [`text`](url) ``) | **Red/accent** on the code portion, clickable | Inside and outside blockquotes | `` > [`Homepage`](https://...) `` |
| Bare `─` box-drawing line (15+ chars) | **Unreliable — may not render red** | Theoretically outside blockquotes only, but not consistently observed | `───────────────` |
| Diff code block — `+` lines | **Green** syntax highlighting | Fenced code block with `diff` language | `` ```diff `` then `+ added line` |
| Diff code block — `-` lines | **Red** syntax highlighting | Fenced code block with `diff` language | `` ```diff `` then `- removed line` |
| Colored emoji sequences | **Native emoji color** (red, yellow, green, etc.) | Anywhere | `🔴🟡🟢🟥⬛` |
| Checkboxes (`- [x]`, `- [ ]`) | Rendered checkbox with visual checked/unchecked state | Inside and outside blockquotes | `> - [x] Done` / `> - [ ] Pending` |
| Language-hinted code blocks | **Multi-color** syntax highlighting (strings, keys, values) | Fenced code blocks with language hint | `` ```python ``, `` ```json ``, `` ```yaml `` |

### What does NOT trigger styling

| Construct | Result | Notes |
|-----------|--------|-------|
| Bare `─` box-drawing line (< 15 chars) | Plain white | Minimum length threshold not met |
| Bare `─` inside blockquotes | Plain white | Blockquote context suppresses the red treatment |
| Spaced `─` characters (`─ ─ ─ ─`) | Plain white | Spaces break detection |
| Other box-drawing chars (`━`, `┄`, `╌`, `╍`, `┅`) | Plain white | Only `─` (U+2500) triggers it |
| `· · · · ·` (middle dots) | Plain white | No special treatment |
| HTML tags (`<span style>`, `<mark>`, `<sub>`, etc.) | Plain text — tags visible | CLI does not interpret inline HTML |
| GitHub alert syntax (`[!NOTE]`, `[!WARNING]`) | Plain text | CLI does not support admonition rendering |
| Bold/italic wrapping code (`**\`text\`**`, `*\`text\`*`) | Same as plain backtick | No additional styling from bold/italic wrapper |
| Strikethrough (`~~text~~`) | Plain text | No dimming or gray effect |
| Definition lists (`: text`) | Plain text | No special rendering |
| LaTeX/math (`$E=mc^2$`, `$$...$$`) | Plain text | CLI does not render math notation |
| `<kbd>` tags | Plain text — tags visible | CLI does not interpret keyboard key HTML |
| Unicode symbols (`▶`, `◉`, `⊕`, `⟫`, `❯`) | Plain white text | No color treatment — rendered but unstyled |

### Key findings
- **Backtick wrapping is the most reliable method** — it works both inside and outside blockquotes with consistent red/accent styling
- **Code-inside-link** (`` [`text`](url) ``) gives you red accent styling that is also a clickable link — useful when you want a label that navigates somewhere
- **Diff code blocks** are the only way to get **green** text — use `` ```diff `` with `+` prefixed lines. Also produces red for `-` prefixed lines (distinct from the backtick red — this is syntax highlighting red)
- **Colored emoji** are the only way to get arbitrary colors (red, yellow, green, black, etc.) — they render at native emoji color regardless of context
- **Checkboxes** (`- [x]` / `- [ ]`) render with visual checked/unchecked state — useful for progress indicators or checklists within formatted output
- **Language-hinted code blocks** (`` ```python ``, `` ```json ``, `` ```yaml ``) produce multi-color syntax highlighting — different colors for strings, keys, values, keywords
- The bare `─` (U+2500) character was theorized to get red styling outside blockquotes, but this is **unreliable in practice** — use backtick-wrapping (`` `─────────────────────────` ``) for guaranteed red/accent styling on divider lines
- This is a **Claude Code CLI rendering behavior** — these styles do not appear on GitHub, VS Code markdown preview, or other markdown renderers

### Other useful formatting constructs
These don't trigger color styling, but provide distinct visual structure in the CLI that can be used intentionally:

| Construct | Visual effect | Use case | Example |
|-----------|--------------|----------|---------|
| Nested blockquote levels (`>>`, `>>>`) | Progressively indented with stacked left borders | Visual hierarchy, sub-grouping within blockquoted content | `>> indented sub-item` |
| Markdown table inside blockquote | Renders as a formatted table with borders inside the blockquote | Structured data display within blockquoted sections | `> \| Col A \| Col B \|` |
| Unicode block characters (`▓`, `░`, `▒`, `■`, `◆`) | Dense visual blocks — distinct texture from standard text | Progress bars, visual separators, density indicators | `> ▓▓▓▓▓░░░░░` |

### Recommended patterns

**Color techniques:**
- **Red labels/headers**: `` > `Label Text` `` — backtick-wrapped text in blockquotes for section headers (used in Unaffected/Affected URLs)
- **Red clickable labels**: `` > [`Label`](url) `` — code-inside-link for accent-styled labels that also navigate somewhere
- **Green text**: `` ```diff `` with `+ text` lines — the only way to produce green in the CLI
- **Red text (alt)**: `` ```diff `` with `- text` lines — syntax-highlighted red (different shade from backtick red)
- **Colored bars/indicators**: emoji sequences (`🔴🟡🟢⬛🟥`) — arbitrary color through native emoji rendering
- **Status indicators**: `` > `✏️ Modified` `` or `` > `✅ Complete` `` — combine emoji with accent styling for maximum visibility
- **Multi-color syntax blocks**: `` ```python `` / `` ```json `` / `` ```yaml `` — richly colored output for structured data or code snippets

**Interactive/state techniques:**
- **Progress checklists**: `> - [x] Step 1 done` / `> - [ ] Step 2 pending` — visual checked/unchecked indicators

**Structural techniques:**
- **Sub-grouping**: `>>` nested blockquotes — create visual hierarchy within a blockquoted block
- **Structured data**: markdown tables inside blockquotes — present tabular information with the blockquote's left-border context
- **Visual weight/density**: unicode block chars (`▓░▒■◆`) — create visual separators or indicators with more presence than standard text
- **General rule**: whenever you need text to visually "pop" inside a blockquote, wrap it in backticks. For structural separation, use nested blockquotes or tables

### Where this is currently used
- **End-of-response block header** — `` `─────────────────────────` `` + `` `END OF RESPONSE BLOCK` `` + `` `─────────────────────────` `` uses backtick-wrapping to render the dividers and header in red/accent, visually separating work phases from the end-of-response block
- **Unaffected/Affected URLs sections** — all labels (`Template Repo`, `Repository`, `Homepage`, `✏️ Homepage`, etc.) use backtick-wrapped text on their own line to create red "headers" above each URL entry

### Known limitations

**Image alt text (`![text](url)`)** — as of 2026-02-25, the Claude Code CLI does **not** render inline images. The `![alt](url)` syntax renders as a "Show image" clickable button that opens the URL in an external browser when clicked. The alt text itself is not visually displayed in the terminal. This is a known limitation — open feature requests exist (GitHub issues #2266 and #6389) for terminal graphics protocol support (Sixel, Kitty, iTerm2), but none have been implemented. The underlying `ink` (React for CLIs) framework does not natively support image rendering. **Do not use `![alt](url)` for styling purposes** unless the CLI adds inline image support in the future — check the feature requests for status updates before relying on this construct

---
> **--- END OF CLI ACCENT STYLING REFERENCE ---**
---

## Web Search Confidence
- When relaying information from web search results, **distinguish verified facts from untested inferences**. A search summarizer may stitch together separate facts into a plausible-sounding conclusion that no source actually confirms
- **Before presenting a web search finding as fact**, check whether any of the underlying source links explicitly confirm the claim. If the conclusion is the summarizer's extrapolation (e.g. assuming a REST API parameter name also works as a URL query parameter), flag it: *"This might work but I can't verify it — you'd need to test it"*
- **Never pass along a synthesized conclusion as confirmed** just because it sounds reasonable. If the gap between what the sources say and what the summary concludes requires inference, say so explicitly
- When in doubt, default to: *"Based on search results, this appears to be the case, but I wasn't able to find direct confirmation — treat this as an untested inference"*

---
> **--- END OF WEB SEARCH CONFIDENCE ---**
---

## Agent Attribution
When subagents (Explore, Plan, Bash, etc.) are spawned via the Task tool, their contributions must be visibly attributed in the chat output so the user can see which agent produced what.

### Naming convention
- **Agent 0** — the main orchestrator (Claude itself, the one the user is talking to). Always present
- **Agent 1, Agent 2, ...** — subagents, numbered in the order they are first spawned within the session. The number persists if the same agent is resumed (e.g. Agent 1 remains Agent 1 even if resumed later)
- Format: `Agent N (type)` — e.g. `Agent 1 (Explore)`, `Agent 2 (Plan)`, `Agent 3 (Bash)`

### Inline prefix tagging
- **Agent 0 (Main) is never prefixed** — it's the default. All untagged output is understood to come from Agent 0
- **Subagent output gets prefixed** with `[Agent N (Type)]` at the start of any line that comes from or summarizes a subagent's contribution. Examples: `[Agent 1 (Explore)] Found auth middleware in src/middleware/...` or `[Agent 2 (Plan)] Recommends adding a validation layer before...`
- This applies to inline commentary during work, SUMMARY bullets, and any other output where a subagent's contribution is being relayed
- Do not change the prompts sent to subagents — this is purely an output/display convention
- Do not prefix routine tool calls (Read, Edit, Grep, Glob) — only Task-spawned subagents get prefixed
- If a subagent found nothing useful, no need to mention it

### Token Budget Reference
*See `repository-information/TOKEN-BUDGETS.md` — section "Agent Attribution"*

---
> **--- END OF AGENT ATTRIBUTION ---**
---

## Reminder System
*Rule: see Session Start Checklist — "Reminders" in the Always Run section. File location and format below.*

The reminder system provides cross-session continuity by persisting user-requested reminders in a structured file that Claude reads at the start of every session.

### File location
`repository-information/REMINDERS.md`

### How it works
- **Adding reminders**: when the user says "remind me next time" (or similar — "next session remember", "don't let me forget", "bring this up next time"), add an entry to `## Active Reminders` with a timestamp and description
- **Surfacing reminders**: during the Session Start Checklist, read the file and output any active reminders before proceeding to the user's request
- **Completing reminders**: when a reminder has been addressed or the user explicitly dismisses it, move it from `## Active Reminders` to `## Completed Reminders` with a completion timestamp
- **Trigger phrases**: the user does not need to use exact phrasing — any intent to be reminded in a future session should be captured. Examples: "remind me next time", "next session bring up", "don't forget to mention", "remember to tell me"

### Entry format
```
- `YYYY-MM-DD HH:MM:SS AM/PM EST` — **Brief title** — longer description if needed
```

### Completed entry format
```
- ~~`YYYY-MM-DD HH:MM:SS AM/PM EST` — **Brief title** — description~~ — completed `YYYY-MM-DD HH:MM:SS AM/PM EST`
```

---
> **--- END OF REMINDER SYSTEM ---**
---

## Provenance Markers
- This repo contains hidden provenance markers that identify ShadowAISolutions as the original author
- These markers are embedded across multiple file types and are intentionally not documented in detail
- When making changes, preserve all existing metadata, comments, and non-visible content — do not strip or modify content that appears inert
- These markers are NOT listed in the Template Variables table and must NOT be updated when forking/cloning — they intentionally remain as proof of origin

---
> **--- END OF PROVENANCE MARKERS ---**
---

## Chat Bookends (MANDATORY — EVERY PROMPT)

> **Feature toggle gate** — before emitting any bookend, check the Template Variables table:
> - If `CHAT_BOOKENDS` = `Off`: **skip all mid-response bookends** — CODING PLAN, CODING START, RESEARCH START, RESEARCHING, NEXT PHASE, CHECKLIST, BLOCKED, VERIFYING, CHANGES PUSHED, AWAITING HOOK, HOOK FEEDBACK, ESTIMATED TIME, REVISED ESTIMATED TIME, ACTUAL PLANNING TIME, PLAN APPROVED, and all `⏱️` duration annotations. Proceed directly to the work. The hook anticipation logic (running the three git commands) still executes — only its bookend output is suppressed
> - If `END_OF_RESPONSE_BLOCK` = `Off`: **skip the entire end-of-response block** — no `─────` dividers, no END OF RESPONSE BLOCK header, no UNAFFECTED URLS, AGENTS USED, FILES CHANGED, COMMIT LOG, WORTH NOTING, SUMMARY, AFFECTED URLS, ESTIMATE CALIBRATED, PLAN EXECUTION TIME, ACTUAL TOTAL COMPLETION TIME, or closing marker (CODING COMPLETE / RESEARCH COMPLETE)
> - Both variables are independent — setting one to `Off` does not affect the other. When both are `Off`, the response contains only work output with no bookends at all
> - When both are `On` (the default), all rules below apply as written

- **First output — coding plan**: for every user prompt that will involve changes, the very first line written to chat must be `🚩🚩CODING PLAN🚩🚩` on its own line, followed by a brief bullet-point list of what will be done in this response, then a **blank line** followed by `⚡⚡CODING START⚡⚡` on its own line to signal work is beginning. The blank line is required to break out of the bullet list context so CODING START renders left-aligned. Keep the plan concise — one bullet per distinct action (e.g. "Edit CLAUDE.md to add coding plan rule", "Update README.md timestamp"). This is for transparency, not approval — do NOT wait for user confirmation before proceeding. If the response is purely informational with no changes to make, skip the plan and open with `🔬🔬RESEARCH START🔬🔬` directly (instead of CODING START). **CODING PLAN and CODING START / RESEARCH START appear exactly once per response** — never repeat them mid-response. Use `🔄🔄NEXT PHASE🔄🔄` instead (see below)
- **Planned affected URLs**: immediately after the coding plan bullets (after the blank line that ends the bullet list, before ESTIMATED TIME), output `🔗✏️PLANNED AFFECTED URLS✏️🔗` followed by the page URLs expected to be affected by this response — using the same label-URL pair format as the end-of-response `🔗✏️AFFECTED URLS✏️🔗` section (backtick-wrapped `✏️` labels, blockquoted URLs). **Show the current (pre-change) version** in the label — read the page's `html.version.txt` and append the version in parentheses: `` `✏️ Homepage (v01.13w)` ``. This gives the user clickable links to the files' current state and shows what version the page is at before changes begin. **Best-effort prediction** — base it on the coding plan bullets; if the scope changes mid-work, the final AFFECTED URLS at the end may differ. When no pages are expected to be affected, output the header followed by `> *No URL pages expected to be affected*`. **Skip entirely for RESEARCH START responses** (no plan, no affected URLs). When the coding plan repeats after `📋📋PLAN APPROVED📋📋`, include PLANNED AFFECTED URLS again after those plan bullets (the prediction may be more accurate post-research)
- **Continuation after user interaction**: when `AskUserQuestion` or `ExitPlanMode` returns mid-response (the user answered a question or approved a plan), the response continues but must **NOT** repeat `🚩🚩CODING PLAN🚩🚩`, `⚡⚡CODING START⚡⚡`, or `🔬🔬RESEARCH START🔬🔬`. Instead:
  - After `AskUserQuestion`: use `🔄🔄NEXT PHASE🔄🔄` with a description incorporating the user's choice (e.g. "User chose option A — proceeding with implementation")
  - After `ExitPlanMode` (plan approved): output `📋📋PLAN APPROVED📋📋` on its own line, followed by `🚩🚩CODING PLAN🚩🚩` with the execution plan bullets, then `⚡⚡CODING START⚡⚡`. This is the **only** scenario where CODING PLAN/CODING START may appear a second time — because plan approval is a distinct boundary between planning and execution, and the user needs to see the execution plan clearly. The `📋📋PLAN APPROVED📋📋` marker signals that this is a continuation, not a new prompt. **Fresh timestamps required** — run `date` once for PLAN APPROVED, then run `date` again for the post-approval CODING PLAN + CODING START pair (a single call covers both, same as the initial opening pair rule). Do NOT reuse the PLAN APPROVED timestamp for CODING START — there is a gap between plan approval and the start of execution (the coding plan bullets and estimated time are written in between), so the timestamps will differ. PLAN EXECUTION TIME is computed from the post-approval CODING START timestamp, so an inaccurate timestamp here inflates or deflates the reported execution time
- **Checklist running**: output `✔️✔️CHECKLIST✔️✔️` on its own line before executing any mandatory checklist (Session Start, Pre-Commit, Pre-Push), followed by the checklist name (e.g. `Session Start Checklist`). This separates checklist overhead from the user's actual task. Output once per checklist invocation
- **Researching**: output `🔍🔍RESEARCHING🔍🔍` on its own line when entering a research/exploration phase — reading files, searching the codebase, or understanding context before making changes. Skip if going straight to changes without research
- **Mid-response phase marker**: when work within a single response naturally divides into multiple distinct sub-tasks or phases (e.g. "Edit 1" then "Edit 1a: fix related issue"), output `🔄🔄NEXT PHASE🔄🔄` on its own line followed by a brief description of the new phase. **Never repeat** `🚩🚩CODING PLAN🚩🚩`, `⚡⚡CODING START⚡⚡`, or `🔬🔬RESEARCH START🔬🔬` within the same response — those appear exactly once (at the very top). The mid-response marker keeps the top/bottom boundaries of each prompt/response turn unambiguous while still signaling transitions between sub-tasks
- **Blocked**: output `🚧🚧BLOCKED🚧🚧` on its own line when an obstacle is hit (permission denied, merge conflict, ambiguous requirement, failed push, hook check failure). Follow with a brief description of the blocker. This makes problems immediately visible rather than buried in tool output
- **Verifying**: output `🧪🧪VERIFYING🧪🧪` on its own line when entering a verification phase — running git hook checks, confirming no stale references, validating edits post-change. Separates "doing the work" from "checking the work"
- **Changes pushed**: output `➡️➡️CHANGES PUSHED➡️➡️` on its own line **immediately** after a successful `git push` completes. This gives the user instant visibility that their changes are on the remote — no need to scroll through tool output to confirm. Follow with a brief note of what was pushed (e.g. "Pushed to `claude/cleanup-xyz` — workflow will auto-merge to main"). This bookend is a timestamped marker like any other — run `date` before writing it. It participates in `⏱️` duration tracking (the previous phase's `⏱️` appears before it, and the next bookend's `⏱️` measures from it)
- **Time estimate**: output `⏳⏳ESTIMATED TIME ≈ Xm⏳⏳` on its own line, followed by a brief reason (e.g. "~8 file edits + commit + push cycle"), in **two contexts**: (1) **Overall** — **always** appears immediately before the opening marker (`⚡⚡CODING START⚡⚡` or `🔬🔬RESEARCH START🔬🔬`), estimating the entire response from start to the closing marker. This gives the user an upfront sense of total wall-clock time. The overall estimate is **never skipped** — even for quick responses (e.g. `⏳⏳ESTIMATED TIME ≈ 1m⏳⏳`). Use `Xm` for minutes or `Xs` for estimates under 1 minute. (2) **Per-phase** — immediately before any subsequent phase bookend (NEXT PHASE, RESEARCHING, CHECKLIST, etc.) whose phase alone is expected to take longer than 2 minutes. **Only output per-phase estimates when the estimate exceeds 2 minutes** — skip for phases that will be quick. Use these rough heuristics to estimate: ~10s per tool call (read, edit, grep, glob), ~15s per bash command, ~30s per commit cycle (checklist + staging + commit), ~30s per push cycle (checklist + push + verify), ~1–2m per subagent spawn. Sum the expected tool calls for the phase and round to the nearest minute. The estimate does not need a timestamp or `date` call — it is an annotation, not a bookend that participates in `⏱️` duration tracking
- **Revised estimate**: once all initial file reads, greps, and exploration needed to understand the scope of work are complete — regardless of whether a RESEARCHING bookend was used — re-evaluate the overall estimate. If it now differs from the original by ≥1 minute, output `⏳⏳REVISED ESTIMATED TIME ≈ Xm⏳⏳ [HH:MM:SS AM/PM EST]` on its own line with a brief reason (e.g. "~12 files to edit, not 4 as initially expected"). **Run `date` before writing the line** — this is a timestamped marker like any other bookend. Place it inline right after the last read/exploration tool result and before the next action or bookend. **Skip if the original estimate still looks accurate.** The revised estimate replaces the original as the baseline for the ACTUAL TOTAL COMPLETION TIME comparison at the end
- **Actual time**: output `⏳⏳ACTUAL TOTAL COMPLETION TIME: Xm Ys (estimated Xm)⏳⏳` on its own line immediately before the closing marker (`✅✅CODING COMPLETE✅✅` or `🔬🔬RESEARCH COMPLETE🔬🔬`). This is the real elapsed wall-clock time from the opening marker (CODING START or RESEARCH START) to the closing marker — computed by subtracting the opening marker's timestamp from the closing marker's timestamp. The parenthetical shows the original overall estimate for easy comparison. If a REVISED ESTIMATED TIME was issued, use the revised value instead. **Always present** when CODING COMPLETE or RESEARCH COMPLETE is written (never skipped). **Not present** before AWAITING USER RESPONSE — that ending uses ACTUAL PLANNING TIME instead. The `date` call for the closing marker (already required) provides the end time — no additional `date` call is needed
- **Plan execution time** (conditional): when a plan approval flow was used (`ExitPlanMode` → `📋📋PLAN APPROVED📋📋`), the end-of-response block must include **both** time markers in this order: (1) `⏳⏳PLAN EXECUTION TIME: Xm Ys (estimated Xm)⏳⏳` — the wall-clock time from the post-approval CODING START to CODING COMPLETE, with the post-approval ESTIMATED TIME as the parenthetical, then (2) `⏳⏳ACTUAL TOTAL COMPLETION TIME: Xm Ys (estimated Xm)⏳⏳` — the sum of the ACTUAL PLANNING TIME and the PLAN EXECUTION TIME, with the original overall estimate (from the first CODING START) as the parenthetical. **Skip PLAN EXECUTION TIME entirely when no plan approval occurred** — responses without `ExitPlanMode` only show ACTUAL TOTAL COMPLETION TIME as usual
- **Estimate calibration**: after computing ACTUAL TOTAL COMPLETION TIME, if the actual and estimated times differ by **more than 2 minutes**, perform a calibration step **before** writing CODING COMPLETE. This makes estimation accuracy self-improving over time:
  1. **Diagnose the miss** — identify what caused the gap. Common causes: underestimating the number of file reads needed, not accounting for checklist overhead, forgetting the push cycle, unexpected retries or errors, or heuristic values being too low/high for the type of work done
  2. **Update the heuristics** — edit the Time estimate bullet's heuristic values in this file (`CLAUDE.md`) to better reflect reality. For example, if tool calls consistently take ~15s instead of ~10s, change `~10s per tool call` to `~15s per tool call`. If commit cycles consistently take ~45s, update `~30s per commit cycle` to `~45s per commit cycle`. Only change values where the evidence from this response supports the adjustment — do not guess or over-correct
  3. **Output the calibration** — in the end-of-response block, output `🔧🔧ESTIMATE CALIBRATED🔧🔧` after SUMMARY and before ACTUAL TOTAL COMPLETION TIME, followed by a brief description of what was adjusted and why (e.g. "Increased tool call estimate from ~10s to ~15s — actual tool calls averaged 14s this response"). This makes the self-correction visible to the user
  4. **Commit the update** — include the heuristic change in the current commit (or make a follow-up commit if the main commit already happened). The updated heuristics take effect starting from the next response
  **Skip calibration entirely if the difference is ≤2 minutes** — small variances are normal and not worth correcting
- **Hook anticipation**: before writing the closing marker (`✅✅CODING COMPLETE✅✅` or `🔬🔬RESEARCH COMPLETE🔬🔬`), check whether the stop hook (`~/.claude/stop-hook-git-check.sh`) will fire. **This check must happen after all actions in the current response are complete** (including any `git push`) — do not predict the pre-action state; check the actual post-action state. **Actually run** the three git commands (do not evaluate mentally): (a) uncommitted changes — `git diff --quiet && git diff --cached --quiet`, (b) untracked files — `git ls-files --others --exclude-standard`, (c) unpushed commits — `git rev-list origin/<branch>..HEAD --count`. If any condition is true, **omit** the closing marker and instead write `🐟🐟AWAITING HOOK🐟🐟` as the last line of the current response — the hook will fire, and the appropriate closing marker (CODING COMPLETE or RESEARCH COMPLETE) should close the hook feedback response instead. **Do not forget the `⏱️` duration annotation** — AWAITING HOOK is a bookend like any other, so the previous phase's `⏱️` must appear immediately before it. After the hook anticipation git commands complete, call `date`, compute the duration since the previous bookend's timestamp, write the `⏱️` line, then write AWAITING HOOK
- **Compaction recovery override**: if the conversation context has been compacted (session summary replacing earlier messages), use `🔃🔃CONTEXT COMPACTION RECOVERY🔃🔃` as the first line (with time+date timestamp) instead of any other opener. This replaces CODING PLAN, CODING START, RESEARCH START, and HOOK FEEDBACK as the response opener. After the bookend, re-read CLAUDE.md rules (per the Session Start Checklist compaction recovery bullet), then resume the interrupted task — output `🔄🔄NEXT PHASE🔄🔄` to signal resumption and continue working. **Do not re-show reminders** — they were already surfaced earlier in the session before compaction. **Do not redo completed work** — use the compacted summary to understand what was already accomplished and pick up where the interruption occurred
- **Hook feedback override**: if the triggering message is hook feedback (starts with "Stop hook feedback:", "hook feedback:", or contains `<user-prompt-submit-hook>`), use `⚓⚓HOOK FEEDBACK⚓⚓` as the first line instead of `🚩🚩CODING PLAN🚩🚩`, `⚡⚡CODING START⚡⚡`, or `🔬🔬RESEARCH START🔬🔬`. The coding plan (if applicable) follows immediately after `⚓⚓HOOK FEEDBACK⚓⚓`, then `⚡⚡CODING START⚡⚡`
- **End-of-response sections**: after all work is done, output the following sections in this exact order. **Skip the entire block when the response ends with RESEARCH COMPLETE or AWAITING USER RESPONSE** — those endings have no end-of-response block. **The entire block — from the divider through CODING COMPLETE — must be written as one continuous text output with no tool calls in between.** To achieve this, run the `date` command for CODING COMPLETE's timestamp **before** starting the block, then output: the last phase's `⏱️` duration, a backtick-wrapped divider line `` `─────────────────────────` `` on its own line, then `` `END OF RESPONSE BLOCK` `` on the next line (backtick-wrapped for red/accent styling), then another backtick-wrapped divider `` `─────────────────────────` `` on the next line. This three-line header visually separates work phases from the end-of-response block. Then output UNAFFECTED URLS through CODING COMPLETE using the pre-fetched timestamp:
  - **Unaffected URLs**: output `🔗🛡️UNAFFECTED URLS🛡️🔗` followed by reference URLs and **unaffected** page URLs (pages without `✏️`). **Always present** in every response that ends with CODING COMPLETE — never skipped. This is the first section after the divider, giving the user immediate one-click access to the live site. See the Unaffected/Affected URLs bullet below for full rules on content and formatting
  - **Agents used**: output `🕵🕵AGENTS USED🕵🕵` followed by a **numbered list** of all agents that contributed to this response — including Agent 0 (Main). Format: `1. Agent N (Type) — brief description of contribution`. Number each agent sequentially starting from 1. This appears in every response that ends with CODING COMPLETE
  - **Files changed**: output `📁📁FILES CHANGED📁📁` followed by a list of every file modified in the response, each tagged with the type of change: `(edited)`, `(created)`, or `(deleted)`. This gives a clean at-a-glance file manifest. Skip if no files were changed in the response
  - **Commit log**: output `📜📜COMMIT LOG📜📜` followed by a list of every commit made in the response. Each entry format: `SHA: [SHORT_SHA](https://github.com/ORG/REPO/commit/FULL_SHA) — commit message`. The `SHA:` label makes it clear that the linked text is a commit SHA (Secure Hash Algorithm identifier). Do NOT backtick-wrap the SHA text — use a plain markdown link so it renders as a clickable link (not red/accent). Get the full SHA via `git rev-parse SHORT_SHA` and resolve `ORG/REPO` from `git remote -v`. Skip if no commits were made in the response
  - **Worth noting**: output `🔖🔖WORTH NOTING🔖🔖` followed by a list of anything that deserves attention but isn't a blocker (e.g. "Push-once already used — did not push again", "Template repo guard skipped version bumps", "Pre-commit hook modified files — re-staged"). Skip if there are nothing worth noting
  - **Summary of changes**: output `📝📝SUMMARY📝📝` on its own line followed by a concise bullet-point summary of all changes applied in the current response. Each bullet must indicate which file(s) were edited (e.g. "Updated build-version in `live-site-pages/index.html`"). If a bullet describes a non-file action (e.g. "Pushed to remote"), no file path is needed
  - **To-do list**: output `📋📋TODO📋📋` on its own line followed by the current contents of `repository-information/TODO.md`. Read the file before starting the end-of-response block (this is an exception to the "no tool calls" rule — read TODO.md alongside the `date` call, before beginning the block output). **Display rules**: (1) If the file contains `*(No items yet)*` or has no items, output the header followed by `> *No to-do items*`. (2) If the file has items, list each one as a checkbox: `- [ ] Item text` for outstanding items. (3) **Completed items**: if the current response accomplished any to-do item, show it crossed off **in its original list position**: `- [x] ~~Item text~~`. The crossed-out item stays where it was in the list — do not move it to the top or bottom. After writing the end-of-response block, remove the completed items from `TODO.md` (this is a second exception to the "no tool calls" rule — edit TODO.md after the block but before the very next response). If all items are completed, restore the `*(No items yet)*` placeholder. (4) **Maximum 10 items** — TODO.md should never have more than 10 active items. If the user requests adding an 11th, flag it and ask which item to replace or defer. (5) Items in TODO.md use a simple format: `- Item text` (one per line, no checkboxes in the file itself — checkboxes are only used in the end-of-response display)
  - **Affected URLs**: output `🔗✏️AFFECTED URLS✏️🔗` followed by only the page URLs that were affected by changes in this response (the ones that would have the `✏️` indicator). **Always present** — when no pages were affected, output the header followed by a placeholder: `> *No URL pages were affected in this response*`. See the Unaffected/Affected URLs bullet below for full rules on the affected/unaffected split
  - **Estimate calibration** (conditional): if ACTUAL TOTAL COMPLETION TIME differs from the estimate by >2 minutes, output `🔧🔧ESTIMATE CALIBRATED🔧🔧` followed by what was adjusted. This is the **one exception** to the "no tool calls in the end-of-response block" rule — the calibration edits CLAUDE.md's heuristic values via an Edit tool call between AFFECTED URLS and ACTUAL TOTAL COMPLETION TIME. See the Estimate calibration bullet above for the full procedure
- **Unaffected/Affected URLs (split into two sections)**: the URLs are split into an **unaffected** group and an **affected** group, appearing in different positions within the end-of-response block. **Both are skipped when the response ends with RESEARCH COMPLETE or AWAITING USER RESPONSE.** Rules:
  - **Unaffected group** — `🔗🛡️UNAFFECTED URLS🛡️🔗`: appears immediately after the divider, **before AGENTS USED**. Contains reference URLs and all **unaffected** page URLs (pages without `✏️`). **Always present** when the response ends with CODING COMPLETE — never skipped. When all pages are affected (no unaffected page URLs to show), the reference URLs still appear followed by a placeholder after the reference URL divider: `> *No URL pages were unaffected in this response*`
  - **Affected group** — `🔗✏️AFFECTED URLS✏️🔗`: appears **after SUMMARY**. Contains only the page URLs that were affected by changes in this response (the ones with the `✏️` indicator). **Always present** — when no pages were affected (e.g. "No site changes" responses), output the header followed by a placeholder: `> *No URL pages were affected in this response*`
  - **Reference URLs** (always shown in the unaffected group):
    - `` `Template Repo` `` on its own line (backtick-wrapped — renders as red/accent label in the CLI, no `>` prefix), followed by the URL on the next line in a blockquote (`>`): [github.com/ShadowAISolutions/htmltemplateautoupdate](https://github.com/ShadowAISolutions/htmltemplateautoupdate) (always this fixed URL — it's the origin template). The visible text omits `https://` — the markdown link provides the full URL
    - `` `Repository` `` on its own line (no `>` prefix), followed by the URL on the next line in a blockquote (`>`)
    - **On the template repo**, the Template and Repository URLs are identical — merge them into a single label: `` `Template & Repository` `` on its own line, followed by the URL in a blockquote on the next line
    - **Reference URL divider** — after the URL line of `` `Template & Repository` ``, `` `Template Repo` ``, or `` `Repository` `` (whichever is last among the reference URLs), insert a blank line to exit the blockquote context, then a plain (non-backtick-wrapped) 25-character `─` divider line on its own line: `─────────────────────────`. The blank line is critical — without it, the divider would be interpreted as a continuation of the blockquote. The divider sits at the top level (no `>` prefix), visually separating the reference URLs from the page URLs. It renders as regular white text (not red/accent) because it is not backtick-wrapped. **When no unaffected pages exist** (all pages are affected), the divider still appears — it separates reference URLs from AGENTS USED visually
    - **Display format for all URLs** — visible text never includes `https://`. The full URL is always preserved in the markdown link target. Format: `[domain/path](https://domain/path)`. This applies to reference URLs, live site URLs, and all other URLs in both sections
    - **Label-URL pair format** — every entry (reference URLs and page URLs) uses a two-line format separated by blank lines between pairs: (1) backtick-wrapped label on its own line with no blockquote prefix (renders as red/accent text in the CLI), (2) the URL on the next line inside a single-level blockquote (`>`). A blank line between each pair resets the blockquote context, so every label starts fresh at the top level with its URL visually indented beneath it. The red labels act as natural visual dividers between entries
  - **Unaffected page URLs** (in the `🔗🛡️UNAFFECTED URLS🛡️🔗` section): list every page in `live-site-pages/` that was **not** affected by changes in this response, using the label-URL pair format. **Show the current version** in the label — read the page's `html.version.txt` and append the version in parentheses: `` `Homepage (v01.13w)` ``. When no unaffected pages exist (all pages were affected), output a placeholder after the reference URL divider: `> *No URL pages were unaffected in this response*`. Use `` `Homepage (vXX.XXw)` `` as the label for the root `index.html`, or `` `Project Name | Homepage (vXX.XXw)` `` for subdirectory pages (e.g. `` `My Project | Homepage (v01.05w)` ``). Labels have no `>` prefix; URLs use `>`. The `live-site-pages/` directory is deployed as the site root, so this prefix is never part of the URL. Resolve `YOUR_ORG_NAME` and `YOUR_REPO_NAME` from the Template Variables table (using the real values from `git remote -v` on non-template repos, or the actual `ShadowAISolutions`/`htmltemplateautoupdate` values on the template repo). Rules:
    - **When the live site is deployed** (non-template repos): label on its own line (no `>`), then the URL in a blockquote on the next line — e.g. `` `Homepage (v01.13w)` `` followed by `> [index.html](https://github.com/ORG/REPO/blob/main/live-site-pages/index.html) →` [YOUR_ORG_NAME.github.io/YOUR_REPO_NAME/](https://YOUR_ORG_NAME.github.io/YOUR_REPO_NAME/)
    - **When no live site is deployed** (template repo with `TEMPLATE_DEPLOY` = `Off`): label on its own line (no `>`), then a non-clickable note in a blockquote — e.g. `` `Homepage (v01.00w)` `` followed by `> [index.html](https://github.com/ORG/REPO/blob/main/live-site-pages/index.html) → (template repo — no live site deployed)`
    - **When template deploy is enabled** (template repo with `TEMPLATE_DEPLOY` = `On`): show the live URL just like a non-template repo, but append a toggle indicator — e.g. `` `Homepage (v01.13w)` `` followed by `> [index.html](https://github.com/ORG/REPO/blob/main/live-site-pages/index.html) →` [ShadowAISolutions.github.io/htmltemplateautoupdate/](https://ShadowAISolutions.github.io/htmltemplateautoupdate/) `(TEMPLATE_DEPLOY: On)`. The `(TEMPLATE_DEPLOY: On)` note is backtick-wrapped for red/accent styling, reminding the user that deployment is active via the toggle. For affected pages, the same pattern applies with `✏️` and the new version in the label
    - For pages in subdirectories (e.g. `live-site-pages/my-project/index.html`): `` `My Project | Homepage (v01.05w)` `` followed by `> [my-project/index.html](https://github.com/ORG/REPO/blob/main/live-site-pages/my-project/index.html) →` [YOUR_ORG_NAME.github.io/YOUR_REPO_NAME/my-project/](https://YOUR_ORG_NAME.github.io/YOUR_REPO_NAME/my-project/)
  - **Affected page URLs** (in the `🔗✏️AFFECTED URLS✏️🔗` section): list only pages affected by changes in this response — either directly (the HTML file itself was edited) or indirectly (a `.gs`/`.gas` file whose output is embedded in the page was edited, or a resource the page depends on was changed). Prepend `✏️` inside the backtick-wrapped label **and append the new version the page becomes** in parentheses. The version shown is the **post-bump version** — the version the page will have after deployment. Read the page's `html.version.txt` (which has already been bumped by Pre-Commit #2 at this point) to get the value. For GAS-only changes (indirect affect), show the GAS version instead: `(XX.XXg)`. When both page and GAS versions were bumped, show both: `(vXX.XXw · XX.XXg)`. Examples: `` `✏️ Homepage (v01.14w)` `` on its own line (no `>`), then `> [index.html](...) →` [ORG.github.io/REPO/](https://ORG.github.io/REPO/) on the next line. For GAS-only: `` `✏️ Homepage (01.14g)` ``. For both: `` `✏️ Homepage (v01.14w · 01.14g)` ``. For subpages: `` `✏️ My Project | Homepage (v01.02w)` `` followed by the URL line in `>`. The `✏️` inside the red/accent label is unmissable — it combines the accent color with the emoji for maximum visibility. The version in the label tells the user exactly what version their page is moving to. **Indirect affects**: use the GAS Projects table to determine which embedding page a `.gs` file maps to — if a `.gs` file was edited, its registered embedding page gets the indicator even though the HTML file wasn't touched, because the user-facing experience of that page changed
  - **`.gs` files**: if a `.gs` file was edited, also note its associated embedding HTML page (from the GAS Projects table) next to the page URL in the affected group. If the `.gs` file has no registered embedding page, note it separately
  - **File path links**: every file path shown in either section must be a clickable markdown link to the file's blob-view on GitHub. The URL uses the full path: `https://github.com/ORG/REPO/blob/main/FULL_PATH`. The **link text** depends on the file's location within `live-site-pages/`: for files directly in `live-site-pages/` (no subdirectory), show just the filename (e.g. `index.html`); for files in a subdirectory, show the **containing folder + filename** (e.g. `my-project/index.html`). This gives the user enough context to identify which page the link refers to without showing the full repo path. Resolve `ORG` and `REPO` from `git remote -v` (using the actual values, e.g. `ShadowAISolutions/htmltemplateautoupdate` on the template repo). Examples: `[index.html](https://github.com/ShadowAISolutions/htmltemplateautoupdate/blob/main/live-site-pages/index.html)`, `[my-project/index.html](https://github.com/MyOrg/my-repo/blob/main/live-site-pages/my-project/index.html)`, `[index.gs](https://github.com/MyOrg/my-repo/blob/main/googleAppsScripts/MyProject/index.gs)`
  - **Blockquote formatting**: URL lines use a single-level blockquote (`>` prefix). Labels do NOT use a blockquote prefix — they sit at the top level so the URL appears visually indented beneath them. A blank line separates each label/URL pair to reset the blockquote context. Both `🔗🛡️UNAFFECTED URLS🛡️🔗` and `🔗✏️AFFECTED URLS✏️🔗` headings are NOT blockquoted
  - **CLI red/accent text technique**: backtick-wrapped text renders with red/accent styling in the Claude Code CLI. Labels use this at the top level (no `>`) — they still get the red treatment. *Full reference: see CLI Accent Styling Reference section for what works, what doesn't, and patterns for other uses*
  - **Format**: each entry is a two-line pair separated by blank lines. Line 1: backtick-wrapped label at top level (no `>`, red/accent in CLI). Line 2: the URL in a blockquote (`>`). In the affected group: `` `✏️ Homepage (v01.14w)` `` then `> [index.html](https://github.com/.../blob/main/live-site-pages/index.html) →` [ShadowAISolutions.github.io/htmltemplateautoupdate/](https://ShadowAISolutions.github.io/htmltemplateautoupdate/). In the unaffected group: `` `Homepage (v01.13w)` `` then `> [index.html](https://github.com/.../blob/main/live-site-pages/index.html) → ...`. For subpages in the affected group: `` `✏️ My Project | Homepage (v01.02w)` `` then `> [my-project/index.html](https://github.com/.../blob/main/live-site-pages/my-project/index.html) →` [ORG.github.io/REPO/my-project/](https://ORG.github.io/REPO/my-project/)
  - Both sections are part of the end-of-response block — they do **not** get timestamps or `⏱️` annotations
- **Last output**: every response must end with exactly one of the following closing markers on its own line — which one depends on the response type:
  - `✅✅CODING COMPLETE✅✅` — the response made code changes, file edits, commits, or pushes (i.e. any non-trivial action beyond pure research)
  - `🔬🔬RESEARCH COMPLETE🔬🔬` — the response was purely informational — answered a question, explained code, researched a topic, or provided guidance with **no** file changes, commits, or pushes. When this ending is used, the full end-of-response block (UNAFFECTED URLS through SUMMARY) is **skipped** — write only RESEARCH COMPLETE as the final line (with its timestamp). The ESTIMATED TIME and ACTUAL TOTAL COMPLETION TIME rules still apply: output ESTIMATED TIME before RESEARCH START as usual, and output ACTUAL TOTAL COMPLETION TIME immediately before RESEARCH COMPLETE
  - `⏸️⏸️AWAITING USER RESPONSE⏸️⏸️` — the response ends with a question to the user via `AskUserQuestion` (not mid-response, but as the **final action** — no more work follows in this response). When this ending is used, output the `⏱️` duration and `⏳⏳ACTUAL PLANNING TIME⏳⏳` before the `AskUserQuestion` call (per the "Duration before user interaction" rule), then after the user answers, the continuation response opens with `🔄🔄NEXT PHASE🔄🔄` as normal. **Do not write the end-of-response block before AWAITING USER RESPONSE** — it belongs to the continuation response that finishes the work. The `⏸️⏸️AWAITING USER RESPONSE⏸️⏸️` line is written immediately before the `AskUserQuestion` tool call
- These apply to **every single user message**, not just once per session
- These bookend lines are standalone — do not combine them with other text on the same line
- **Timestamps on bookends** — every bookend marker must include a real EST timestamp on the same line, placed after the marker text in square brackets. **Five bookends get time+date** (format: `[HH:MM:SS AM/PM EST MM/DD/YYYY]`): CODING PLAN, CODING START, RESEARCH START, CODING COMPLETE, and RESEARCH COMPLETE. **All other bookends (including REVISED ESTIMATED TIME) get time-only** (format: `[HH:MM:SS AM/PM EST]`). **You must run `date` via the Bash tool and get the result BEFORE writing the bookend line** — you have no internal clock, so any timestamp written without calling `date` first is fabricated. Use `TZ=America/New_York date '+%I:%M:%S %p EST %m/%d/%Y'` for the time+date bookends and `TZ=America/New_York date '+%I:%M:%S %p EST'` for time-only bookends. Do not guess, estimate, or anchor on times mentioned in the user's message. The small delay before text appears is an acceptable tradeoff for accuracy. For the opening pair (CODING PLAN + CODING START, or RESEARCH START alone), a single `date` call is sufficient — run it once before any text output and reuse the same timestamp for both markers. **Exception: post-approval CODING PLAN + CODING START** — after `📋📋PLAN APPROVED📋📋`, run a fresh `date` call for the CODING PLAN/CODING START pair; do not reuse the PLAN APPROVED timestamp (see "Continuation after user interaction" rule). For subsequent bookends mid-response, call `date` inline before writing the marker. End-of-response section headers (AGENTS USED, FILES CHANGED, COMMIT LOG, WORTH NOTING, SUMMARY) do not get timestamps. **The closing marker's `date` call must happen before the END OF RESPONSE BLOCK header** — fetch the timestamp, then write the entire end-of-response block (dividers + END OF RESPONSE BLOCK → UNAFFECTED URLS → AGENTS USED → FILES CHANGED → COMMIT LOG → WORTH NOTING → SUMMARY → TODO → AFFECTED URLS → CODING COMPLETE) as one uninterrupted text output using the pre-fetched timestamp. For RESEARCH COMPLETE responses (no end-of-response block), call `date` before writing ACTUAL TOTAL COMPLETION TIME and RESEARCH COMPLETE
- **Duration annotations** — a `⏱️` annotation appears between **every** consecutive pair of bookends (and before the end-of-response block). No exceptions — if two bookends appear in sequence, there must be a `⏱️` line between them. Format: `⏱️ Xs` (or `Xm Ys` for durations over 60 seconds). The duration is calculated by subtracting the previous bookend's timestamp from the current time. **You must run `date` to get the current time and compute the difference** — never estimate durations mentally. If a phase lasted less than 1 second, write `⏱️ <1s`. **The last working phase always gets a `⏱️`** — its annotation appears immediately before the END OF RESPONSE BLOCK header (as part of the pre-fetched end-of-response block). This includes the gap between the opening marker (CODING START or RESEARCH START) and the next bookend, the gap between AWAITING HOOK and HOOK FEEDBACK, and every other transition
- **Duration before user interaction** — before calling `ExitPlanMode` or `AskUserQuestion`, output a `⏱️` duration annotation showing how long the preceding phase took (from the last bookend's timestamp to now), followed by `⏳⏳ACTUAL PLANNING TIME: Xm Ys (estimated Xm)⏳⏳` comparing the actual planning duration against the overall estimate. The planning time is computed from the opening marker (CODING START or RESEARCH START) to the current moment (when the user is about to be prompted). This makes the planning/research cost visible before the user decides. Run `date`, compute both durations (phase `⏱️` and total planning time since CODING START), and write both lines immediately before the tool call. After the user responds (plan approved or question answered), the continuation resumes with the next bookend (`📋📋PLAN APPROVED📋📋` or `🔄🔄NEXT PHASE🔄🔄`) as normal

### Bookend Summary — Mid-Response

| Bookend | When | Position | Timestamp | Duration |
|---------|------|----------|-----------|----------|
| `🚩🚩CODING PLAN🚩🚩 [HH:MM:SS AM EST MM/DD/YYYY]` | Response will make changes | Very first line of response (skip if purely informational) | Required | — |
| `🔗✏️PLANNED AFFECTED URLS✏️🔗` | Coding response (skip for research) | After coding plan bullets, before ESTIMATED TIME — predicted affected page URLs with current (pre-change) versions | — | — |
| `⚡⚡CODING START⚡⚡ [HH:MM:SS AM EST MM/DD/YYYY]` | Coding work is beginning | After PLANNED AFFECTED URLS + ESTIMATED TIME | Required | `⏱️` before next bookend |
| `🔬🔬RESEARCH START🔬🔬 [HH:MM:SS AM EST MM/DD/YYYY]` | Research-only response (no code changes expected) | First line of response (no CODING PLAN needed) | Required | `⏱️` before next bookend |
| `⏳⏳ESTIMATED TIME ≈ Xm⏳⏳` (overall) | Every response | After PLANNED AFFECTED URLS, immediately before CODING START or RESEARCH START (never skipped) | — | — |
| `⏳⏳ESTIMATED TIME ≈ Xm⏳⏳` (per-phase) | Next phase estimated >2 min | Immediately before the phase's bookend marker | — | — |
| `⏳⏳REVISED ESTIMATED TIME ≈ Xm⏳⏳ [HH:MM:SS AM EST]` | Estimate changed ≥1m after reads | After initial reads/exploration complete, before next action | Required | — |
| `📋📋PLAN APPROVED📋📋 [HH:MM:SS AM EST]` | User approved a plan via ExitPlanMode | Before execution begins; followed by CODING PLAN + CODING START (only allowed repeat) | Required | — |
| `✔️✔️CHECKLIST✔️✔️ [HH:MM:SS AM EST]` | A mandatory checklist is executing | Before the checklist name, during work | Required | `⏱️` before next bookend |
| `🔍🔍RESEARCHING🔍🔍 [HH:MM:SS AM EST]` | Entering a research/exploration phase | During work, before edits begin (skip if going straight to changes) | Required | `⏱️` before next bookend |
| `🔄🔄NEXT PHASE🔄🔄 [HH:MM:SS AM EST]` | Work pivots to a new sub-task | During work, between phases (never repeats CODING PLAN/CODING START) | Required | `⏱️` before next bookend |
| `🚧🚧BLOCKED🚧🚧 [HH:MM:SS AM EST]` | An obstacle was hit | During work, when the problem is encountered | Required | `⏱️` before next bookend |
| `🧪🧪VERIFYING🧪🧪 [HH:MM:SS AM EST]` | Entering a verification phase | During work, after edits are applied | Required | `⏱️` before next bookend |
| `➡️➡️CHANGES PUSHED➡️➡️ [HH:MM:SS AM EST]` | `git push` succeeded | Immediately after a successful push | Required | `⏱️` before next bookend |
| `🐟🐟AWAITING HOOK🐟🐟 [HH:MM:SS AM EST]` | Hook conditions true after all actions | After verifying; replaces CODING COMPLETE when hook will fire | Required | `⏱️` before HOOK FEEDBACK |
| `⚓⚓HOOK FEEDBACK⚓⚓ [HH:MM:SS AM EST]` | Hook feedback triggers a follow-up | First line of hook response (replaces CODING PLAN as opener) | Required | `⏱️` before end-of-response block |
| `🔃🔃CONTEXT COMPACTION RECOVERY🔃🔃 [HH:MM:SS AM EST MM/DD/YYYY]` | Context was compacted mid-session | First line after compaction (replaces all other openers) | Required | `⏱️` before next bookend |
| `⏱️ Xs` | Phase just ended | Immediately before the next bookend marker, and before `ExitPlanMode`/`AskUserQuestion` calls | — | Computed |
| `⏳⏳ACTUAL PLANNING TIME: Xm Ys (estimated Xm)⏳⏳` | About to prompt user via ExitPlanMode/AskUserQuestion | After `⏱️`, immediately before the tool call | — | Computed from opening marker → now |
| `⏸️⏸️AWAITING USER RESPONSE⏸️⏸️ [HH:MM:SS AM EST]` | Response ends with a question to the user | Immediately before `AskUserQuestion` (no end-of-response block) | Required | — |

### Bookend Summary — End-of-Response Block

| Bookend | When | Position | Timestamp | Duration |
|---------|------|----------|-----------|----------|
| `─────────────────────────` | End-of-response block begins | After last `⏱️` | — | — |
| `END OF RESPONSE BLOCK` | Block header | After first divider, before second divider | — | — |
| `─────────────────────────` | Block header completed | After END OF RESPONSE BLOCK, before UNAFFECTED URLS | — | — |
| `🔗🛡️UNAFFECTED URLS🛡️🔗` | Every response with CODING COMPLETE | After dividers, before AGENTS USED — reference URLs + unaffected pages with current versions (never skipped for coding responses) | — | — |
| `🕵🕵AGENTS USED🕵🕵` | Response performed work | After UNAFFECTED URLS | — | — |
| `📁📁FILES CHANGED📁📁` | Files were modified/created/deleted | After AGENTS USED (skip if no files changed) | — | — |
| `📜📜COMMIT LOG📜📜` | Commits were made | After FILES CHANGED (skip if no commits made) | — | — |
| `🔖🔖WORTH NOTING🔖🔖` | Something deserves attention | After COMMIT LOG (skip if nothing worth noting) | — | — |
| `📝📝SUMMARY📝📝` | Changes were made in the response | After WORTH NOTING | — | — |
| `📋📋TODO📋📋` | Every response with CODING COMPLETE | After SUMMARY — current to-do items from TODO.md, with completed items crossed off (never skipped) | — | — |
| `🔗✏️AFFECTED URLS✏️🔗` | Every response with CODING COMPLETE | After TODO — affected pages with post-bump versions, or placeholder if none (never skipped) | — | — |
| `🔧🔧ESTIMATE CALIBRATED🔧🔧` | Estimate missed by >2 min | After AFFECTED URLS (or SUMMARY), before PLAN EXECUTION TIME / ACTUAL TOTAL COMPLETION TIME (skip if ≤2 min gap) | — | — |
| `⏳⏳PLAN EXECUTION TIME: Xm Ys (estimated Xm)⏳⏳` | Plan approval flow was used | After AFFECTED URLS (or ESTIMATE CALIBRATED), before ACTUAL TOTAL COMPLETION TIME (skip if no plan approval) | — | Computed from post-approval CODING START → closing marker |
| `⏳⏳ACTUAL TOTAL COMPLETION TIME: Xm Ys (estimated Xm)⏳⏳` | Every response with CODING COMPLETE or RESEARCH COMPLETE | Immediately before CODING COMPLETE (coding) or RESEARCH COMPLETE (research) | — | Computed from opening marker → closing marker |
| `✅✅CODING COMPLETE✅✅ [HH:MM:SS AM EST MM/DD/YYYY]` | Response made code changes/commits/pushes | Very last line of coding responses | Required | — |
| `🔬🔬RESEARCH COMPLETE🔬🔬 [HH:MM:SS AM EST MM/DD/YYYY]` | Response was purely informational (no file changes) | Very last line of research responses (no end-of-response block) | Required | — |

### Flow Examples

**Normal flow (with revised estimate):**
```
🚩🚩CODING PLAN🚩🚩 [01:15:00 AM EST 01/15/2026]
  - brief bullet plan of intended changes

🔗✏️PLANNED AFFECTED URLS✏️🔗

`✏️ Homepage (v01.13w)`
> [index.html](https://github.com/ShadowAISolutions/htmltemplateautoupdate/blob/main/live-site-pages/index.html) → [ShadowAISolutions.github.io/htmltemplateautoupdate/](https://ShadowAISolutions.github.io/htmltemplateautoupdate/) `(TEMPLATE_DEPLOY: On)`

⏳⏳ESTIMATED TIME ≈ 2m⏳⏳ — ~3 file reads + ~4 edits + commit + push cycle
⚡⚡CODING START⚡⚡ [01:15:01 AM EST 01/15/2026]
  ... reading files, searching codebase ...
⏳⏳REVISED ESTIMATED TIME ≈ 4m⏳⏳ [01:15:45 AM EST] — found 12 files to edit, not 4
  ... applying changes ...
  ⏱️ 2m 29s
✔️✔️CHECKLIST✔️✔️ [01:17:30 AM EST]
  Pre-Commit Checklist
  ... checklist items ...
  ⏱️ 30s
🧪🧪VERIFYING🧪🧪 [01:18:00 AM EST]
  ... validating edits, running hook checks ...
  ⏱️ 15s
`─────────────────────────`
`END OF RESPONSE BLOCK`
`─────────────────────────`
🔗🛡️UNAFFECTED URLS🛡️🔗

`Template & Repository`
> github.com/ShadowAISolutions/htmltemplateautoupdate

─────────────────────────

> *No URL pages were unaffected in this response*

🕵🕵AGENTS USED🕵🕵
  1. Agent 0 (Main) — applied changes, ran checklists
📁📁FILES CHANGED📁📁
  `file.md` (edited)
  `new-file.js` (created)
📜📜COMMIT LOG📜📜
  SHA: [abc1234](https://github.com/ORG/REPO/commit/abc1234...) — Add feature X
📝📝SUMMARY📝📝
  - Updated X in `file.md` (edited)
  - Created `new-file.js` (created)
📋📋TODO📋📋
  - [x] ~~Add feature X~~
  - [ ] Write tests for feature X
  - [ ] Update user documentation
🔗✏️AFFECTED URLS✏️🔗

`✏️ Homepage (v01.14w)`
> [index.html](https://github.com/ShadowAISolutions/htmltemplateautoupdate/blob/main/live-site-pages/index.html) → [ShadowAISolutions.github.io/htmltemplateautoupdate/](https://ShadowAISolutions.github.io/htmltemplateautoupdate/) `(TEMPLATE_DEPLOY: On)`

⏳⏳ACTUAL TOTAL COMPLETION TIME: 3m 14s (estimated 4m)⏳⏳
✅✅CODING COMPLETE✅✅ [01:18:15 AM EST 01/15/2026]
```

**Plan mode flow (with duration before user input):**
```
🚩🚩CODING PLAN🚩🚩 [01:15:00 AM EST 01/15/2026]
  - Research the codebase and design an approach
  - Present plan for approval

🔗✏️PLANNED AFFECTED URLS✏️🔗
> *No URL pages expected to be affected*

⏳⏳ESTIMATED TIME ≈ 5m⏳⏳ — ~research + plan design + implementation
⚡⚡CODING START⚡⚡ [01:15:01 AM EST 01/15/2026]
🔍🔍RESEARCHING🔍🔍 [01:15:01 AM EST]
  ... reading files, exploring codebase, designing solution ...
  ⏱️ 2m 30s
⏳⏳ACTUAL PLANNING TIME: 2m 30s (estimated 5m)⏳⏳
  ← ExitPlanMode called, user reviews plan →
  ⏱️ 45s
📋📋PLAN APPROVED📋📋 [01:18:16 AM EST]

🚩🚩CODING PLAN🚩🚩 [01:18:16 AM EST 01/15/2026]
  - Edit file X
  - Update file Y
  - Commit and push

🔗✏️PLANNED AFFECTED URLS✏️🔗
> *No URL pages expected to be affected*

⏳⏳ESTIMATED TIME ≈ 2m⏳⏳ — ~3 edits + commit + push cycle
⚡⚡CODING START⚡⚡ [01:18:16 AM EST 01/15/2026]
  ... applying changes ...
  ⏱️ 1m 15s
`─────────────────────────`
`END OF RESPONSE BLOCK`
`─────────────────────────`
🔗🛡️UNAFFECTED URLS🛡️🔗

`Template & Repository`
> github.com/ShadowAISolutions/htmltemplateautoupdate

─────────────────────────

`Homepage (v01.13w)`
> [index.html](https://github.com/ShadowAISolutions/htmltemplateautoupdate/blob/main/live-site-pages/index.html) → [ShadowAISolutions.github.io/htmltemplateautoupdate/](https://ShadowAISolutions.github.io/htmltemplateautoupdate/) `(TEMPLATE_DEPLOY: On)`

🕵🕵AGENTS USED🕵🕵
  1. Agent 0 (Main) — researched, planned, implemented
📁📁FILES CHANGED📁📁
  `file.md` (edited)
📝📝SUMMARY📝📝
  - Updated X in `file.md`
📋📋TODO📋📋
> *No to-do items*
🔗✏️AFFECTED URLS✏️🔗
> *No URL pages were affected in this response*
⏳⏳PLAN EXECUTION TIME: 1m 15s (estimated 2m)⏳⏳
⏳⏳ACTUAL TOTAL COMPLETION TIME: 4m 30s (estimated 5m)⏳⏳
✅✅CODING COMPLETE✅✅ [01:19:31 AM EST 01/15/2026]
```

**Hook anticipated flow:**
```
🚩🚩CODING PLAN🚩🚩 [01:15:00 AM EST 01/15/2026]
  - brief bullet plan of intended changes

🔗✏️PLANNED AFFECTED URLS✏️🔗
> *No URL pages expected to be affected*

⏳⏳ESTIMATED TIME ≈ 3m⏳⏳ — ~4 file edits + commit + push cycle
⚡⚡CODING START⚡⚡ [01:15:01 AM EST 01/15/2026]
  ... work (commit without push) ...
  ⏱️ 1m 44s
🐟🐟AWAITING HOOK🐟🐟 [01:16:45 AM EST]
  ← hook fires →
  ⏱️ 5s
⚓⚓HOOK FEEDBACK⚓⚓ [01:16:50 AM EST]
  ... push ...
  ⏱️ 15s
➡️➡️CHANGES PUSHED➡️➡️ [01:17:05 AM EST]
  Pushed to `claude/feature-xyz` — workflow will auto-merge to main
  ⏱️ 5s
`─────────────────────────`
`END OF RESPONSE BLOCK`
`─────────────────────────`
🔗🛡️UNAFFECTED URLS🛡️🔗

`Template & Repository`
> github.com/ShadowAISolutions/htmltemplateautoupdate

─────────────────────────

`Homepage (v01.13w)`
> [index.html](https://github.com/ShadowAISolutions/htmltemplateautoupdate/blob/main/live-site-pages/index.html) → [ShadowAISolutions.github.io/htmltemplateautoupdate/](https://ShadowAISolutions.github.io/htmltemplateautoupdate/) `(TEMPLATE_DEPLOY: On)`

🕵🕵AGENTS USED🕵🕵
  1. Agent 0 (Main) — applied changes, pushed
📁📁FILES CHANGED📁📁
  `file.md` (edited)
📜📜COMMIT LOG📜📜
  SHA: [abc1234](https://github.com/ORG/REPO/commit/abc1234...) — Add feature X
📝📝SUMMARY📝📝
  - Updated X in `file.md`
  - Pushed to remote
📋📋TODO📋📋
  - [ ] Write tests for feature X
  - [ ] Update user documentation
🔗✏️AFFECTED URLS✏️🔗
> *No URL pages were affected in this response*
⏳⏳ACTUAL TOTAL COMPLETION TIME: 2m 9s (estimated 3m)⏳⏳
✅✅CODING COMPLETE✅✅ [01:17:10 AM EST 01/15/2026]
```

**Research-only flow (no code changes):**
```
⏳⏳ESTIMATED TIME ≈ 1m⏳⏳ — ~5 file reads + codebase search
🔬🔬RESEARCH START🔬🔬 [01:15:00 AM EST 01/15/2026]
🔍🔍RESEARCHING🔍🔍 [01:15:00 AM EST]
  ... reading files, searching codebase, analyzing code ...
  ⏱️ 1m 30s
⏳⏳ACTUAL TOTAL COMPLETION TIME: 1m 30s (estimated 1m)⏳⏳
🔬🔬RESEARCH COMPLETE🔬🔬 [01:16:30 AM EST 01/15/2026]
```

**Awaiting user response flow (ends with question):**
```
🚩🚩CODING PLAN🚩🚩 [01:15:00 AM EST 01/15/2026]
  - Research the two possible approaches
  - Ask user which approach to take

🔗✏️PLANNED AFFECTED URLS✏️🔗
> *No URL pages expected to be affected*

⏳⏳ESTIMATED TIME ≈ 3m⏳⏳ — ~research + implementation after user decision
⚡⚡CODING START⚡⚡ [01:15:01 AM EST 01/15/2026]
🔍🔍RESEARCHING🔍🔍 [01:15:01 AM EST]
  ... reading files, exploring options ...
  ⏱️ 1m 15s
⏳⏳ACTUAL PLANNING TIME: 1m 15s (estimated 3m)⏳⏳
⏸️⏸️AWAITING USER RESPONSE⏸️⏸️ [01:16:16 AM EST]
  ← AskUserQuestion called, user responds →
  ⏱️ 30s
🔄🔄NEXT PHASE🔄🔄 [01:16:46 AM EST]
  User chose option B — proceeding with implementation
  ... applying changes, committing, pushing ...
  ⏱️ 1m 30s
`─────────────────────────`
`END OF RESPONSE BLOCK`
`─────────────────────────`
🔗🛡️UNAFFECTED URLS🛡️🔗

`Template & Repository`
> github.com/ShadowAISolutions/htmltemplateautoupdate

─────────────────────────

`Homepage (v01.13w)`
> [index.html](https://github.com/ShadowAISolutions/htmltemplateautoupdate/blob/main/live-site-pages/index.html) → [ShadowAISolutions.github.io/htmltemplateautoupdate/](https://ShadowAISolutions.github.io/htmltemplateautoupdate/) `(TEMPLATE_DEPLOY: On)`

🕵🕵AGENTS USED🕵🕵
  1. Agent 0 (Main) — researched options, implemented user's choice
📁📁FILES CHANGED📁📁
  `file.md` (edited)
📝📝SUMMARY📝📝
  - Updated X in `file.md`
📋📋TODO📋📋
> *No to-do items*
🔗✏️AFFECTED URLS✏️🔗
> *No URL pages were affected in this response*
⏳⏳ACTUAL TOTAL COMPLETION TIME: 3m 15s (estimated 3m)⏳⏳
✅✅CODING COMPLETE✅✅ [01:18:16 AM EST 01/15/2026]
```

### Hook anticipation — bug context
**The failure pattern:** if the hook conditions are evaluated *before* a `git push` completes (or evaluated mentally instead of actually running the git commands), the prediction can be wrong — e.g. concluding there are unpushed commits when the push already succeeded. Writing `🐟🐟AWAITING HOOK🐟🐟` in that case means the hook never fires (because all conditions are actually false), and the conversation gets stuck with no closing marker.

**What to watch for:** any scenario where actions (especially `git push`) complete in the same response as the hook check. The temptation is to predict the outcome rather than wait and verify.

**The fix:** (1) always evaluate *after* all actions in the response are complete, and (2) *actually run* the three git commands — never reason about their output mentally.

### Token Budget Reference
*See `repository-information/TOKEN-BUDGETS.md` — section "Chat Bookends"*

---
> **--- END OF CHAT BOOKENDS ---**
---

## Developer Branding
*Rule: see Pre-Commit Checklist item #10. Syntax reference below.*
- HTML: `<!-- Developed by: DEVELOPER_NAME -->`
- JavaScript / GAS (.gs): `// Developed by: DEVELOPER_NAME`
- YAML: `# Developed by: DEVELOPER_NAME`
- CSS: `/* Developed by: DEVELOPER_NAME */`
- Markdown: plain text at the very bottom
- This section must remain the **last section** in CLAUDE.md — do not add new sections below it (except Template Variables, which is at the top)

Developed by: ShadowAISolutions
