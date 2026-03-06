# Changelog — Test Title 3

All notable user-facing changes to this page are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Older sections are rotated to [testation3html.changelog-archive.md](testation3html.changelog-archive.md) when this file exceeds 50 version sections.

`Sections: 7/50`

## [Unreleased]

## [v01.07w] — 2026-03-05 11:30:39 PM EST — v03.35r

### Added
- Green "Code Ready" splash screen with dedicated sound for GAS version updates
- Blue "Website Ready" splash screen with website sound for HTML version updates

### Changed
- GAS update reload now shows its own green splash and plays "Code Ready" sound instead of reusing the website update behavior

## [v01.06w] — 2026-03-05 11:17:54 PM EST — v03.33r

### Added
- GAS version pill (bottom-left) with countdown dot showing next check timer
- GAS changelog popup — click the GAS pill to view the script's update history

## [v01.05w] — 2026-03-05 11:06:42 PM EST — v03.32r

### Added
- GAS version polling — page now detects GAS script updates and reloads automatically

### Removed
- PostMessage-based GAS reload listener (replaced by direct version file polling)

## [v01.04w] — 2026-03-05 05:09:46 PM EST — v03.20r

### Changed
- Version bumped to v01.04w

## [v01.03w] — 2026-03-05 04:01:02 PM EST — v03.16r

### Removed
- GAS version indicator and changelog popup removed from the HTML layer — now handled entirely within the GAS iframe

## [v01.02w] — 2026-03-05 03:47:47 PM EST — v03.15r

### Fixed
- GAS version indicator now appears immediately on page load instead of staying hidden
- GAS version auto-checking now works reliably without manual refresh

## [v01.01w] — 2026-03-05 03:34:35 PM EST — v03.14r

### Added
- GAS version indicator at bottom-left showing script version with countdown to next check
- GAS changelog popup — click the GAS version pill to view update history

Developed by: ShadowAISolutions
