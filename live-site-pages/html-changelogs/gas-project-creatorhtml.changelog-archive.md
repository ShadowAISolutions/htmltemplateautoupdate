# Changelog Archive — GAS Project Creator Page

Older version sections rotated from [gas-project-creatorhtml.changelog.md](gas-project-creatorhtml.changelog.md). Full granularity preserved — entries are moved here verbatim when the main changelog exceeds 50 version sections.

## Rotation Logic

Same rotation logic as the repository changelog archive — see [CHANGELOG-archive.md](../../repository-information/CHANGELOG-archive.md) for the full procedure. In brief: count version sections, skip if ≤50, never rotate today's sections, rotate the oldest full date group together.

---

## [v01.47w] — 2026-03-04 10:19:18 PM EST — v02.90r — [5d07e94](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/5d07e94492d7f83f240401391788eb4f0e109fd1)

### Changed
- Blank optional fields now show placeholder variable names in copied config instead of hardcoded defaults

## [v01.46w] — 2026-03-04 10:10:42 PM EST — v02.89r — [4b12300](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/4b12300fd291b4e31a319d83c0f7cf2230e9e59e)

### Changed
- Test GAS Connection button now labeled as optional

### Removed
- Notification toast no longer appears when clearing config fields

## [v01.45w] — 2026-03-04 09:59:20 PM EST — v02.88r — [5267136](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/52671366661abc0258f87e03786b3344c54f5181)

### Fixed
- Setup steps now align flush left under section headers instead of being indented

## [v01.44w] — 2026-03-04 09:52:43 PM EST — v02.87r — [610cfc2](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/610cfc2440666589ce3e754d2b9ad491873f5d2d)

### Changed
- Step 4 now recommends creating scripts via Google Sheets as the preferred method
- Standalone script creation shown as an alternative option

## [v01.43w] — 2026-03-04 09:39:40 PM EST — v02.86r — [742d596](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/742d5960d6488adf6f4065cde5bb3668e9747255)

### Changed
- Developer splash logo updated
- Default splash logo URL in setup config updated

## [v01.42w] — 2026-03-04 09:31:18 PM EST — v02.85r — [b1ec6cb](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/b1ec6cbf2cede53e74964e924b7ac5191dabb3be)

### Changed
- Step 4 now explains standalone vs. linked script creation
- Troubleshooting label updated to "Potential Troubleshooting"

## [v01.41w] — 2026-03-04 09:17:35 PM EST — v02.84r — [3a9a607](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/3a9a607e76443a511810aaed0d8e513f77668afd)

### Changed
- Input fields now start empty with placeholder hints instead of pre-filled values
- Copy Config button styled with Claude-branded coral/orange color

## [v01.40w] — 2026-03-04 09:11:25 PM EST — v02.83r — [939eb4b](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/939eb4b25c4859f1979a8d7dfedf4fd2c93c3393)

### Changed
- Copy Config for Claude button now purple for better visibility
- Clear buttons fully empty fields instead of resetting to defaults
- Removed placeholder text from most input fields for cleaner look
- doGet deployment hint also shown below Test GAS Connection button
- Token reuse note now warns that GitHub only shows tokens once

## [v01.39w] — 2026-03-04 09:01:23 PM EST — v02.82r — [447202d](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/447202d4b0836cd4c2150a16f778202015bad5c0)

### Changed
- GAS preview panel tab is now always accessible
- "Script function not found: doGet" hint with lightbulb emoji now appears at the top of the GAS preview panel
- GitHub token link narrowed to only "Fine-grained tokens" text

## [v01.38w] — 2026-03-04 08:54:07 PM EST — v02.81r — [4015b4c](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/4015b4c4e2e4d16d30a4d7d205738a7818b93215)

### Added
- Hint explaining that "Script function not found: doGet" confirms a valid deployment ID — proceed with other fields and copy Code.gs

## [v01.37w] — 2026-03-04 08:47:21 PM EST — v02.80r — [8005148](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/8005148c7a05fe98a5fa34d009dcda63f0d02733)

### Fixed
- Test GAS Connection button now correctly appears grayed out when deployment ID is empty

## [v01.36w] — 2026-03-04 08:42:52 PM EST — v02.79r — [758f879](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/758f87900a6f077950d2332d5d5ccf106a150d5b)

### Removed
- HTML Layer status dashboard — redundant status indicators no longer shown

### Changed
- Setup instruction URLs are now clickable links that open in a new tab

