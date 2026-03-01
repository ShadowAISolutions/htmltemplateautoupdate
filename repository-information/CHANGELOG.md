# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), with project-specific versioning (`w` = website, `g` = Google Apps Script, `r` = repository). Older sections are rotated to [CHANGELOG-archive.md](CHANGELOG-archive.md) when this file exceeds 100 version sections.

`Sections: 35/100`

## [Unreleased]

## [v01.92r] — 2026-03-01 02:10:10 PM EST

### Changed
- Turned on `CHAT_BOOKENDS` toggle — mid-response bookend markers now emitted
- Updated output formatting pointer in CLAUDE.md to reflect toggle independence — removed hardcoded bookend flow description, replaced with toggle-aware summary
- Fixed remaining toggle-dependent reference in "Duration before user interaction" rule — now uses "response start timestamp" instead of "opening marker (CODING START)"

## [v01.91r] — 2026-03-01 02:05:07 PM EST

### Changed
- Made `CHAT_BOOKENDS` and `END_OF_RESPONSE_BLOCK` toggles fully independent — added silent timestamp/estimate capture so all end-of-response block features (ACTUAL TOTAL COMPLETION TIME, PLAN EXECUTION TIME, ESTIMATE CALIBRATED) work even when mid-response bookends are off, and vice versa

## [v01.90r] — 2026-03-01 01:52:37 PM EST

### Changed
- Turned on `END_OF_RESPONSE_BLOCK` toggle — end-of-response block (UNAFFECTED URLS through CODING COMPLETE) is now emitted after each response

## [v01.89r] — 2026-03-01 01:44:43 PM EST

### Changed
- Renamed `AutoUpdateOnlyHtmlTemplate` to `HtmlTemplateAutoUpdate` across all files, directories, and documentation references (HTML template, GAS template, version files, changelogs, config files)

## [v01.88r] — 2026-03-01 01:28:40 PM EST

### Changed
- Chat bookends and end-of-response block toggles set to Off for streamlined output

## [v01.87r] — 2026-03-01 01:15:52 PM EST

### Changed
- Improved AskUserQuestion Visibility rule — now covers multi-question popups (all questions shown together in chat) and echoes the user's selections back into chat after they respond

## [v01.86r] — 2026-03-01 01:09:09 PM EST

### Added
- Added "AskUserQuestion Visibility" rule — question text and all options are now shown in the chat before the popup appears, so the question context is preserved in conversation history (same pattern as Plan Mode Visibility for ExitPlanMode)

## [v01.85r] — 2026-03-01 12:53:32 PM EST

### Added
- Added multi-session mode (`MULTI_SESSION_MODE` variable) — when enabled, parallel Claude Code sessions can safely push to the same repo without merge conflicts on shared state files (repo version, README timestamp, CHANGELOG version sections, STATUS.md)
- Added "Reconcile Multi-Session" command to catch up on deferred versioning and changelog work when multi-session mode is turned off

## [v01.84r] — 2026-03-01 12:27:00 PM EST

### Changed
- Large file write status messages now include a timestamp and duration estimate so the user knows when the operation started and roughly how long to wait

## [v01.83r] — 2026-03-01 12:22:35 PM EST

### Added
- Added "Plan Mode Visibility" rule — plan content must be output as chat text before calling ExitPlanMode so the user can reference it after the approval window disappears

## [v01.82r] — 2026-03-01 12:16:34 PM EST

### Added
- Added session context staleness detection and auto-reconstruction to Session Start Checklist — when SESSION-CONTEXT.md is outdated (missed "remember session"), the system auto-recovers from CHANGELOG entries, commits, and pushes so context persists across sessions

## [v01.81r] — 2026-03-01 11:58:00 AM EST

### Changed
- Moved SESSION SAVED indicator to appear after CODING COMPLETE instead of inside the end-of-response block — ensures maximum visibility so the user cannot miss the session-save confirmation

## [v01.80r] — 2026-03-01 11:53:27 AM EST

### Added
- Added 4 sandwich ingredients to the to-do list: lettuce, sliced turkey, mustard, pickles

## [v01.79r] — 2026-03-01 11:44:57 AM EST

### Changed
- Session start now shows "📌 Reminders For Developer:" instead of "📌 Reminders from last session:"
- Session start now automatically surfaces previous session context from SESSION-CONTEXT.md (no need to type "read session context")
- Session start now shows a tip reminding the developer about the "remember session" command
- "Remember session" now recommends starting a new session in the end-of-response block to preserve saved context

