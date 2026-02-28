# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), with project-specific versioning (`w` = website, `g` = Google Apps Script, `r` = repository). Older sections are rotated to [CHANGELOG-archive.md](CHANGELOG-archive.md) when this file exceeds 50 version sections.

`Sections: 33/50`

## [Unreleased]

## [v01.33r] — 2026-02-28 06:31:13 PM EST — SHA: *pending next push*

### Added
- Added "URL format gate" self-improvement rule to Unaffected URLs section in CLAUDE.md — forces re-deriving the URL display pattern from current variable values (`IS_TEMPLATE_REPO` match + `TEMPLATE_DEPLOY`) instead of copying from prior responses, preventing the wrong URL format from propagating across responses

## [v01.32r] — 2026-02-28 06:22:07 PM EST — SHA: [`5e3d201`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/5e3d2018c5f7a4ce7e3c7564d3beba26485fe0a5)

### Changed
- Changed bookend date format from `YYYY-MM-DD` to `MM/DD/YYYY` — applies to all 5 time+date bookends (CODING PLAN, CODING START, RESEARCH START, CODING COMPLETE, RESEARCH COMPLETE) and all flow examples
- Completed to-do item "Get lettuce" and removed it from TODO.md

## [v01.31r] — 2026-02-28 06:17:55 PM EST — SHA: [`0d58700`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/0d58700ccd450322f5c1ed377fbc5aa1fd836181)

### Added
- Added 5 items to to-do list: get bread, get turkey, get lettuce, get tomato, get mayo

## [v01.30r] — 2026-02-28 06:14:20 PM EST — SHA: [`9960a53`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/9960a533054121938482e0b0c85911d5c7c7360d)

### Added
- Added `📋📋TODO📋📋` section to the end-of-response block — displays current to-do items from `repository-information/TODO.md`, shows completed items crossed off with checkboxes, and auto-removes them from the file after display

## [v01.29r] — 2026-02-28 05:42:22 PM EST — SHA: [`1181e65`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/1181e65c33f79739d72e5d844af759de7fb3d10b)

### Changed
- Split the Bookend Summary table into two separate tables: "Mid-Response" bookends and "End-of-Response Block" items — makes it easier to see which bookends belong to the work phase vs. the summary block
- Added `END OF RESPONSE BLOCK` header between two backtick-wrapped divider lines at the start of the end-of-response block — provides a clear visual banner separating work output from the summary sections

## [v01.28r] — 2026-02-28 05:27:48 PM EST — SHA: [`8cc1a0b`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/8cc1a0bf696d7ecc9a556e62f2b78e2559b8dd3c)

### Added
- Added "HTML Page Config Files (html.config.json)" design consideration to IMPROVEMENTS.md — documents when and why an HTML-side config.json would become useful, with implementation design notes for future reference

## [v01.27r] — 2026-02-28 05:09:04 PM EST — SHA: [`c20f20d`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/c20f20d8ffb8e67380c77f24a1984185cf32a6a4)

### Changed
- `2026-02-28 05:06:41 PM EST` — Centralized all 12 per-page and per-GAS changelog files into `repository-information/changelogs/` — declutters `live-site-pages/`, `googleAppsScripts/`, and `live-site-templates/` directories, and eliminates false GitHub Pages deployment triggers from changelog-only edits

## [v01.26r v01.02w] — 2026-02-28 04:44:00 PM EST — SHA: [`d64e6d9`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/d64e6d9845a5645409cc13fdd0876ae1b4edecc3)

### Changed
- Standardized HTML version file naming from dot-separated (`index.htmlversion.txt`) to concatenated (`indexhtml.version.txt`) — now uniform with changelog naming pattern (`indexhtml.changelog.md`) and GAS naming pattern (`indexgs.version.txt`)
- Updated JavaScript auto-refresh polling URL construction from `pageName + '.htmlversion.txt'` to `pageName + 'html.version.txt'`

## [v01.25r v01.01w] — 2026-02-28 04:32:51 PM EST — SHA: [`2cf6582`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/2cf658251efcf92cd00c629098c85c75edf599fa)

### Changed
- Renamed HTML page version files to include `html` in filename — `index.version.txt` → `index.htmlversion.txt`, `test.version.txt` → `test.htmlversion.txt`, `AutoUpdateOnlyHtmlTemplate.version.txt` → `AutoUpdateOnlyHtmlTemplate.htmlversion.txt` — completing the disambiguation between HTML and GAS version files
- Updated JavaScript auto-refresh polling logic in all HTML pages to fetch `.htmlversion.txt` instead of `.version.txt`