## [v01.35w] — 2026-03-04 08:36:59 PM EST — v02.78r — [e16d67e](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/e16d67e970497ea0c799f319cedfd78ad5337dc8)

### Changed
- Deployment ID hint now references "Test GAS Connection" instead of old name
- "Copy Code.gs" button renamed to "Copy Code.gs for GAS"
- "Copy Claude Config" button renamed to "Copy Config for Claude"

## [v01.34w] — 2026-03-04 08:27:39 PM EST — v02.77r — [7e531a7](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/7e531a765ad19179d9c0fa075eb19e4c5e0b5de2)

### Changed
- Audio context status now correctly shows as active when sound has been unlocked in the current session

### Removed
- Configuration values no longer persist between page refreshes — form resets to defaults on reload
- Clear Local Storage button

## [v01.33w] — 2026-03-04 08:18:28 PM EST — v02.76r — [f3e45e9](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/f3e45e9de82effcdbe347581525f01277f95c510)

### Changed
- Title field is now marked as optional in the setup form
- Test GAS Connection only validates the deployment ID — no longer changes the page title or saves configuration

### Removed
- Tip banner about doGet errors from the GAS preview panel

## [v01.32w] — 2026-03-04 08:08:19 PM EST — v02.75r — [db62bfa](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/db62bfab5d5fb0e34d963e2c09169ba55233344e)

### Changed
- Simplified the configuration form — Version, GitHub Owner, GitHub Repo, and GitHub Branch are now handled automatically when copying the Claude config prompt

### Removed
- Version, GitHub Owner, GitHub Repo, and GitHub Branch input fields from the setup form

## [v01.31w] — 2026-03-04 08:02:31 PM EST — v02.74r — [d4e7576](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/d4e75764871e3890e1d636758f404baf7b8f644f)

### Changed
- Test GAS Connection panel now shows a helpful tip explaining that the "Script function not found: doGet" error means your Deployment ID is valid

### Removed
- GAS Deployment ID status indicator from the dashboard — the Test GAS Connection panel validates the ID directly
- "LOCALSTORAGE" badge from the Setup & Configuration header

## [v01.30w] — 2026-03-04 07:20:53 PM EST — v02.73r — [91cb1c2](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/91cb1c218bd87658c773ed7ebaad169bb2cab13a)

### Changed
- Test GAS Connection now opens in a resizable bottom panel with a tab toggle instead of a popup window — easier to interact with while configuring

## [v01.29w] — 2026-03-04 07:13:41 PM EST — v02.72r — [87948be](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/87948be90776ee87394ce7057a2a31d00129f3e3)

### Added
- Test GAS Connection button now opens an overlay showing the live GAS deployment for quick testing

### Changed
- Project configuration is now simpler — file path and embedding URL are automatically determined when you copy the Claude config

### Removed
- Local Config status section removed for a cleaner interface
- File Path and Embedding URL fields removed — these are now handled automatically

## [v01.28w] — 2026-03-04 07:02:02 PM EST — v02.71r — [80b049b](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/80b049ba22831f8cde728805302f57b2a25eb473)

### Changed
- Default project title changed to "CHANGE THIS PROJECT TITLE GAS TEMPLATE"
- Default version changed to "01.00g"
- Default file path changed to "googleAppsScripts/NewGas/newgas1.gs"
- Default embedding URL changed to newgas1.html
- Spreadsheet ID and Sound File ID now pre-filled with real values

## [v01.27w] — 2026-03-04 06:53:55 PM EST — v02.70r — [a448a6c](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/a448a6c5087657a8f18e7c5d3ddd874bc27ce146)

### Removed
- GAS integration panel (iframe preview) removed — page is now a standalone setup tool
- Spreadsheet data display removed
- GAS deploy notification sound removed

### Changed
- Page title updated to "GAS Project Creator"

## [v01.26w] — 2026-03-04 06:32:59 PM EST — v02.68r — [a4e66c1](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/a4e66c10f5f8d0a239ea3a988e2862b842607de1)

### Changed
- Copy Claude Config prompt now creates new projects from the GAS template instead of copying from this page

## [v01.25w] — 2026-03-04 06:19:05 PM EST — v02.67r — [2c53e01](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/2c53e01c0a53065687de1b1a60d4e7dda7c0f388)

### Changed
- Page renamed from GAS Template to GAS Project Creator

## [v01.24w] — 2026-03-04 05:37:43 PM EST — v02.65r — [cf727d1](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/cf727d17fe36ffb234b3460eb1323b923135eebd)

### Changed
- Copy Claude Config prompt now specifies exactly which files to copy from and which docs to update when creating a new project