## [v01.78r] — 2026-03-01 11:39:23 AM EST

### Changed
- Completed "Get bread" to-do item

## [v01.77r] — 2026-03-01 11:25:23 AM EST

### Changed
- Renamed REMINDERS.md heading to "Reminders for Developer" — clarifies these are the developer's own notes, not a system Claude manages autonomously
- Renamed SESSION-CONTEXT.md heading to "Previous Session Context" — clearly distinct from developer reminders
- Broadened "User-Owned Content" rule to cover repurposing/restructuring — never fold a new feature into an existing user-created system or assume one replaces the other without explicit approval
- Updated all references across CLAUDE.md, output-formatting.md, and README.md to use the new names

## [v01.76r] — 2026-03-01 11:20:19 AM EST

### Added
- Added "User-Owned Content — Do Not Override" rule to behavioral-rules.md — never complete, remove, or modify user-created reminders, to-do items, or notes without explicit approval

### Fixed
- Restored incorrectly completed reminder back to Active Reminders — "Consider creating a session recap file" was closed without user approval

## [v01.75r] — 2026-03-01 11:12:55 AM EST

### Added
- Created `repository-information/SESSION-CONTEXT.md` — session context log for cross-session continuity
- Added "Remember Session" command to CLAUDE.md — writes session context to SESSION-CONTEXT.md when the user says "Remember Session", enabling a future session to pick up where the previous one left off

## [v01.74r] — 2026-03-01 11:06:35 AM EST

### Fixed
- Fixed cascading indentation in end-of-response block — added mandatory blank lines between sections and flush-left content to break markdown list context that caused AGENTS USED numbered list to nest all subsequent sections

### Added
- Added "Section separation" formatting rule to end-of-response block in chat-bookends.md — blank line between every section pair, flush-left content

## [v01.73r] — 2026-03-01 10:59:10 AM EST

### Added
- Added NEW FOLDERS section to end-of-response block — shows clickable links to any new directories created during a response, positioned between TODO and AFFECTED URLS (skipped entirely when no folders were created)

## [v01.72r] — 2026-03-01 03:07:05 AM EST

### Changed
- Tightened "Single commit per interaction" rule to absolute — exactly one commit per interaction with only two exceptions (user explicitly requests multiple, or prior push already merged). Removed checkpoint exception

## [v01.71r] — 2026-03-01 03:03:55 AM EST

### Added
- Added "Single commit per interaction" rule to Pre-Commit Checklist — each user interaction should produce one commit, not split into intermediate + push commits

### Changed
- Rewritten "Rebase before push commit" rule — rebase now happens before making edits (using `git stash` if needed) instead of after, eliminating unnecessary intermediate commits

## [v01.70r] — 2026-03-01 02:57:25 AM EST

### Added
- Added "Explicit Opinion When Consulted" behavioral rule — when the user delegates a judgment call via conditional language ("if you think", "if it makes sense"), state the opinion clearly and act on it rather than silently complying
- Added "Rule Placement Autonomy" behavioral rule — autonomously choose the best location (CLAUDE.md, existing rules file, or new rules file) when the user asks to make something a rule, with mandatory contradiction scanning

## [v01.69r] — 2026-03-01 02:50:58 AM EST

### Fixed
- Restored missing estimate calibration details in `.claude/rules/chat-bookends.md` — commit cycle example, "do not over-correct" caveat, calibration output example, follow-up commit fallback, and timing note
- Restored missing placement rule rationale suffixes in `.claude/rules/behavioral-rules.md` — explanatory sentences for all 5 placement zone rules

## [v01.68r] — 2026-03-01 02:24:37 AM EST — [8fea2f9](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/8fea2f922aa17d6b6c4221eba72c084f89fa0770)

### Changed
- Deep compacted CLAUDE.md from 993 → 272 lines (73% reduction) by extracting content to 4 new always-loaded `.claude/rules/` files: `chat-bookends.md`, `chat-bookends-reference.md`, `behavioral-rules.md`, `output-formatting.md`
- Consolidated 13 individual pointer sections into a single Reference Files table
- Moved Commit Message Naming content to `.claude/rules/gas-scripts.md`
- Updated CLAUDE.md pointers and "Maintaining these checklists" section to document always-loaded vs path-scoped rules file types

## [v01.67r] — 2026-03-01 01:46:08 AM EST

