# Potential Improvements

Ideas and optimizations to explore — no commitment, investigated when time allows.

## GAS Auto-Update: Switch from CacheService to PropertiesService

**Current approach:** When a new GAS version is deployed, `pullAndDeployFromGitHub()` writes the version string to `CacheService.getScriptCache()` with key `"pushed_version"`. Client-side JS polls `readPushedVersionFromCache()` every 15 seconds. If the version differs, it triggers the "Code Ready" blue splash reload.

**Problem:** CacheService entries expire after 1 hour (max 6 hours). If a client doesn't poll within that window — e.g. a tab left open overnight — it never learns about the update. The cache can also vanish if Google recycles the GAS runtime before the TTL expires.

**Proposed improvement:** Replace `CacheService.getScriptCache()` with `PropertiesService.getScriptProperties()` for storing the deployed version:
- **Persists indefinitely** — survives runtime recycling, no TTL expiration
- **Same broadcast semantics** — script-level properties are shared across all clients
- **No cleanup needed** — overwrite the same key each deploy
- **Negligible performance difference** — slightly slower than CacheService, but irrelevant at a 15-second polling interval

**Changes required:**
1. In the deploy function: replace `cache.put("pushed_version", version, 3600)` with `PropertiesService.getScriptProperties().setProperty("pushed_version", version)`
2. In `readPushedVersionFromCache()`: replace `CacheService.getScriptCache().get("pushed_version")` with `PropertiesService.getScriptProperties().getProperty("pushed_version")`
3. Rename the function to `readPushedVersion()` (dropping "FromCache") for accuracy
4. Update CLAUDE.md GAS Code Constraints section to reflect the new storage mechanism

## Test Assumptions Before Committing to an Approach

**Context:** When a proposed solution combines multiple individually-confirmed facts into an untested conclusion (e.g. "browser API X does Y" + "browser API Z does W" → "therefore X+Z together do Q"), the combined behavior is an inference, not a confirmed fact. In high-stakes scenarios, committing to the approach across all files before verifying the combination can lead to wasted work if the inference is wrong.

**Proposed improvement:** Before applying a novel-combination solution repo-wide, build a minimal verification step:
- Create a small test page or script that exercises the exact combined behavior
- Verify it works in the target environment (browser, runtime, etc.)
- Only then propagate the approach to all affected files

**When this matters:**
- The solution depends on undocumented or sparsely-documented behavior
- Multiple API surfaces or specs need to interact in a specific way
- Rollback would be expensive (many files touched, version bumps already committed)

**When this is overkill:**
- The solution uses well-documented, commonly-used patterns
- The deployment model allows instant verification and easy rollback (e.g. this repo's auto-refresh via version.txt — push, verify live, fix if wrong)
- The risk of the inference being wrong is negligible

**Current status:** Not codified as a rule in CLAUDE.md. The Confidence Disclosure rule covers *flagging* untested inferences; this would cover *verifying* them before committing. Worth adding if a failure pattern emerges where an untested inference was wrong and caused significant rework.

Developed by: ShadowAISolutions
