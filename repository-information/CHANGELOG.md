# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), with per-entry EST timestamps and project-specific versioning (`w` = website, `g` = Google Apps Script, `r` = repository).

## [Unreleased]

## [v01.02r] — 2026-02-28

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
