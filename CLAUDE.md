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
| `CHAT_BOOKENDS` | On | CLAUDE.md | Controls whether mid-response bookends are output.<br>`On` = all bookends are emitted as documented.<br>`Off` = **skip** every bookend marker — no CODING PLAN, CODING START, RESEARCHING, NEXT PHASE, CHECKLIST, BLOCKED, VERIFYING, CHANGES PUSHED, AWAITING HOOK, HOOK FEEDBACK, time estimates, revised estimates, or `⏱️` duration lines are emitted. The response reads as plain work output.<br>**Fully independent of `END_OF_RESPONSE_BLOCK`** — when `END_OF_RESPONSE_BLOCK` = `On`, timestamps and estimates are captured silently (no visible output) so that ACTUAL TOTAL COMPLETION TIME, PLAN EXECUTION TIME, and ESTIMATE CALIBRATED work without any bookend markers being displayed (see chat-bookends.md feature toggle gate) |
| `END_OF_RESPONSE_BLOCK` | On | CLAUDE.md | Controls whether the end-of-response block is output.<br>`On` = the full block is emitted (divider, UNAFFECTED URLS, AGENTS USED, FILES CHANGED, COMMIT LOG, WORTH NOTING, SUMMARY, TODO, NEW FOLDERS, AFFECTED URLS, ESTIMATE CALIBRATED, ACTUAL TOTAL COMPLETION TIME, CODING COMPLETE). All features work regardless of `CHAT_BOOKENDS` state (timestamps/estimates are captured silently when bookends are off).<br>`Off` = the entire end-of-response block is **skipped** — no divider, no summary sections, no CODING COMPLETE line. Mid-response bookends (when `CHAT_BOOKENDS` = `On`) are unaffected.<br>**Fully independent of `CHAT_BOOKENDS`** — zero cross-dependencies in either direction |
| `TEMPLATE_DEPLOY` | On | CLAUDE.md<br>workflow deploy<br>job condition | Controls whether GitHub Pages deployment runs on the template repo.<br>`On` = deploy runs even when `IS_TEMPLATE_REPO` matches the repo name (allows seeing the live site on the template).<br>`Off` = deploy is skipped on the template repo (default behavior for templates).<br>Has no effect on forks — forks always deploy normally regardless of this toggle.<br>**Toggle takes effect on the same commit** — the workflow reads this value from the pushed branch, so switching to `On` triggers deployment on that commit's push, and switching to `Off` skips deployment on that commit's push |
| `REMINDERS_DISPLAY` | On | CLAUDE.md | Controls whether active reminders from `REMINDERS.md` are surfaced at session start.<br>`On` = reminders are read and displayed as `📌 Reminders For Developer:` with bullet points before proceeding to the user's request.<br>`Off` = skip surfacing reminders at session start. Reminders are still tracked — adding, completing, and managing reminders works normally. Only the automatic display at session start is suppressed.<br>**Fully independent of all other toggles** — no cross-dependencies with `CHAT_BOOKENDS`, `END_OF_RESPONSE_BLOCK`, or `SESSION_CONTEXT_DISPLAY` |
| `SESSION_CONTEXT_DISPLAY` | On | CLAUDE.md | Controls whether previous session context from `SESSION-CONTEXT.md` is surfaced at session start.<br>`On` = session context is read, staleness-checked, and displayed as `📎 Previous Session Context:` followed by the `💡 remember session` tip.<br>`Off` = skip surfacing session context at session start. Session context is still tracked — "remember session" still writes context, and staleness auto-reconstruction still runs if needed (to keep the file current). Only the automatic display at session start is suppressed.<br>**Fully independent of all other toggles** — no cross-dependencies with `CHAT_BOOKENDS`, `END_OF_RESPONSE_BLOCK`, or `REMINDERS_DISPLAY` |
| `MULTI_SESSION_MODE` | Off | CLAUDE.md | Controls whether parallel Claude Code sessions can safely run against this repo without merge conflicts on shared state files.<br>`On` = skip repo version bump (#16), README timestamp (#11), CHANGELOG/page/GAS changelog versioned sections (#7/#17 push-commit portions), STATUS.md version sync (#5), and version prefix in commit messages (#9). Entries are still added to `[Unreleased]` in all changelogs — only the versioned-section creation is deferred. Per-page/per-GAS version bumps (#1, #2) still run since they're scoped to the specific file being edited.<br>`Off` = normal single-session behavior. If switching from `On` → `Off`, run the "Reconcile Multi-Session" command to catch up on deferred work.<br>**Caution**: sessions must still work on **different pages/features** — this mode prevents conflicts on globally shared state files, not on the feature files themselves |

### How variables work
- **In code files** (HTML, YAML, Markdown, etc.): use the **resolved value** (e.g. write `MyOrgName`, not `YOUR_ORG_NAME`)
- **In CLAUDE.md instructions**: the placeholder names (`YOUR_ORG_NAME`, `DEVELOPER_NAME`, etc.) may appear in examples and rules — Claude Code resolves them using the table above

---
> **--- END OF TEMPLATE VARIABLES ---**
---

> **Output formatting** — see `.claude/rules/chat-bookends.md` for response formatting rules. Behavior is governed by the `CHAT_BOOKENDS` and `END_OF_RESPONSE_BLOCK` toggles in the Template Variables table — both are fully independent of each other and of all other repo functionality.

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

**Reminders for Developer** — check the `REMINDERS_DISPLAY` variable in the Template Variables table. If `On`: read `repository-information/REMINDERS.md`. If the `## Active Reminders` section contains any entries, surface them to the user before proceeding to their request. Format: output `📌 Reminders For Developer:` followed by each reminder as a bullet point. After surfacing, proceed normally — do not wait for acknowledgment. If `Off`: skip surfacing reminders — do not read or display them at session start. **Regardless of the toggle state**, the following always apply: if the user says "remind me next time" (or similar phrasing like "next session remember", "don't let me forget") about anything during a session, add it to the `## Active Reminders` section with a timestamp. **These are the developer's own notes** — do not mark them as completed, remove them, or modify their meaning without explicit developer approval (see "User-Owned Content" rule in behavioral-rules.md). When the developer explicitly says a reminder is done or dismisses it, move it to `## Completed Reminders` with a completion timestamp.

**Session context** — check the `SESSION_CONTEXT_DISPLAY` variable in the Template Variables table. If `Off`: skip surfacing session context at session start — do not read or display it. Staleness auto-reconstruction still runs if triggered (to keep the file current), but no output is shown. If `On` (or not set): immediately after surfacing reminders (or in place of reminders if there are none), read `repository-information/SESSION-CONTEXT.md`. If the `## Latest Session` section contains session context (not just a placeholder):

1. **Staleness check** — extract the `**Repo version:**` value from the Latest Session entry and compare it against `repository-information/repository.version.txt`. If they match, the context is fresh — skip to step 3. If they differ, the context is stale — proceed to step 2
2. **Auto-reconstruct** — the session context is stale (one or more sessions ended without "remember session"). Reconstruct the missing context:
   - Read CHANGELOG.md and collect all version sections between the recorded version (exclusive) and the current version (inclusive) — these entries describe what was done in the missed session(s)
   - Read current `TODO.md` and `REMINDERS.md` for active context state
   - Move the current `## Latest Session` to `## Previous Sessions` (prepend, most recent first)
   - Write a new `## Latest Session` with:
     - **Date:** current timestamp
     - **Reconstructed:** `Auto-recovered from CHANGELOG (original session did not save context)`
     - **Repo version:** current version from `repository.version.txt`
     - **What was done:** bullet list derived from CHANGELOG entries for each missing version (format: `- Description (vXX.XXr)`)
     - **Where we left off:** `All changes committed and merged to main` (safe default — pushed changes merge via the auto-merge workflow)
     - **Active context:** current TODO items, active reminders, and key template variable states (`TEMPLATE_DEPLOY`, `CHAT_BOOKENDS`, `END_OF_RESPONSE_BLOCK`, `MULTI_SESSION_MODE`)
   - Commit with message `Session start: reconstruct stale session context` (no version bump — housekeeping)
   - Push to the `claude/*` branch so the recovery persists even if the session ends unexpectedly
   - Output `⚠️ Session context was stale (vOLD → vNEW) — auto-recovered from CHANGELOG.` before the normal session context summary
3. **Display** — output `📎 Previous Session Context:` followed by a brief summary of the Latest Session entry (whether fresh or just reconstructed), then output: `💡 *Type **"remember session"** before ending this session to save context for next time.*`

**Skip session context entirely** if `SESSION-CONTEXT.md` has no `## Latest Session` content or the section is empty/placeholder.

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
> - Pre-Commit items #0, #4, #6, #8, #10, #11, #12, #13, #15, #18, #19 still apply normally (plus #1, #2, #3, #5, #7, #9, #16, #17 when `TEMPLATE_DEPLOY` = `On`)
> - **Pre-Push Checklist is never skipped** — all 5 items apply on every repo including the template repo

---
> **--- END OF TEMPLATE REPO GUARD ---**
---

## Pre-Commit Checklist
**Before every commit, verify ALL of the following:**

> **Single commit per interaction** — each user interaction (one back-and-forth turn) must produce **exactly one commit**. All changes for the interaction — the user's requested edits, version bumps, CHANGELOG, README timestamp — go into that single commit. Do not split work into intermediate + push commits under any circumstance you can avoid. **The only exceptions where multiple commits are acceptable**: (a) the user explicitly requests multiple separate commits, or (b) a prior push in the same session already merged into `main` and a new push is needed (the prior commit is physically on `main` already — a new commit is unavoidable). There are no other exceptions — not for rebasing (use `git stash`), not for checkpoints, not for convenience. If you find yourself about to create a second commit, stop and find a way to fold it into one. **Read the full message first** — before making any changes, read the user's entire message and identify ALL requests and implied changes. A single message may contain multiple requests (e.g. "remove X from reminders" + "add toggle variables for Y and Z") — these are all part of one interaction and must be batched into one commit. Do not commit the first request and then treat the rest as a separate task. The pattern to avoid: acting on the first sentence, committing + pushing, then discovering there was more to do in the same message.

> **Push commit vs. intermediate commits** — the **push commit** is the final commit in a session before `git push`. Items #7 (CHANGELOG version sections), #9 (repo version prefix in message), #16 (repo version bump), and #17 (page changelog version sections) only run their full behavior on the push commit. Intermediate commits (earlier commits in the same session) still run the rest of the checklist but skip the per-push portions of those items. This reduces CHANGELOG growth from one version section per commit to one per push.

> **Rebase before push commit** — at the start of **every** push commit cycle, before any version bumps or CHANGELOG edits, check whether the branch needs rebasing onto `origin/main`. **Rebase before making edits, not after** — do not make edits with uncommitted changes and then commit them as an intermediate commit just to get a clean tree for the rebase. Instead: (1) `git fetch origin main`, (2) check ancestry: `git merge-base --is-ancestor origin/main HEAD` — if this returns 0 (true), the branch is already up to date and no rebase is needed; if it returns 1 (false), `origin/main` has advanced and a rebase is required, (3) if rebase needed and working tree is clean: `git rebase origin/main`; if rebase needed but there are uncommitted changes: `git stash`, `git rebase origin/main`, `git stash pop`, (4) start the push commit cycle (version bump, CHANGELOG, README timestamp, etc.) — all edits go into the single push commit.
> **Push commit efficiency** — to minimize overhead, batch the push commit operations: (1) run `date` **once** at the start of the push commit cycle and reuse the timestamp for all files (CHANGELOG version section header, README `Last updated:` line, and any page/GAS changelog version sections), (2) once the new version number and timestamp are determined, issue independent edits as **parallel tool calls** — `repository.version.txt`, `README.md`, `CHANGELOG.md`, and `STATUS.md` (if applicable) can all be edited in the same tool-call batch since they have no dependencies on each other.

> **TEMPLATE REPO GATE** — before running any numbered item, check: does the actual repo name (from `git remote -v`) match `IS_TEMPLATE_REPO` in the Template Variables table? If **yes**, check `TEMPLATE_DEPLOY`:
> - `TEMPLATE_DEPLOY` = `On`: only #14 (QR code) is skipped. Items #1, #2, #3, #5, #6, #7, #9, #16, and #17 run normally — version bumps are needed so deployed pages auto-refresh, and changelogs track version history
> - `TEMPLATE_DEPLOY` = `Off`: items #1, #2, #3, #5, #7, #9, #14, #16, and #17 are **all skipped** — do NOT bump versions, update version-tracking files, add CHANGELOG entries, use version prefixes in commit messages, or generate QR codes. Additionally, reset the CHANGELOG to clean state (see Template Repo Guard). Proceed directly to the items that still apply (#0, #4, #6, #8, #10, #11, #12, #13, #15, #18, #19)
>
> This gate also applies during `initialize` — initialization never bumps versions on any repo

> **MULTI-SESSION GATE** — if `MULTI_SESSION_MODE` = `On` in the Template Variables table, the following items are modified to prevent merge conflicts on shared state files when multiple Claude Code sessions push to the same repo simultaneously:
> - **#16** (repo version bump): **skipped entirely** — `repository.version.txt` is not touched
> - **#11** (README `Last updated:` line): **skipped entirely** — the timestamp/version line is not updated
> - **#7** (CHANGELOG.md): entries are still added to `## [Unreleased]` on every commit, but the **push-commit versioned section creation is skipped** — entries accumulate under `[Unreleased]` across all sessions and are versioned during reconciliation
> - **#17** (page & GAS changelogs): same as #7 — entries added to `[Unreleased]`, versioned sections deferred
> - **#5** (STATUS.md): **skipped entirely** — no version updates (depends on repo version bump)
> - **#9** (commit message format): **no repo version prefix** — commit messages use plain descriptive text or `g`/`w` prefixes only (since per-page/GAS versions still bump)
>
> Items that **still run normally**: #0, #1, #2, #3, #4, #6, #8, #10, #12, #13, #14, #15, #18, #19. Per-page (#2) and per-GAS (#1) version bumps are safe because they're scoped to the specific file being edited — different sessions working on different pages won't conflict.
>
> **This gate is independent of the TEMPLATE REPO GATE** — both are evaluated. If the TEMPLATE REPO GATE already skips an item (e.g. `TEMPLATE_DEPLOY` = `Off`), the multi-session gate is a no-op for that item. If both gates apply, the most restrictive behavior wins.
>
> **Caution**: sessions must work on **different pages/features**. If two sessions edit the same HTML page or `.gs` file, content merge conflicts will still occur — this gate only prevents conflicts on globally shared state files.

0. **Commit belongs to this repo and task** — before staging or committing ANY changes, verify: (a) `git remote -v` still matches the repo you are working on — if it doesn't, STOP and do not commit; (b) every file being staged was modified by THIS session's task, not inherited from a prior session or a different repo; (c) the commit message describes work you actually performed in this session — never commit with a message copied from a prior session's commit. If any of these checks fail, discard the stale changes and proceed only with the user's current request. **This item is never skipped** — it applies on every repo including the template repo
1. **Version bump (.gs)** — if any `.gs` file was modified, increment its `VERSION` variable by 0.01 (e.g. `"01.13g"` → `"01.14g"`) **and** update the corresponding `<page-name>gs.version.txt` in the same GAS project directory to match (e.g. `01.13g` → `01.14g`). The `VERSION` variable in the `.gs` file is the **single source of truth** — the `gs.version.txt` file mirrors it for external reference
2. **Version bump (html.version.txt + meta tag)** — if any embedding HTML page in `live-site-pages/` was modified, increment the version in its `<page-name>html.version.txt` by 0.01 (e.g. `|v01.01w|` → `|v01.02w|`) **and** update the `<meta name="build-version" content="vXX.XXw">` tag in the HTML to match (the meta tag uses just the version string, no pipes). The html.version.txt file is the **single source of truth** for the auto-refresh polling — the meta tag is informational only (not read by the polling logic), so changing only html.version.txt still triggers a reload correctly. **Every commit that modifies an HTML page must bump its version** — even if the version was already bumped for that page in a prior commit within the same session. The auto-refresh polling only detects version *changes* relative to what the browser has cached; if a fix commit deploys with the same version as the broken commit, the browser never reloads and the user sees stale (broken) content. **Skip on template repo when `TEMPLATE_DEPLOY` = `Off`**
3. **Htmlversion.txt is single source** — the polling logic reads html.version.txt on page load to establish the current version, then polls for changes. The `<meta name="build-version">` tag in the HTML is **informational only** — it is kept in sync with html.version.txt for visibility but is never read by the polling logic. Version bumps happen in both html.version.txt and the meta tag, but only html.version.txt drives the auto-refresh. The format uses pipe delimiters: `|v01.00w|` (version is always the middle field). **Skip on template repo when `TEMPLATE_DEPLOY` = `Off`**
4. **Template version freeze** — never bump `live-site-templates/HtmlTemplateAutoUpdatehtml.version.txt` — its version must always stay at `|v01.00w|`
5. **STATUS.md** — if any version was bumped, update the matching version in `repository-information/STATUS.md`. **Skip on template repo when `TEMPLATE_DEPLOY` = `Off`**. **Skip when `MULTI_SESSION_MODE` = `On`**
6. **ARCHITECTURE.md** — if the project structure changed (files or directories added, moved, or deleted), update the diagram in `repository-information/ARCHITECTURE.md`. This item applies on every repo including the template repo. **Version numbers are NOT shown in the diagram** — ARCHITECTURE.md is a structural overview, not a version dashboard. STATUS.md serves as the version dashboard. Mermaid nodes show filenames only (no version strings)
7. **CHANGELOG.md** — every user-facing change must have an entry under `## [Unreleased]` in `repository-information/CHANGELOG.md`, grouped under the appropriate Keep a Changelog category: `### Added` (new features), `### Changed` (changes to existing functionality), `### Fixed` (bug fixes), `### Deprecated` (soon-to-be removed features), `### Removed` (removed features), `### Security` (vulnerability fixes). Only include categories that have entries — do not add empty category headings. Entries are plain descriptions — no per-entry timestamps (the version section header carries the timestamp for the entire push). Format: `- Description`. **Versioned release sections** — on the **push commit** (the final commit before `git push`), move all entries from `## [Unreleased]` into a new version section. The repo version (Pre-Commit #16) bumps on the push commit, so each push produces one version section — not one per commit. Intermediate commits within the same session add entries to `[Unreleased]` without creating a version section. The version section header includes a full EST timestamp (no commit SHA — SHAs are added later during archive rotation; see CHANGELOG-archive.md "SHA enrichment"). **Timestamps must be real** — run `TZ=America/New_York date '+%Y-%m-%d %I:%M:%S %p EST'` to get the actual current time; never fabricate or increment timestamps. Format: `## [vXX.XXr] — YYYY-MM-DD HH:MM:SS AM/PM EST` (repo-only changes), `## [vXX.XXr vXX.XXg] — YYYY-MM-DD HH:MM:SS AM/PM EST` (repo + GAS), `## [vXX.XXr vXX.XXw] — YYYY-MM-DD HH:MM:SS AM/PM EST` (repo + page), or `## [vXX.XXr vXX.XXg vXX.XXw] — YYYY-MM-DD HH:MM:SS AM/PM EST` (all three). Order in header: `r` first, then `g`, then `w`. The `g` and `w` versions in the header reflect the **latest values at push time** — if multiple commits in the session bumped `g` or `w`, use the final bumped version. The version section keeps its category groupings intact. `## [Unreleased]` is then left empty (no placeholder text needed — it will accumulate entries from the next session onward). Latest versions appear first (reverse chronological). **One version, one set of entries** — each version section contains only the entries for changes introduced by that specific push. Once entries are moved from `[Unreleased]` into a version section and pushed, they belong to that version permanently. Later pushes must NOT duplicate or re-include entries from prior version sections — only new changes go into the new version section. **Skip on template repo when `TEMPLATE_DEPLOY` = `Off`** — when skipped, the CHANGELOG must stay clean with `*(No changes yet)*` under a bare `## [Unreleased]` so forks start with a blank history. When `TEMPLATE_DEPLOY` = `On`, CHANGELOG entries are added normally to track version changes on the deployed template. **When `TEMPLATE_DEPLOY` is switched from `On` to `Off`**, reset the CHANGELOG: remove all version sections, remove all entries and category headings under `## [Unreleased]`, replace with `*(No changes yet)*`, and remove the date from the section header (see Template Repo Guard). **Archive rotation** — on the push commit, after creating the new version section, **read the capacity counter (`Sections: X/100`) and check if X > 100**. If so, rotation is MANDATORY — do not skip it. **Quick rule: 100 triggers, date groups move. A date group is ALL sections sharing the same date — could be 1 section or 500. Never split a date group. Today's sections (EST) are always exempt. Repeat until ≤100 non-exempt sections remain.** The full logic is documented in `repository-information/CHANGELOG-archive.md` (see "Rotation Logic" section). The archive file's `*(No archived sections yet)*` placeholder is removed on first rotation. **Capacity counter** — the CHANGELOG header includes a `` `Sections: X/100` `` line showing the current count of version sections vs. the rotation limit. **This counter is a mandatory rotation trigger — when it exceeds 100, archive rotation must run before the push.** Update this counter on every push commit after creating the new version section (and after any archive rotation). Count all `## [vXX.XX*]` lines in the file (excluding `## [Unreleased]`). When `TEMPLATE_DEPLOY` is switched `Off` and the CHANGELOG is reset, reset the counter to `` `Sections: 0/100` ``. **When `MULTI_SESSION_MODE` = `On`**: entries are still added to `## [Unreleased]` on every commit, but the push-commit versioned section creation is skipped — entries accumulate under `[Unreleased]` across all parallel sessions and are bundled into a single version section during reconciliation (see Reconcile Multi-Session Command)
8. **README.md structure tree** — if files or directories were added, moved, or deleted, update the ASCII tree in `README.md`
9. **Commit message format** — the **push commit** message must start with the repo version prefix `v{REPO_VERSION}` (e.g. `v01.03r`). If `.gs` or HTML versions were also bumped on the push commit, append those prefixes in order: `r`, `g`, `w` (e.g. `v01.05r v01.14g v01.02w Fix bug`). **Intermediate commits** (earlier commits in the same session, before the push commit) use `g`/`w` prefixes only if those versions were bumped on that specific commit; if no `g`/`w` versions were bumped, use a plain descriptive message with no version prefix. **Skip on template repo when `TEMPLATE_DEPLOY` = `Off`**. **When `MULTI_SESSION_MODE` = `On`**: skip the repo version prefix; use `g`/`w` prefixes only if those versions were bumped, otherwise plain descriptive message
10. **Developer branding** — any newly created file must have `Developed by: DEVELOPER_NAME` as the last line (using the appropriate comment syntax for the file type), where `DEVELOPER_NAME` is resolved from the Template Variables table
11. **README.md `Last updated:` line** — on every commit, update the `Last updated:` timestamp near the top of `README.md` to the real current time (run `TZ=America/New_York date '+%Y-%m-%d %I:%M:%S %p EST'`), and update the `Repo version:` value on the same line to match `repository-information/repository.version.txt`. Format: `` Last updated: `TIMESTAMP` · Repo version: `vXX.XXr` ``. Since the repo version only bumps on the push commit (#16), intermediate commits will naturally show the existing version — this is expected. When `TEMPLATE_DEPLOY` = `Off` (no repo version bump), keep the version display at `v01.00r`. **Skip when `MULTI_SESSION_MODE` = `On`** — otherwise, this rule always applies and is NOT skipped by the Template Repo Guard
12. **Internal link integrity** — if any markdown file is added, moved, or renamed, verify that all internal links (`[text](path)`) in the repo still resolve to existing files. Pay special attention to cross-directory links — see the Internal Link Reference section for the correct relative paths
13. **README section link tips** — every `##` section in `README.md` that contains (or will contain) any clickable links must have this blockquote as the first line after the heading (before any other content): `> **Tip:** Links below navigate away from this page. **Ctrl + click** (or right-click → *Open in new tab*) to keep this ReadMe visible while you work.` — Sections with no links (e.g. a section with only a code block or plain text) do not need the tip
14. **QR code generation** — if the commit changes the live site URL in `README.md` (i.e. the `https://YOUR_ORG_NAME.github.io/YOUR_REPO_NAME` link — typically during initialization or org/repo name changes), regenerate `repository-information/readme-qr-code.png` to encode the **live site URL** (the `https://YOUR_ORG_NAME.github.io/YOUR_REPO_NAME` GitHub Pages URL — NOT the GitHub repo URL). Use the Python `qrcode` library: `python3 -c "import qrcode; qrcode.make('https://YOUR_ORG_NAME.github.io/YOUR_REPO_NAME').save('repository-information/readme-qr-code.png')"` (with resolved values). If `qrcode` is not installed, install it first with `pip install qrcode[pil]`. Stage the updated PNG alongside the other changes so it lands in the same commit. **Skip if Template Repo Guard applies** — the template repo uses placeholder URLs, so no QR code should be generated for them
15. **GAS config sync** — if any `<page-name>.config.json` file under `googleAppsScripts/` was modified, sync its values to the corresponding `<page-name>.gs` and embedding HTML page. `<page-name>.config.json` is the **single source of truth** for project-unique GAS variables (`TITLE`, `DEPLOYMENT_ID`, `SPREADSHEET_ID`, `SHEET_NAME`, `SOUND_FILE_ID`). Sync targets: (a) the `<page-name>.gs` in the same directory — update the matching `var` declarations, (b) the embedding HTML page (from the GAS Projects table) — update `<title>` (from `TITLE`) and `var _e` inside the GAS iframe IIFE (the obfuscated deployment URL — when `DEPLOYMENT_ID` is not a placeholder, construct the full URL `https://script.google.com/macros/s/{DEPLOYMENT_ID}/exec`, reverse the string, then base64-encode the result; when `DEPLOYMENT_ID` is a placeholder, set `_e` to `''`). To generate the encoded value: `echo -n 'https://script.google.com/macros/s/{DEPLOYMENT_ID}/exec' | rev | base64 -w0`. **Reverse sync**: if `<page-name>.gs` was edited and a config-tracked variable was changed directly in the code, update `<page-name>.config.json` to match — the config file must always reflect the current values. **This item is never skipped** — it applies on every repo including the template repo
17. **Page & GAS changelogs** — if any embedding HTML page in `live-site-pages/` or any `.gs` file in `googleAppsScripts/` was modified, add a user-facing entry to the corresponding changelog in `repository-information/changelogs/` (`<page-name>html.changelog.md` for pages, `<page-name>gs.changelog.md` for GAS scripts). These changelogs are **user-facing** — they describe what a visitor to the webpage would notice or what a user of the script would experience, not internal/backend details. **Writing style**: describe changes from the user's perspective. Say "Faster page loading" not "Optimized database queries". Say "Fixed login button not responding on mobile" not "Fixed event listener delegation in auth.js". Never mention file names, function names, commit SHAs, deployment IDs, or internal architecture. Categories follow Keep a Changelog: `### Added`, `### Changed`, `### Fixed`, `### Removed`. Format: `- Description` (no timestamps per entry). **Versioned release sections** — on the push commit, move entries from `## [Unreleased]` into a new version section. For page changelogs use the page version with repo cross-reference: `## [vXX.XXw] (vXX.XXr) — YYYY-MM-DD HH:MM:SS AM/PM EST`. For GAS changelogs use the GAS version with repo cross-reference: `## [XX.XXg] (vXX.XXr) — YYYY-MM-DD HH:MM:SS AM/PM EST`. The repo version in parentheses lets the developer trace which push introduced the change. `## [Unreleased]` is then left empty. **Archive rotation** — same 100-section rotation logic as the repo CHANGELOG (documented in `repository-information/CHANGELOG-archive.md`). Rotate to `<page-name>html.changelog-archive.md` or `<page-name>gs.changelog-archive.md` respectively (both in `repository-information/changelogs/`). **Capacity counter** — update the `` `Sections: X/100` `` counter after creating the new version section. **When no user-visible change occurred** — if the HTML/GAS change is purely internal (e.g. code refactoring with no visible effect), skip the changelog entry. Only add entries when the user's experience is affected. **Skip on template repo when `TEMPLATE_DEPLOY` = `Off`** — when skipped, keep changelogs clean with `*(No changes yet)*` under `## [Unreleased]`. **When `TEMPLATE_DEPLOY` is switched `Off`**, reset all page and GAS changelogs and their archives the same way as the repo CHANGELOG. **When `MULTI_SESSION_MODE` = `On`**: entries are still added to `## [Unreleased]`, but the push-commit versioned section creation is skipped — entries accumulate and are bundled during reconciliation
18. **Unique file naming** — when creating or renaming a file, no two files anywhere in the repo may share the same filename (basename). If a new file would collide with an existing filename in a different directory, add a distinguishing identifier to the name. The convention follows what is already established: `html` for HTML-page-related files (e.g. `indexhtml.changelog.md`, `indexhtml.version.txt`), `gs` for GAS-related files (e.g. `indexgs.changelog.md`, `indexgs.version.txt`), and descriptive prefixes for other categories. Files that track similar concepts across different subsystems (e.g. changelogs for a page vs. changelogs for its GAS script) must always be disambiguated — the reader should be able to identify which subsystem a file belongs to from its name alone, without needing the directory path. **This item is never skipped** — it applies on every repo including the template repo
16. **Repo version bump** — on the **push commit** (the final commit before `git push`), increment the version in `repository-information/repository.version.txt` by 0.01 (e.g. `v01.00r` → `v01.01r`). The `r` suffix stands for "repository" and distinguishes it from page versions (`w`) and GAS versions (`g`). This version is the **single source of truth** for the overall repository version — it bumps once per push, not on every commit. Intermediate commits within the same session do NOT bump the repo version. **Skip on template repo when `TEMPLATE_DEPLOY` = `Off`** — when skipped, reset `repository.version.txt` to `v01.00r` so forks inherit a clean starting version. **Skip when `MULTI_SESSION_MODE` = `On`**
19. **Private repo compatibility** — before committing, verify that no client-side browser code (HTML pages in `live-site-pages/`, inline `<script>` blocks, or any JavaScript that runs in the visitor's browser) references `raw.githubusercontent.com`, `api.github.com`, or any other GitHub URL that requires authentication. The repo may be private while GitHub Pages remains public — authenticated GitHub endpoints fail silently from browser JavaScript on private repos. Any resource needed by client-side code must be deployed alongside the HTML pages in `live-site-pages/` and fetched via relative URL or the public GitHub Pages domain. **Server-side code is exempt** — GAS scripts (`.gs` files) run on Google's servers with authenticated `GITHUB_TOKEN` from script properties, so they may use `api.github.com` freely. **This item is never skipped** — it applies on every repo including the template repo. *Detailed reference: see `.claude/rules/html-pages.md` — section "Private Repo Compatibility"*

### Maintaining these checklists
- The Session Start, Pre-Commit, and Pre-Push checklists are the **single source of truth** for all actionable rules. Detailed sections below provide reference context only
- When adding new rules to CLAUDE.md, add the actionable check to the appropriate checklist and put supporting details in a reference section — do not duplicate the rule in both places
- When editing CLAUDE.md, check whether any existing reference section restates a checklist item — if so, remove the duplicate and add a `*Rule: see ... Checklist item #N*` pointer instead
- **Content placement** — CLAUDE.md must stay focused on rules and process that Claude enforces every session (checklists, behavioral rules, formatting requirements). Domain-specific coding knowledge, architectural reference, and detailed technical context that Claude only needs when working on specific features should live in separate reference files (e.g. `repository-information/CODING-GUIDELINES.md`, `repository-information/TOKEN-BUDGETS.md`). Replace the extracted content with a one-line pointer: `*See \`repository-information/FILE.md\` — section "X"*`. Claude reads these files on demand when the relevant feature area is being worked on
- **Rules files** — `.claude/rules/` files come in two types: (1) **always-loaded** (no `paths:` frontmatter) — loaded on every interaction, used for behavioral rules, output formatting, and chat bookends; (2) **path-scoped** (with `paths:` frontmatter) — loaded only when working on matching files, used for domain-specific reference (GAS scripts, HTML pages, workflows, etc.). When extracting content from CLAUDE.md, choose the appropriate type based on whether the rules apply universally or only in specific contexts
- **Section positioning** — when adding a new `##` section, place it in the correct attention zone per the Section Placement Guide (in `.claude/rules/behavioral-rules.md`). Mandatory per-session actions go in the primacy zone; behavioral/meta-rules in the upper body; reference material in the lower body; high-frequency per-response formatting in the recency zone
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

## Remember Session Command
If the user says **"Remember Session"** (or similar: "remember this session", "save session context"):
1. **Write session context** to `repository-information/SESSION-CONTEXT.md`:
   - Move any existing `## Latest Session` content to `## Previous Sessions` (prepend it, most recent first)
   - Write a new `## Latest Session` with:
     - **Timestamp**: current date/time
     - **What we worked on**: brief list of tasks completed or in progress
     - **Where we left off**: the current state — what was just done, what's next, any open threads
     - **Key decisions made**: any design choices, rule changes, or user preferences expressed
     - **Active context**: branch name, repo version, any relevant file states
   - Keep each session entry concise but complete enough that a fresh Claude session can read it and continue naturally
2. **Commit** with message `Remember session context` (no version bump — this is a housekeeping action like reminders)
3. **Push** to the `claude/*` branch (Pre-Push Checklist applies)
4. This is a **session-ending action** — after pushing, close out with CODING COMPLETE as normal. **After** `✅✅CODING COMPLETE✅✅` (the very last line of the end-of-response block), output `💡💡SESSION SAVED💡💡` on its own line with the message: *"Session context saved. It's recommended to start a new session now so you don't lose the context we just created. Your next session will automatically pick up where we left off."* Placing it after the closing marker ensures maximum visibility — the user cannot miss it. See `chat-bookends.md` "Post-closing markers" for the formatting rule

**Reading session context**: session context is now surfaced automatically at the start of every session (see "Session context" in the Always Run section). The user can still say "read session context" (or "pick up where we left off", "continue last session") to re-read `repository-information/SESSION-CONTEXT.md` and get a detailed summary at any point during a session.

---
> **--- END OF REMEMBER SESSION COMMAND ---**
---

## Reconcile Multi-Session Command
If the user says **"reconcile"** (or similar: "reconcile multi-session", "end multi-session"), OR if `MULTI_SESSION_MODE` is being switched from `On` → `Off`:

1. **Review what happened** — run `git log origin/main --oneline -30` to show the user all commits that landed while multi-session mode was active. Output a summary: number of commits, which files/pages were touched, which sessions contributed (infer from branch names in merge commits)
2. **Read accumulated entries** — read `## [Unreleased]` from `repository-information/CHANGELOG.md` and all page/GAS changelogs in `repository-information/changelogs/` that have `[Unreleased]` entries. List the accumulated entries for the user to review before proceeding
3. **Set `MULTI_SESSION_MODE` to `Off`** in the Template Variables table (if not already `Off`)
4. **Bump repo version** — increment `repository-information/repository.version.txt` by 0.01 (single bump — all multi-session work is bundled into one reconciliation version, not one per missed session)
5. **Create versioned sections** — move all `[Unreleased]` entries in CHANGELOG.md into a new version section with the reconciliation version and current timestamp. Do the same for each page/GAS changelog that has `[Unreleased]` entries (using their current page/GAS version + repo version cross-reference). Follow all standard CHANGELOG formatting rules (category groupings, timestamps, capacity counters, archive rotation if needed)
6. **Update STATUS.md** — sync all current version numbers
7. **Update README.md** — update the `Last updated:` timestamp and `Repo version:` value
8. **Use version prefix in commit message** — the reconciliation commit uses the new repo version prefix
9. **Commit** with message `vXX.XXr Reconcile multi-session mode` (with appropriate version prefixes if page/GAS versions are referenced)
10. **Push** to the `claude/*` branch (Pre-Push Checklist applies)

**No double-bumping** — the reconciliation performs exactly one repo version bump regardless of how many sessions ran. Per-page and per-GAS versions were already bumped by their respective sessions — do not re-bump them during reconciliation.

**The reconciliation commit is a normal push commit** — all standard Pre-Commit items apply (the multi-session gate is now `Off`, so all items run their full behavior). The only special behavior is that `[Unreleased]` entries from multiple sessions are bundled into a single version section rather than each session getting its own.

**Empty reconciliation** — if `[Unreleased]` has no entries (all sessions only made internal changes with no user-facing changelog entries), the reconciliation still bumps the repo version, updates README/STATUS, and creates the version section (which may have no entries — that's fine, it documents that the repo version advanced). If there's truly nothing to reconcile (no commits landed since multi-session mode was enabled), inform the user and just flip the toggle without a version bump.

---
> **--- END OF RECONCILE MULTI-SESSION COMMAND ---**
---

## Behavioral Rules
*Full rules in `.claude/rules/behavioral-rules.md` (always-loaded, no path scope). Covers: Execution Style, Plan Mode Visibility, AskUserQuestion Visibility, Page-Scope Commands, Pushback & Reasoning, Continuous Improvement, Backups Before Major Changes, Solution Depth, Confidence Disclosure, Validate Before Asserting, User-Perspective Reasoning, Section Placement Guide, Web Search Confidence, Provenance Markers.*

---
> **--- END OF BEHAVIORAL RULES ---**
---


## Reference Files

Path-scoped rules files — loaded automatically when working on matching files. Always-loaded files are listed above (Behavioral Rules, Output Formatting, Chat Bookends).

| Topic | Rules File | Pre-Commit # |
|-------|-----------|-------------|
| Version Bumping (.gs) | `.claude/rules/gas-scripts.md` | #1 |
| Build Version (HTML polling, maintenance mode, new page setup) | `.claude/rules/html-pages.md` | #2, #3, #4 |
| Commit Message Naming | `.claude/rules/gas-scripts.md` | #9 |
| ARCHITECTURE.md Structural Updates | `.claude/rules/repo-docs.md` | #6 |
| GAS Project Config (config.json) | `.claude/rules/gas-scripts.md` | #15 |
| Keeping Documentation Files in Sync | `.claude/rules/repo-docs.md` | #5, #6, #7, #8 |
| Internal Link Reference | `.claude/rules/repo-docs.md` | #12 |
| Relative Path Resolution on GitHub | `.claude/rules/repo-docs.md` | — |
| Markdown Formatting | `.claude/rules/repo-docs.md` | — |
| Coding Guidelines | `.claude/rules/gas-scripts.md` | — |
| Merge Conflict Prevention | `.claude/rules/workflows.md` | — |
| Commit SHA Tracking | `.claude/rules/workflows.md` | — |
| Phantom Edit | `.claude/rules/init-scripts.md` | — |
| Line Ending Safety | `.claude/rules/init-scripts.md` | — |
| Changelog Formats & Archive Rotation | `.claude/rules/changelogs.md` | #7, #17 |
| Private Repo Compatibility | `.claude/rules/html-pages.md` | #19 |

---
> **--- END OF REFERENCE FILES ---**
---
## Output Formatting & Styling
*Full rules in `.claude/rules/output-formatting.md` (always-loaded, no path scope). Covers: CLI Accent Styling Reference, Agent Attribution, Reminders for Developer format.*

---
> **--- END OF OUTPUT FORMATTING & STYLING ---**
---

## Chat Bookends (MANDATORY — EVERY PROMPT)
*Full rules in `.claude/rules/chat-bookends.md`. Examples and summary tables in `.claude/rules/chat-bookends-reference.md`. Both are always-loaded (no path scope).*


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
