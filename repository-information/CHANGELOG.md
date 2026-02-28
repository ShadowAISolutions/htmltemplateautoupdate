# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), with per-entry EST timestamps and project-specific versioning (`w` = website, `g` = Google Apps Script, `r` = repository). Older sections are rotated to [CHANGELOG-archive.md](CHANGELOG-archive.md) when this file exceeds 20 version sections.

`Sections: 8/20`

## [Unreleased]

## [v01.08r] — 2026-02-28

### Added
- `2026-02-28 14:10:05 EST` — Added capacity counter (`Sections: X/20`) to CHANGELOG.md header — shows current version section count vs. rotation limit at a glance
- `2026-02-28 14:10:05 EST` — Added capacity counter update rule to Pre-Commit #7 — counter updates on every push commit after version section creation and archive rotation

## [v01.07r] — 2026-02-28 — `8b58ebc`

### Added
- `2026-02-28 13:59:08 EST` — Added Continuous Improvement section to CLAUDE.md — when Claude encounters struggles or missed steps, flag them to the user and propose CLAUDE.md additions to prevent recurrence

## [v01.06r] — 2026-02-28 — `abfe8e1`

### Changed
- `2026-02-28 13:56:27 EST` — Fixed SHA backfill instructions in Pre-Commit #16 — after rebase onto `origin/main`, HEAD is the workflow's `[skip ci]` commit, not the version commit; must match version prefix in `git log` output instead of using `git log -1`

## [v01.05r] — 2026-02-28 — `ad76117`

### Changed
- `2026-02-28 13:51:24 EST` — Refined CHANGELOG archive rotation to rotate by date group (all sections sharing the oldest date move together) with current-day exemption
- `2026-02-28 13:51:24 EST` — Added detailed rotation logic documentation to `CHANGELOG-archive.md` (step-by-step procedure, key rules, examples)

## [v01.04r] — 2026-02-28 — `2f70fd4`

### Added
- `2026-02-28 13:48:26 EST` — Added CHANGELOG archive rotation — when CHANGELOG.md exceeds 20 version sections, oldest sections are moved to `CHANGELOG-archive.md`
- `2026-02-28 13:48:26 EST` — Created `repository-information/CHANGELOG-archive.md` for storing rotated changelog sections

### Changed
- `2026-02-28 13:48:26 EST` — Updated Phantom Edit and Template Repo Guard CHANGELOG reset rules to also reset the archive file
- `2026-02-28 13:48:26 EST` — Fixed stale comment in README tree (`repository.version.txt` — "bumps every commit" → "bumps every push")

## [v01.03r] — 2026-02-28 — `17498e8`

### Changed
- `2026-02-28 13:29:17 EST` — Changed repo version bump (#16) from per-commit to per-push — version now increments only on the final commit before `git push`
- `2026-02-28 13:29:17 EST` — Changed CHANGELOG version section creation (#7) from per-commit to per-push — one section per push instead of one per commit, reducing CHANGELOG growth
- `2026-02-28 13:29:17 EST` — Updated commit message format (#9) to distinguish push commits (with `r` prefix) from intermediate commits (with `g`/`w` prefix or no prefix)
- `2026-02-28 13:29:17 EST` — Added push commit concept definition to Pre-Commit Checklist header
- `2026-02-28 13:29:17 EST` — Updated Commit Message Naming reference section with intermediate commit examples
- `2026-02-28 13:29:17 EST` — Clarified Pre-Commit #11 that repo version display stays unchanged on intermediate commits

## [v01.02r] — 2026-02-28 — `dceafab`

### Added
- `2026-02-28 13:13:35 EST` — Added repo version display next to `Last updated:` timestamp in README.md (format: `Last updated: TIMESTAMP · Repo version: vXX.XXr`)

### Changed
- `2026-02-28 13:13:35 EST` — Updated Pre-Commit #11 to include repo version update alongside README timestamp
- `2026-02-28 13:13:35 EST` — Broadened Initialize Command no-version-bump wording to explicitly list all version file types (`repository.version.txt`, `.gs` VERSION, HTML meta tags)

## [v01.01r] — 2026-02-28 — `2a376dd`

### Added
- `2026-02-28 13:09:13 EST` — Introduced repository version system (`v01.XXr`) — tracks every commit with a dedicated version in `repository-information/repository.version.txt`
- `2026-02-28 13:09:13 EST` — Added Pre-Commit #16 (repo version bump + retroactive SHA backfill in CHANGELOG version headers)
- `2026-02-28 13:09:13 EST` — Added `repository.version.txt` node to ARCHITECTURE.md diagram

### Changed
- `2026-02-28 13:09:13 EST` — Updated Pre-Commit #7 CHANGELOG format — version sections now always created (repo version bumps every commit), headers include `r`/`g`/`w` prefixes and retroactive commit SHA
- `2026-02-28 13:09:13 EST` — Updated Pre-Commit #9 commit message format — every commit now starts with `vXX.XXr` prefix, with `g`/`w` appended when those versions also bump
- `2026-02-28 13:09:13 EST` — Updated Template Repo Guard and TEMPLATE REPO GATE to include #16 in version-dependent item lists and reset rules
- `2026-02-28 12:54:17 EST` — Toggled `TEMPLATE_DEPLOY` to `On` — re-enabled GitHub Pages deployment on the template repo
- `2026-02-28 12:54:17 EST` — Documented toggle-commit deploy behavior in CLAUDE.md (Template Variables table and Template Repo Guard) — toggle takes effect on the same commit's push

Developed by: ShadowAISolutions
