# Changelog Archive

Older version sections rotated from [CHANGELOG.md](CHANGELOG.md). Full granularity preserved — entries are moved here verbatim when the main changelog exceeds 50 version sections.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), with per-entry EST timestamps and project-specific versioning (`w` = website, `g` = Google Apps Script, `r` = repository).

## Rotation Logic

When Claude runs Pre-Commit #7 on the push commit, after creating the new version section in CHANGELOG.md, this rotation procedure runs:

### Step-by-step

1. **Count** — count all `## [vXX.XX*]` version sections in CHANGELOG.md (exclude `## [Unreleased]`)
2. **Threshold check** — if the count is **50 or fewer**, stop — no rotation needed
3. **Current-day exemption** — get today's date (EST). Any version section whose date (`YYYY-MM-DD` in the header) matches today is **exempt from rotation**, even if the total exceeds 50. This means the main changelog can temporarily exceed the 50-section limit on busy days — it self-corrects on the next push after midnight
4. **Identify the oldest date group** — among the non-exempt sections (dates before today), find the **oldest date** that appears in any section header. All sections sharing that date form a "date group"
5. **Rotate the group** — move the entire date group (all sections with that oldest date) from CHANGELOG.md to CHANGELOG-archive.md:
   - Remove them from CHANGELOG.md
   - Append them to CHANGELOG-archive.md, **above** the `Developed by:` footer line, in their original order (oldest version first within the date, which is the bottom-up order they already appear in since CHANGELOG.md is reverse-chronological)
   - On the first rotation, remove the `*(No archived sections yet)*` placeholder
6. **Re-check** — after moving one date group, re-count the non-exempt sections remaining. If still above 50, repeat steps 4–5 with the next oldest date group. Continue until ≤50 non-exempt sections remain (or only today's sections are left)

### Key rules

- **Group by date, not individually** — never split a date group across the two files. All sections from the same day move together
- **Never rotate today** — today's sections always stay in CHANGELOG.md regardless of count. The limit is enforced against older dates only
- **Preserve content verbatim** — sections are moved exactly as-is (headers, categories, entries, timestamps, SHA backfills). No reformatting
- **Order in archive** — newest archived sections appear at the top of the archive (just like CHANGELOG.md uses reverse-chronological order). When appending a newly rotated date group, insert it **above** any previously archived sections but below the archive header
- **Threshold is configurable** — the limit of 50 sections is defined in Pre-Commit #7 in CLAUDE.md. To change it, update the number there

### Examples

**Scenario: 52 sections, all from different dates**
- Sections span dates 2026-01-01 through 2026-02-21, today is 2026-02-21
- Today's section (2026-02-21) is exempt → 51 non-exempt sections
- Oldest date group: 2026-01-01 (1 section) → rotate it → 50 non-exempt remain → done

**Scenario: 52 sections, 5 from today**
- 5 sections from today (exempt), 47 from older dates
- 47 ≤ 50 → no rotation needed despite 52 total

**Scenario: 55 sections, 3 from today, oldest date has 4 sections**
- 52 non-exempt sections, oldest date has 4 → rotate those 4 → 48 non-exempt remain → done

**Scenario: 55 sections, 3 from today, oldest two dates have 2 each**
- 52 non-exempt → rotate oldest date (2 sections) → 50 non-exempt → done

---

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