### Added
- Added Pre-Commit #18 (unique file naming) — enforces that no two files in the repo share the same filename, with distinguishing identifiers (`html`, `gs`, etc.) for files tracking similar concepts across subsystems

## [v01.24r] — 2026-02-28 04:17:58 PM EST — SHA: [`4a26eea`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/4a26eea787f90d828529a34fbd5d50ca38eda527)

### Changed
- Renamed all changelog and GAS version files to include `html` or `gs` in filenames for disambiguation — `index.changelog.md` → `indexhtml.changelog.md` (pages) and `indexgs.changelog.md` (GAS), `index.version.txt` → `indexgs.version.txt` (GAS only — HTML version.txt keeps original name as it's a runtime dependency for auto-refresh polling)
- Updated all internal links within renamed files, CLAUDE.md naming conventions, and README structure tree

## [v01.23r] — 2026-02-28 04:09:55 PM EST — SHA: [`5c7d237`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/5c7d237a5b3c4cd6e3a113c56b892a2af169973e)

### Added
- Added per-GAS-project `<page-name>.version.txt` files that mirror the `VERSION` variable in each `.gs` file — provides external version reference without reading the code
- Added per-GAS-project user-facing changelogs (`<page-name>.changelog.md` and `<page-name>.changelog-archive.md`) in each `googleAppsScripts/` subdirectory
- Added template GAS version file and changelogs in `googleAppsScripts/AutoUpdateOnlyHtmlTemplate/`

### Changed
- Updated Pre-Commit #1 to bump GAS `<page-name>.version.txt` alongside the `.gs` VERSION variable
- Expanded Pre-Commit #17 from "Page changelog" to "Page & GAS changelogs" — now covers both HTML page and GAS script changelogs with appropriate version formats (`w` for pages, `g` for GAS)
- Updated New Embedding Page Setup Checklist with step #10 (create GAS version file and changelog)
- Updated Template Repo Guard and Phantom Edit reset rules to include GAS changelogs and version.txt files

## [v01.22r] — 2026-02-28 04:02:49 PM EST — SHA: [`196a4ed`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/196a4ede2548770e483f1a0da7cfd08cb3e5bb17)

### Changed
- Updated page changelog version section header format to include the corresponding repo version for developer cross-reference — format: `## [vXX.XXw] (vXX.XXr) — YYYY-MM-DD HH:MM:SS AM/PM EST`

## [v01.21r] — 2026-02-28 03:57:32 PM EST — SHA: [`1410eef`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/1410eefb776afbc007b91042691a35652e61d87f)

### Added
- Added user-facing per-page changelogs (`<page-name>.changelog.md` and `<page-name>.changelog-archive.md`) for each HTML page in `live-site-pages/` — describes changes from the visitor's perspective without exposing backend details
- Added template changelog files in `live-site-templates/` for new page setup
- Added Pre-Commit #17 (page changelog) to CLAUDE.md — maintains user-facing changelogs alongside the existing developer-facing repo CHANGELOG

### Changed
- Updated Template Repo Guard, Pre-Commit gate, Phantom Edit, and New Embedding Page Setup Checklist to include #17

## [v01.20r] — 2026-02-28 03:49:03 PM EST — SHA: [`38627b5`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/38627b5c4cee48b12604d9c5d013b096f3cc2637)

### Changed
- Added SHA placeholder (`— SHA: *pending next push*`) to new CHANGELOG version section headers — makes it clear a SHA will be backfilled on the next push, instead of showing nothing
- Updated Pre-Commit #7 format spec to include placeholder in new version section headers
- Updated Pre-Commit #16 backfill logic to replace the placeholder with the actual linked SHA

## [v01.19r] — 2026-02-28 03:38:51 PM EST — SHA: [`d19cddb`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/d19cddb07062c3e51e0241e59d91997de6f2e122)

### Changed
- Added "Conflict cleanup" rule to Continuous Improvement section in CLAUDE.md — when adding or modifying a rule, scan the rest of the file for conflicting text and remove/update it in the same commit
- Fixed stale backfill format in Pre-Commit #7 — was still showing date-only (`YYYY-MM-DD`) instead of the new date+time format

## [v01.18r] — 2026-02-28 03:32:19 PM EST — SHA: [`247665a`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/247665a7504155b1470e96f9a946f7d239dedb8e)

### Fixed
- Fixed CHANGELOG entries — each version section now has its own entries describing what that specific push changed, instead of accumulating entries from prior versions into a single section

### Changed
- Added "One version, one set of entries" clarification to Pre-Commit #7 in CLAUDE.md — entries belong to the version that introduced them and must not be duplicated into later version sections

## [v01.17r] — 2026-02-28 03:24:30 PM EST — SHA: [`e3e5bc2`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/e3e5bc2795fa041bc581c1f99950917155a5f9f3)

### Changed
- Moved timestamps from individual CHANGELOG entries to version section headers — each push is a single atomic unit, so one timestamp per section is sufficient
- Updated Pre-Commit #7 entry format from timestamped entries to plain `- Description`
- Updated version section header format to include full `HH:MM:SS AM/PM EST` timestamp

## [v01.16r] — 2026-02-28 03:21:17 PM EST — SHA: [`d9f668e`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/d9f668e18d95f976fbdcb6e7a1b807617bd76d23)

### Changed
- Added `SHA:` label prefix to COMMIT LOG entries and CHANGELOG version headers — makes it clear that the linked alphanumeric string is a commit SHA (Secure Hash Algorithm identifier)
- Updated Pre-Commit #7 and #16 format specs to include the `SHA:` label
- Updated flow examples in Chat Bookends to show `SHA:` prefix

## [v01.15r] — 2026-02-28 03:17:38 PM EST — SHA: [`2b4d930`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/2b4d93039d2aede730bf939be775ddc7f262426b)

### Changed
- Changed COMMIT LOG SHA links from backtick-wrapped (red/accent) to plain markdown links (clickable, non-red) — matches the style used for file path links like index.html
- Updated flow examples in Chat Bookends to show plain link format

## [v01.14r] — 2026-02-28 03:12:45 PM EST — SHA: [`16ba557`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/16ba55710c33bb6b5ce51f37265fce33540a89b8)

### Changed
- Added linked SHAs to COMMIT LOG end-of-response section — commits now link to their GitHub commit page for one-click navigation
- Updated COMMIT LOG format spec in Chat Bookends and flow examples

## [v01.13r] — 2026-02-28 03:08:41 PM EST — SHA: [`8440b6e`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/8440b6eb7a0ef05c922f7dd9f2f77baf5789a487)

### Changed
- Made CHANGELOG commit SHAs clickable links to GitHub commit pages — updated Pre-Commit #7 and #16 format specs
- Converted all 11 existing SHA entries in CHANGELOG to linked format

## [v01.12r] — 2026-02-28 02:44:13 PM EST — SHA: [`96c0667`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/96c06679947b092b9582005448aa092e84922a34)

### Changed
- Reframed "Validate Before Asserting" in CLAUDE.md — "Wait. No." moments are acceptable and expected; what matters is treating each one as a Continuous Improvement trigger to propose CLAUDE.md additions that prevent the same mistake from recurring

## [v01.11r] — 2026-02-28 02:40:29 PM EST — SHA: [`8e78453`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/8e78453c83cbccd8ceef2803b144f473f3f48909)

### Changed
- Strengthened "Validate Before Asserting" rule in CLAUDE.md — now covers mid-reasoning assertions (not just opening statements), adds explicit "Wait. No." pattern warning, and emphasizes tracing multi-step logic to completion before asserting any step works

## [v01.10r] — 2026-02-28 02:33:19 PM EST — SHA: [`3d087fe`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/3d087fe6b6518e28755197318e64541c04d2417e)

### Added
- Added "Validate Before Asserting" section to CLAUDE.md — reason through claims before stating them as fact; never lead with a confident assertion that hasn't been verified

## [v01.09r] — 2026-02-28 02:26:52 PM EST — SHA: [`8b3a82c`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/8b3a82cac958665ad2ed9bd1854b026ba9a3e48f)

### Changed
- Increased CHANGELOG archive rotation limit from 20 to 50 version sections across CLAUDE.md, CHANGELOG.md, and CHANGELOG-archive.md (including rotation logic examples)

## [v01.08r] — 2026-02-28 02:10:05 PM EST — SHA: [`eb3266b`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/eb3266b3d7176594a824ed92c44f7aab850e01ab)

### Added
- Added capacity counter (`Sections: X/20`) to CHANGELOG.md header — shows current version section count vs. rotation limit at a glance
- Added capacity counter update rule to Pre-Commit #7 — counter updates on every push commit after version section creation and archive rotation

## [v01.07r] — 2026-02-28 01:59:08 PM EST — SHA: [`8b58ebc`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/8b58ebcb7d387a5a19afed9d07712c212b677e20)

### Added
- Added Continuous Improvement section to CLAUDE.md — when Claude encounters struggles or missed steps, flag them to the user and propose CLAUDE.md additions to prevent recurrence

## [v01.06r] — 2026-02-28 01:56:27 PM EST — SHA: [`abfe8e1`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/abfe8e18dd2028b2e112165d71763e441d8f6b43)

### Changed
- Fixed SHA backfill instructions in Pre-Commit #16 — after rebase onto `origin/main`, HEAD is the workflow's `[skip ci]` commit, not the version commit; must match version prefix in `git log` output instead of using `git log -1`

## [v01.05r] — 2026-02-28 01:51:24 PM EST — SHA: [`ad76117`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/ad76117802c331ae1730c78f7ee3867a6e02d383)

### Changed
- Refined CHANGELOG archive rotation to rotate by date group (all sections sharing the oldest date move together) with current-day exemption
- Added detailed rotation logic documentation to `CHANGELOG-archive.md` (step-by-step procedure, key rules, examples)

## [v01.04r] — 2026-02-28 01:48:26 PM EST — SHA: [`2f70fd4`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/2f70fd45c4744fc9094c1807aaf91913fcc7469d)

### Added
- Added CHANGELOG archive rotation — when CHANGELOG.md exceeds 20 version sections, oldest sections are moved to `CHANGELOG-archive.md`
- Created `repository-information/CHANGELOG-archive.md` for storing rotated changelog sections

### Changed
- Updated Phantom Edit and Template Repo Guard CHANGELOG reset rules to also reset the archive file
- Fixed stale comment in README tree (`repository.version.txt` — "bumps every commit" → "bumps every push")

## [v01.03r] — 2026-02-28 01:29:17 PM EST — SHA: [`17498e8`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/17498e80290c434d072ae8011f31c8e4903fbb16)

### Changed
- Changed repo version bump (#16) from per-commit to per-push — version now increments only on the final commit before `git push`
- Changed CHANGELOG version section creation (#7) from per-commit to per-push — one section per push instead of one per commit, reducing CHANGELOG growth
- Updated commit message format (#9) to distinguish push commits (with `r` prefix) from intermediate commits (with `g`/`w` prefix or no prefix)
- Added push commit concept definition to Pre-Commit Checklist header
- Updated Commit Message Naming reference section with intermediate commit examples
- Clarified Pre-Commit #11 that repo version display stays unchanged on intermediate commits

## [v01.02r] — 2026-02-28 01:13:35 PM EST — SHA: [`dceafab`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/dceafab59bc174ef7acb32af0e990d711bc90abd)

### Added
- Added repo version display next to `Last updated:` timestamp in README.md (format: `Last updated: TIMESTAMP · Repo version: vXX.XXr`)

### Changed
- Updated Pre-Commit #11 to include repo version update alongside README timestamp
- Broadened Initialize Command no-version-bump wording to explicitly list all version file types (`repository.version.txt`, `.gs` VERSION, HTML meta tags)

## [v01.01r] — 2026-02-28 01:09:13 PM EST — SHA: [`2a376dd`](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/2a376dd66a987d1125a1589a8ebe74b39b30ef73)

### Added
- Introduced repository version system (`v01.XXr`) — tracks every commit with a dedicated version in `repository-information/repository.version.txt`
- Added Pre-Commit #16 (repo version bump + retroactive SHA backfill in CHANGELOG version headers)
- Added `repository.version.txt` node to ARCHITECTURE.md diagram

### Changed
- Updated Pre-Commit #7 CHANGELOG format — version sections now always created (repo version bumps every commit), headers include `r`/`g`/`w` prefixes and retroactive commit SHA
- Updated Pre-Commit #9 commit message format — every commit now starts with `vXX.XXr` prefix, with `g`/`w` appended when those versions also bump
- Updated Template Repo Guard and TEMPLATE REPO GATE to include #16 in version-dependent item lists and reset rules
- Toggled `TEMPLATE_DEPLOY` to `On` — re-enabled GitHub Pages deployment on the template repo
- Documented toggle-commit deploy behavior in CLAUDE.md (Template Variables table and Template Repo Guard) — toggle takes effect on the same commit's push

Developed by: ShadowAISolutions
