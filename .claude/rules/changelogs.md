---
paths:
  - "repository-information/CHANGELOG.md"
  - "repository-information/CHANGELOG-archive.md"
  - "repository-information/changelogs/**"
---

# Changelog Rules

*Actionable rules: see Pre-Commit Checklist items #7 and #17 in CLAUDE.md.*

## Quick Reference

### Repo CHANGELOG (Pre-Commit #7)
- Entries go under `## [Unreleased]` during intermediate commits
- On the **push commit**, entries move from `[Unreleased]` into a new version section
- Version section header format: `## [vXX.XXr] — YYYY-MM-DD HH:MM:SS AM/PM EST`
  - Add `vXX.XXg` and/or `vXX.XXw` if GAS or page versions were bumped
  - Order: `r` first, then `g`, then `w`
  - No commit SHA in the header — SHAs are added during archive rotation (see CHANGELOG-archive.md "SHA enrichment")
- Categories follow [Keep a Changelog](https://keepachangelog.com/en/1.1.0/): `### Added`, `### Changed`, `### Fixed`, `### Deprecated`, `### Removed`, `### Security`
- Only include categories that have entries — no empty headings
- Entry format: `- Description` (no per-entry timestamps)
- Capacity counter (`Sections: X/100`) must be updated on every push commit
- **Archive rotation** triggers when counter exceeds 100 — see `repository-information/CHANGELOG-archive.md` for the full rotation logic

### Page & GAS Changelogs (Pre-Commit #17)
- **User-facing** — describe what a visitor/user would notice, not internal details
- Writing style: "Faster page loading" not "Optimized database queries"
- Never mention file names, function names, commit SHAs, deployment IDs, or internal architecture
- Version section format for pages: `## [vXX.XXw] (vXX.XXr) — YYYY-MM-DD HH:MM:SS AM/PM EST`
- Version section format for GAS: `## [XX.XXg] (vXX.XXr) — YYYY-MM-DD HH:MM:SS AM/PM EST`
- Skip changelog entry if the change is purely internal with no user-visible effect
- Same 100-section archive rotation as the repo CHANGELOG

### Archive Rotation Summary
- **Quick rule**: 100 triggers, date groups move. A date group is ALL sections sharing the same date — could be 1 section or 500. Never split a date group. Today's sections (EST) are always exempt. Repeat until ≤100 non-exempt sections remain
- Full rotation logic is documented in `repository-information/CHANGELOG-archive.md` (see "Rotation Logic" section)
- SHA enrichment happens during rotation — see CHANGELOG-archive.md for details

Developed by: ShadowAISolutions