### Changed
- Extracted 10 reference sections from CLAUDE.md into 6 path-scoped `.claude/rules/` files, reducing CLAUDE.md from ~1255 to ~993 lines while preserving all functionality via one-line pointers
- Populated `.claude/rules/html-pages.md` with Build Version reference (polling, maintenance mode, new page setup, directory structure)
- Populated `.claude/rules/gas-scripts.md` with Version Bumping, GAS Project Config, and Coding Guidelines Reference
- Populated `.claude/rules/workflows.md` with Merge Conflict Prevention and Commit SHA Tracking
- Populated `.claude/rules/repo-docs.md` with ARCHITECTURE.md updates, Docs Sync, Internal Link Reference, Relative Path Resolution, and Markdown Formatting
- Populated `.claude/rules/changelogs.md` with quick-reference guide for changelog formats and archive rotation
- Populated `.claude/rules/init-scripts.md` with init script details, Phantom Edit, and Line Ending Safety

## [v01.66r] — 2026-03-01 01:22:38 AM EST

### Added
- Added "Backups Before Major Changes" rule to CLAUDE.md — recommends creating `.bak` backups in `repository-information/backups/` before large-scale structural edits to critical files
- Created initial `CLAUDE.md.bak` backup in `repository-information/backups/`

## [v01.65r] — 2026-03-01 01:13:43 AM EST

### Added
- Created `.claude/rules/` directory with 6 path-scoped placeholder rule files for future CLAUDE.md content extraction (html-pages, gas-scripts, workflows, repo-docs, changelogs, init-scripts)

## [v01.64r] — 2026-03-01 01:03:17 AM EST

### Changed
- Eliminated SHA backfill commit from push cycle — CHANGELOG version headers no longer include commit SHA links at push time, reducing each push from 2 commits to 1
- SHA links are now deferred to archive rotation — when entries move from CHANGELOG.md to CHANGELOG-archive.md, the commit SHA is looked up from git log and added to the header automatically
- Removed "CHANGELOG SHA Backfill — Potential Elimination" from IMPROVEMENTS.md (now implemented)

## [v01.63r] — 2026-03-01 12:42:35 AM EST — [97b1022](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/97b102240a16332188623c42eb127771894c17fb)

### Changed
- Disabled maintenance mode on all pages (index.html and test.html) — maintenance overlay removed, pages now accessible normally

## [v01.62r] — 2026-03-01 12:37:10 AM EST — [eef6939](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/eef693974db315b1f88ac1a8db7443d092d51c9a)

### Changed
- Increased CHANGELOG archive rotation limit from 50 to 100 version sections across CLAUDE.md, CHANGELOG.md, and CHANGELOG-archive.md (including rotation logic, quick rule, examples, and capacity counter)

## [v01.61r] — 2026-03-01 12:32:47 AM EST — [766ccd3](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/766ccd368d2b5a3855d8a27e948fe00734b52dd0)

### Fixed
- Completed CHANGELOG archive rotation — moved all 50 remaining 2026-02-28 sections to archive as a single date group (previously only 7 of 57 were moved, incorrectly splitting the date group)

### Changed
- Archive rotation logic clarified: date groups are indivisible — ALL sections sharing a date move together, even if that means moving 50+ sections at once. Added "Quick rule" summary for instant recognition
- Removed incorrect "split by count" fallback from Pre-Commit #7 — date groups are never split

## [v01.60r] — 2026-03-01 12:23:20 AM EST — [78b2b32](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/78b2b320ea24b29d24467f7635165e9bca5c1aab)

### Fixed
- Performed overdue CHANGELOG archive rotation — moved 7 oldest sections (v01.01r–v01.07r) to CHANGELOG-archive.md, reducing from 59 to 52 sections

### Changed
- Archive rotation trigger reinforced in Pre-Commit #7 — capacity counter now explicitly described as a mandatory rotation trigger (when >50, rotation must run), with additional handling for single-date accumulation where all non-exempt sections share one date

## [v01.59r] — 2026-03-01 12:17:26 AM EST — [35c2de6](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/35c2de6c5358b1fbe00f79e73afd31574da44233)

### Changed
- Rebase check now uses direct `git merge-base --is-ancestor` ancestry test instead of tracking session push history — simpler, deterministic, and correct regardless of how many pushes occurred
- Pre-Push #5 simplified to a branch-exists check (rebase responsibility moved to Pre-Commit push commit cycle)
- "Push only once per branch" rule replaced with "Multiple pushes per session are safe" — reflecting actual behavior

## [v01.58r] — 2026-03-01 12:03:06 AM EST — [999344f](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/999344fe93e84189696814a3451fe3d3d2eee647)

### Changed
- Completed "Get tomato" to-do item

Developed by: ShadowAISolutions
