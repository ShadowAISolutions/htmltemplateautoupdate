# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), with project-specific versioning (`w` = website, `g` = Google Apps Script, `r` = repository). Older sections are rotated to [CHANGELOG-archive.md](CHANGELOG-archive.md) when this file exceeds 100 version sections.

`Sections: 14/100`

## [Unreleased]

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