## [v01.23w] — 2026-03-04 05:31:19 PM EST — v02.64r — [4e8c17d](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/4e8c17dbbf01dab4dcd6ed5e610cc02076c4fcfd)

### Changed
- Copy Claude Config prompt now includes instructions to create the full page ecosystem if the project doesn't exist yet

## [v01.22w] — 2026-03-04 05:27:21 PM EST — v02.63r — [9bbd504](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/9bbd504a481aca00704066255edacf36adbd9849)

### Changed
- "Test GAS Connection" button now appears directly under the Deployment ID field — test your connection immediately after entering the ID
- "Copy Config" renamed to "Copy Claude Config" to clarify it copies a Claude-ready prompt

## [v01.21w] — 2026-03-04 05:17:05 PM EST — v02.62r — [5610216](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/561021642255223923b3807e35284a5d8db4b34c)

### Changed
- Configuration form now requires Deployment ID before enabling Apply, Copy Config, Copy Code.gs, and GAS Preview
- Deployment ID field moved to top of form with "required" label for better visibility
- Copy Config now copies a Claude-ready prompt with JSON directly to clipboard instead of showing an inline output panel
- Copy Code.gs button restyled as full-width action button with disabled state
- Form default values updated to reflect actual template repo paths

## [v01.20w] — 2026-03-04 02:33:28 PM EST — v02.59r — [2b04dbf](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/2b04dbf7277dfc81c7fb61c95b3f993354835fba)

### Fixed
- Setup steps now numbered correctly — group labels no longer consume step numbers

## [v01.19w] — 2026-03-04 02:20:46 PM EST — v02.58r — [51d4fc2](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/51d4fc29987cc6293686753658b387766c18ba35)

### Fixed
- Setup steps now numbered correctly starting from 1 — group labels no longer consume a step number

## [v01.18w] — 2026-03-04 02:11:49 PM EST — v02.57r — [d7db969](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/d7db9698df6ffd9fab08d1adf7e531912b4440f4)

### Added
- Setup steps now grouped with subtle section labels: Google Account Setup, New Apps Script Project, GAS Project Settings, GAS Editor, GAS Triggers

## [v01.17w] — 2026-03-04 01:59:45 PM EST — v02.56r — [98669ee](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/98669eec7cb5146691ef3b7134cef943e3b1154c)

### Changed
- Manifest setup split into two steps: enable the toggle first, set the JSON contents later after GITHUB_TOKEN

## [v01.16w] — 2026-03-04 01:50:56 PM EST — v02.55r — [ce5aee1](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/ce5aee1f81e46d80cbe2b7272e02b175158a4a2f)

### Changed
- Setup steps reordered: API enablement and GCP setup now come before creating the Apps Script project

## [v01.15w] — 2026-03-04 01:39:56 PM EST — v02.54r — [54993a1](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/54993a18a5c9390bcf6ed2e176184cddef392829)

### Changed
- Setup steps reordered for logical flow: set GITHUB_TOKEN first, then Deploy #1, paste Code.gs, authorize OAuth, then Deploy #2 to finalize

## [v01.14w] — 2026-03-04 01:26:42 PM EST — v02.53r — [b03c6bf](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/b03c6bfb0131c6f67e0b43c3f756f1fd76ef5c05)

### Added
- Setup instructions now explain the two-deploy bootstrap: Deploy #1 creates the deployment URL, Deploy #2 activates auto-updates

## [v01.13w] — 2026-03-04 12:31:14 PM EST — v02.47r — [40f587c](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/40f587ca820d5af8c2b2f2832fe68530eafd4955)

### Added
- Input fields for all project configuration variables — you can now edit Version, GitHub Owner, GitHub Repo, GitHub Branch, File Path, Embedding URL, and Splash Logo URL before copying Code.gs
- All fields prefilled with current defaults and remembered between visits

## [v01.12w] — 2026-03-04 12:22:18 PM EST — v02.46r — [2cbba90](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/2cbba90f9ee9d681af15efffd17bd040dad7821c)

### Added
- Interactive embedded Google Sheets preview in the GAS web app — view and edit the connected spreadsheet directly without leaving the page

### Changed
- Setup steps reordered so entering project variables (Title, Deployment ID, Spreadsheet ID, Sheet Name, Sound File ID) and copying the code is the last step — complete all infrastructure setup first, then fill in config values when you have all the information

## [v01.11w] — 2026-03-04 10:09:15 AM EST — v02.33r — [9627745](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/9627745b1c58c623c6494fe50c0d4a0a03fbe98f)

