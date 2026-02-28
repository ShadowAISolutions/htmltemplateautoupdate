# Changelog Archive

Older version sections rotated from [CHANGELOG.md](CHANGELOG.md). Full granularity preserved — entries are moved here verbatim when the main changelog exceeds 20 version sections.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), with per-entry EST timestamps and project-specific versioning (`w` = website, `g` = Google Apps Script, `r` = repository).

## Rotation Logic

When Claude runs Pre-Commit #7 on the push commit, after creating the new version section in CHANGELOG.md, this rotation procedure runs:

### Step-by-step

1. **Count** — count all `## [vXX.XX*]` version sections in CHANGELOG.md (exclude `## [Unreleased]`)
2. **Threshold check** — if the count is **20 or fewer**, stop — no rotation needed
3. **Current-day exemption** — get today's date (EST). Any version section whose date (`YYYY-MM-DD` in the header) matches today is **exempt from rotation**, even if the total exceeds 20. This means the main changelog can temporarily exceed the 20-section limit on busy days — it self-corrects on the next push after midnight
4. **Identify the oldest date group** — among the non-exempt sections (dates before today), find the **oldest date** that appears in any section header. All sections sharing that date form a "date group"
5. **Rotate the group** — move the entire date group (all sections with that oldest date) from CHANGELOG.md to CHANGELOG-archive.md:
   - Remove them from CHANGELOG.md
   - Append them to CHANGELOG-archive.md, **above** the `Developed by:` footer line, in their original order (oldest version first within the date, which is the bottom-up order they already appear in since CHANGELOG.md is reverse-chronological)
   - On the first rotation, remove the `*(No archived sections yet)*` placeholder
6. **Re-check** — after moving one date group, re-count the non-exempt sections remaining. If still above 20, repeat steps 4–5 with the next oldest date group. Continue until ≤20 non-exempt sections remain (or only today's sections are left)

### Key rules

- **Group by date, not individually** — never split a date group across the two files. All sections from the same day move together
- **Never rotate today** — today's sections always stay in CHANGELOG.md regardless of count. The limit is enforced against older dates only
- **Preserve content verbatim** — sections are moved exactly as-is (headers, categories, entries, timestamps, SHA backfills). No reformatting
- **Order in archive** — newest archived sections appear at the top of the archive (just like CHANGELOG.md uses reverse-chronological order). When appending a newly rotated date group, insert it **above** any previously archived sections but below the archive header
- **Threshold is configurable** — the limit of 20 sections is defined in Pre-Commit #7 in CLAUDE.md. To change it, update the number there

### Examples

**Scenario: 22 sections, all from different dates**
- Sections span dates 2026-01-01 through 2026-01-22, today is 2026-01-22
- Today's section (2026-01-22) is exempt → 21 non-exempt sections
- Oldest date group: 2026-01-01 (1 section) → rotate it → 20 non-exempt remain → done

**Scenario: 22 sections, 5 from today**
- 5 sections from today (exempt), 17 from older dates
- 17 ≤ 20 → no rotation needed despite 22 total

**Scenario: 25 sections, 3 from today, oldest date has 4 sections**
- 22 non-exempt sections, oldest date has 4 → rotate those 4 → 18 non-exempt remain → done

**Scenario: 25 sections, 3 from today, oldest two dates have 2 each**
- 22 non-exempt → rotate oldest date (2 sections) → 20 non-exempt → done

---

*(No archived sections yet)*

Developed by: ShadowAISolutions
