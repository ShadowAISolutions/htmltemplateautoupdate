# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), with per-entry EST timestamps and project-specific versioning (`w` = website, `g` = Google Apps Script, `r` = repository). Older sections are rotated to [CHANGELOG-archive.md](CHANGELOG-archive.md) when this file exceeds 50 version sections.

`Sections: 15/50`

## [Unreleased]

## [v01.15r] — 2026-02-28

### Changed
- `2026-02-28 15:17:38 EST` — Changed COMMIT LOG SHA links from backtick-wrapped (red/accent) to plain markdown links (clickable, non-red) — matches the style used for file path links like index.html
- `2026-02-28 15:12:45 EST` — Added linked SHAs to COMMIT LOG end-of-response section — commits now link to their GitHub commit page for one-click navigation
- `2026-02-28 15:08:41 EST` — Made CHANGELOG commit SHAs clickable links to GitHub commit pages — updated Pre-Commit #7 and #16 format specs, converted all 11 existing SHA entries to linked format
- `2026-02-28 14:44:13 EST` — Reframed "Validate Before Asserting" in CLAUDE.md — "Wait. No." moments are acceptable and expected; what matters is treating each one as a Continuous Improvement trigger to propose CLAUDE.md additions that prevent the same mistake from recurring

## [v01.14r] — 2026-02-28 — [`16ba557`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/16ba55710c33bb6b5ce51f37265fce33540a89b8)

## [v01.13r] — 2026-02-28 — [`8440b6e`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/8440b6eb7a0ef05c922f7dd9f2f77baf5789a487)

## [v01.12r] — 2026-02-28 — [`96c0667`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/96c06679947b092b9582005448aa092e84922a34)

## [v01.11r] — 2026-02-28 — [`8e78453`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/8e78453c83cbccd8ceef2803b144f473f3f48909)

### Changed
- `2026-02-28 14:40:29 EST` — Strengthened "Validate Before Asserting" rule in CLAUDE.md — now covers mid-reasoning assertions (not just opening statements), adds explicit "Wait. No." pattern warning, and emphasizes tracing multi-step logic to completion before asserting any step works

## [v01.10r] — 2026-02-28 — [`3d087fe`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/3d087fe6b6518e28755197318e64541c04d2417e)

### Added
- `2026-02-28 14:33:19 EST` — Added "Validate Before Asserting" section to CLAUDE.md — reason through claims before stating them as fact; never lead with a confident assertion that hasn't been verified

## [v01.09r] — 2026-02-28 — [`8b3a82c`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/8b3a82cac958665ad2ed9bd1854b026ba9a3e48f)

### Changed
- `2026-02-28 14:26:52 EST` — Increased CHANGELOG archive rotation limit from 20 to 50 version sections across CLAUDE.md, CHANGELOG.md, and CHANGELOG-archive.md (including rotation logic examples)

## [v01.08r] — 2026-02-28 — [`eb3266b`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/eb3266b3d7176594a824ed92c44f7aab850e01ab)

### Added
- `2026-02-28 14:10:05 EST` — Added capacity counter (`Sections: X/20`) to CHANGELOG.md header — shows current version section count vs. rotation limit at a glance
- `2026-02-28 14:10:05 EST` — Added capacity counter update rule to Pre-Commit #7 — counter updates on every push commit after version section creation and archive rotation

## [v01.07r] — 2026-02-28 — [`8b58ebc`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/8b58ebcb7d387a5a19afed9d07712c212b677e20)

### Added
- `2026-02-28 13:59:08 EST` — Added Continuous Improvement section to CLAUDE.md — when Claude encounters struggles or missed steps, flag them to the user and propose CLAUDE.md additions to prevent recurrence

## [v01.06r] — 2026-02-28 — [`abfe8e1`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/abfe8e18dd2028b2e112165d71763e441d8f6b43)

### Changed
- `2026-02-28 13:56:27 EST` — Fixed SHA backfill instructions in Pre-Commit #16 — after rebase onto `origin/main`, HEAD is the workflow's `[skip ci]` commit, not the version commit; must match version prefix in `git log` output instead of using `git log -1`

## [v01.05r] — 2026-02-28 — [`ad76117`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/ad76117802c331ae1730c78f7ee3867a6e02d383)

### Changed
- `2026-02-28 13:51:24 EST` — Refined CHANGELOG archive rotation to rotate by date group (all sections sharing the oldest date move together) with current-day exemption
- `2026-02-28 13:51:24 EST` — Added detailed rotation logic documentation to `CHANGELOG-archive.md` (step-by-step procedure, key rules, examples)

## [v01.04r] — 2026-02-28 — [`2f70fd4`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/2f70fd45c4744fc9094c1807aaf91913fcc7469d)

### Added
- `2026-02-28 13:48:26 EST` — Added CHANGELOG archive rotation — when CHANGELOG.md exceeds 20 version sections, oldest sections are moved to `CHANGELOG-archive.md`
- `2026-02-28 13:48:26 EST` — Created `repository-information/CHANGELOG-archive.md` for storing rotated changelog sections

### Changed
- `2026-02-28 13:48:26 EST` — Updated Phantom Edit and Template Repo Guard CHANGELOG reset rules to also reset the archive file
- `2026-02-28 13:48:26 EST` — Fixed stale comment in README tree (`repository.version.txt` — "bumps every commit" → "bumps every push")

## [v01.03r] — 2026-02-28 — [`17498e8`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/17498e80290c434d072ae8011f31c8e4903fbb16)

### Changed
- `2026-02-28 13:29:17 EST` — Changed repo version bump (#16) from per-commit to per-push — version now increments only on the final commit before `git push`
- `2026-02-28 13:29:17 EST` — Changed CHANGELOG version section creation (#7) from per-commit to per-push — one section per push instead of one per commit, reducing CHANGELOG growth
- `2026-02-28 13:29:17 EST` — Updated commit message format (#9) to distinguish push commits (with `r` prefix) from intermediate commits (with `g`/`w` prefix or no prefix)
- `2026-02-28 13:29:17 EST` — Added push commit concept definition to Pre-Commit Checklist header
- `2026-02-28 13:29:17 EST` — Updated Commit Message Naming reference section with intermediate commit examples
- `2026-02-28 13:29:17 EST` — Clarified Pre-Commit #11 that repo version display stays unchanged on intermediate commits

## [v01.02r] — 2026-02-28 — [`dceafab`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/dceafab59bc174ef7acb32af0e990d711bc90abd)

### Added
- `2026-02-28 13:13:35 EST` — Added repo version display next to `Last updated:` timestamp in README.md (format: `Last updated: TIMESTAMP · Repo version: vXX.XXr`)

### Changed
- `2026-02-28 13:13:35 EST` — Updated Pre-Commit #11 to include repo version update alongside README timestamp
- `2026-02-28 13:13:35 EST` — Broadened Initialize Command no-version-bump wording to explicitly list all version file types (`repository.version.txt`, `.gs` VERSION, HTML meta tags)

## [v01.01r] — 2026-02-28 — [`2a376dd`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/2a376dd66a987d1125a1589a8ebe74b39b30ef73)

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