### Changed
- "Copy Code.gs" now produces a fully configured script — Spreadsheet ID, Sheet Name, Sound File ID, Title, and Deployment ID from the form fields are injected into the code before copying
- Spreadsheet ID, Sheet Name, and Sound File ID fields moved to Step 1 (before the Copy button) so configuration is ready before you copy

## [v01.10w] — 2026-03-04 09:47:03 AM EST — v02.32r — [b911cd5](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/b911cd55a55c503a0ff0fa550ae59fa7a3df7ca5)

### Added
- Collapsible troubleshooting guide under "Link the GCP project" setup step — explains the "Apps Script-managed folder" error and how to fix it (grant Project Mover role, migrate project, or create a new one)

## [v01.09w] — 2026-03-04 08:52:09 AM EST — v02.28r — [f8a10b5](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/f8a10b5e5a77cff8cb925abe5c48262543d8bd18)

### Added
- New "Spreadsheet Data" dashboard section showing live cell values from the connected Google Sheet
- Live B1 value display with automatic 15-second polling updates
- "Open Spreadsheet" link for quick access to the connected sheet

## [v01.08w] — 2026-03-04 08:29:56 AM EST — v02.26r — [98cc8f8](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/98cc8f882d1462c28290c0a2b2b733524c4b3195)

### Fixed
- GAS toggle tab moved to bottom-left to avoid overlapping the version/changelog button

## [v01.07w] — 2026-03-04 08:25:01 AM EST — v02.25r — [6cd71e0](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/6cd71e0bb1bc1449ccd4f0591a584bd8171f4624)

### Fixed
- Spreadsheet and Sound File status now shows "Local only — update GAS script" when values are saved locally but not yet configured in the GAS script, instead of "Not set"

## [v01.06w] — 2026-03-04 08:15:33 AM EST — v02.24r — [bb27f99](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/bb27f9987b9297930436bbe6817beb9b18504bf1)

### Added
- "Local Config" dashboard section showing saved Deployment ID, Spreadsheet ID, Sheet Name, and Sound File ID with status indicators
- Per-field clear buttons (×) next to every configuration input for individually removing saved values
- Collapsible bottom panel for GAS iframe with toggle tab and drag-to-resize handle

### Changed
- GAS iframe opens in a resizable bottom drawer instead of covering the entire page — dashboard stays interactive during testing

## [v01.05w] — 2026-03-04 07:50:45 AM EST — v02.23r — [e8338dc](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/e8338dc63d5ea2e405ae3819a48892f8954d58be)

### Added
- "Copy Code.gs" button at step 1 — one-click copy of the full GAS source code to paste into the Apps Script editor

## [v01.04w] — 2026-03-03 10:42:39 PM EST — v02.22r — [3db1165](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/3db116552ef2006b8f79c3570058bfffff31eba2)

### Changed
- Copy button on the JSON manifest block for one-click clipboard copy
- GCP Console link added for users who need to set up a new project
- Detailed GITHUB_TOKEN creation walkthrough and note that the same token works across all your GAS projects

## [v01.03w] — 2026-03-03 10:27:04 PM EST — v02.21r — [0514119](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/0514119ef2af35c5eb2de0a2414419942b2d76a4)

### Changed
- Setup instructions now appear as the main section with configuration inputs embedded inline at the relevant steps instead of a separate collapsible panel
- Section renamed from "Configuration" to "Setup & Configuration"

## [v01.02w] — 2026-03-03 10:19:44 PM EST — v02.20r — [bca5041](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/bca50413c1887780bee193e567b8fb071562e5bf)

### Added
- Collapsible "GAS Setup Instructions" section — 12-step guide covering Apps Script project creation, manifest configuration, GCP linking, deployment, token setup, and optional spreadsheet integration

## [v01.01w] — 2026-03-03 09:53:51 PM EST — v02.18r — [1f741cd](https://github.com/ShadowAISolutions/htmltemplateautoupdate/commit/1f741cdff3b14236487666fd7554591fd78d0850)

### Added
- Interactive configuration form — input GAS project variables (Title, Deployment ID, Spreadsheet ID, Sheet Name, Sound File ID) directly on the status page
- Apply button saves settings to browser storage for instant GAS iframe testing without editing repo files
- Copy Config button generates exportable config.json content for easy transfer to the repository
- Clear button removes saved settings and resets the dashboard to default state
- Previously saved settings automatically restore on page load

Developed by: ShadowAISolutions
