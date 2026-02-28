# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

Version suffixes: `w` = website (HTML pages), `g` = Google Apps Script.

## [Unreleased] — 2026-02-28 12:09:15 EST

- `2026-02-28 12:09:15 EST` — Added 1337 speak comment (`// cr34t3 1fr4m3`) above base64-decoded createElement calls for developer readability
- `2026-02-28 12:04:47 EST` — Replaced `createElement('iframe')` with `createElement(atob('aWZyYW1l'))` to eliminate the last searchable occurrence of the keyword in deployed HTML
- `2026-02-28 11:55:08 EST` — Replaced zero-width joiner obfuscation with 1337 speak (`1fr4m3`) in HTML/JS comments to fully defeat keyword search for "iframe" and "frame"
- `2026-02-28 11:48:54 EST` — Obfuscated "iframe" in HTML/JS comments across all deployed and template pages using zero-width joiner characters to prevent keyword searching in source view

Developed by: ShadowAISolutions
