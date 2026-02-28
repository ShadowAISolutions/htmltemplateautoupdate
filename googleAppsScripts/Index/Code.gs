// =============================================
// SELF-UPDATING GOOGLE APPS SCRIPT FROM GITHUB
// =============================================
//
// WHAT THIS IS
// ------------
// A Google Apps Script web app that pulls its own source code from
// a GitHub repository and redeploys itself. GitHub is the source of
// truth — this file (Code.gs) is the ONLY file you need to edit.
//
// There are TWO ways updates reach the live web app:
//   1. AUTOMATIC: Push to a claude/* branch → GitHub Action merges to
//      main → calls doPost(action=deploy) → GAS pulls + deploys itself
//   2. MANUAL: Click "Pull Latest" in the web app UI
//
// PAGE RELOAD (EMBEDDING SOLUTION)
// ---------------------------------
// The GAS sandbox iframe blocks programmatic navigation from async
// callbacks. Solution: embed the web app as a full-screen iframe on
// a GitHub Pages page. After deploy, the GAS client sends:
//   window.top.postMessage({type:'gas-reload', version: ...}, '*')
// The embedding page catches this and reloads itself.
//
// ARCHITECTURE — DYNAMIC LOADER PATTERN
// ---------------------------------------
// - doGet() serves a STATIC HTML shell (never changes)
// - All visible content is fetched at runtime via getAppData()
// - getAppData() returns {version, title} → applyData() updates DOM
// - After a pull, getAppData() runs on the NEW server code
// - This bypasses Google's aggressive server-side HTML caching
//
// AUTO-DEPLOY FLOW (push → live in ~30 seconds)
// -----------------------------------------------
//   1. Claude Code pushes to claude/* branch
//   2. GitHub Action merges to main
//   3. GitHub Action calls doPost(action=deploy)
//   4. doPost() calls pullAndDeployFromGitHub() directly
//   5. GAS pulls new code from GitHub, overwrites project, deploys
//   6. postMessage tells the embedding page to reload
//   7. App shows new version — zero manual clicks
//
// FALLBACK: If doPost deploy fails or is unavailable, the client-side
// auto-pull on page load will catch up on the next page visit.
//
// VERSION LIMIT MANAGEMENT (200 VERSION CAP)
// --------------------------------------------
// Apps Script has a hard 200 version limit. The API does NOT support
// deleting versions. When 180+ is reached, a warning appears.
// Manually clean up: Apps Script editor → Project History → Bulk delete
//
// SETUP STEPS
// -----------
// 1. Create an Apps Script project, paste this code
// 2. Enable "Show appsscript.json" in Project Settings, set contents:
//    {
//      "timeZone": "America/New_York",
//      "runtimeVersion": "V8",
//      "dependencies": {},
//      "webapp": {
//        "executeAs": "USER_DEPLOYING",
//        "access": "ANYONE_ANONYMOUS"
//      },
//      "exceptionLogging": "STACKDRIVER",
//      "oauthScopes": [
//        "https://www.googleapis.com/auth/script.projects",
//        "https://www.googleapis.com/auth/script.external_request",
//        "https://www.googleapis.com/auth/script.deployments",
//        "https://www.googleapis.com/auth/spreadsheets",
//        "https://www.googleapis.com/auth/script.send_mail"
//      ]
//    }
// 3. Create or use a GCP project where you have Owner access
// 4. Enable Apps Script API in GCP project (APIs & Services → Library)
// 5. Link GCP project in Apps Script (Project Settings → Change project)
// 6. Enable Apps Script API at script.google.com/home/usersettings
// 7. Deploy as Web app (Deploy → New deployment → Web app → Anyone)
// 8. Copy Deployment ID into DEPLOYMENT_ID below
// 9. Set GITHUB_TOKEN in Script Properties:
//      Key: GITHUB_TOKEN   Value: github_pat_... token
//      (fine-grained token with "Public repositories" read-only access)
// 10. Run any function from editor to trigger OAuth authorization
// 11. If using Google Sheets: create spreadsheet, copy ID into SPREADSHEET_ID
// 12. If using installable trigger for sheet caching:
//      Apps Script editor → Triggers → + Add Trigger →
//      Function: onEditWriteB1ToCache, Event source: From spreadsheet,
//      Event type: On edit
//
// IMPORTANT — AUTO-INCREMENT VERSION ON EVERY COMMIT:
//   Whenever Claude Code edits this file, it MUST increment VERSION
//   by 0.01 (e.g. "01.00g" → "01.01g"). No commit should leave
//   VERSION unchanged.
//
// IMPORTANT — KEEP THIS OVERVIEW UP TO DATE:
//   Whenever you make structural changes (new functions, new integrations,
//   new config variables), update the relevant section of this overview
//   IN THE SAME COMMIT.
//
// =============================================

// ── PROJECT CONFIG ────────────────────────────────────────────────
// Fill in these values after creating your GAS deployment.
// See SETUP STEPS above for how to obtain each value.

var VERSION = "01.00g";
var TITLE = "CHANGE THIS PROJECT TITLE TEMPLATE";

// GitHub config — where to pull code from
var GITHUB_OWNER  = "ShadowAISolutions";
var GITHUB_REPO   = "htmltemplateautoupdate";
var GITHUB_BRANCH = "main";
var FILE_PATH     = "googleAppsScripts/Index/Code.gs";

// Apps Script deployment ID (from Deploy → Manage deployments)
// This is the long AKfycb... string, NOT the web app URL
var DEPLOYMENT_ID = "YOUR_DEPLOYMENT_ID";

// Google Sheets config (optional — for version tracking in a linked sheet)
var SPREADSHEET_ID = "YOUR_SPREADSHEET_ID";
var SHEET_NAME     = "Live_Sheet";

// Sound config (Google Drive file ID for notification sound)
var SOUND_FILE_ID = "1bzVp6wpTHdJ4BRX8gbtDN73soWpmq1kN";

// Embedding page URL — the GitHub Pages page that iframes this GAS app
// Used for the "Reload Page" button (form target="_top" navigates here)
var EMBED_PAGE_URL = "https://ShadowAISolutions.github.io/htmltemplateautoupdate/";

// Logo shown on the splash screen
var SPLASH_LOGO_URL = "https://www.shadowaisolutions.com/SAIS%20Logo.png";
// ──────────────────────────────────────────────────────────────────

function doGet() {
  var html = `
    <html>
    <head>
      <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
      <meta http-equiv="Pragma" content="no-cache">
      <meta http-equiv="Expires" content="0">
      <style>
        html, body { height: 100%; margin: 0; overflow: auto; }
        body { font-family: Arial; display: flex; flex-direction: column; align-items: center; padding: 20px 0; box-sizing: border-box; }
        #splash { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: #0d47a1; z-index: 9999; transition: opacity 0.3s ease; display: flex; align-items: center; justify-content: center; }
        #splash img { max-width: 500px; max-height: 500px; }
        #version { font-size: 80px; font-weight: bold; color: #e65100; line-height: 1; }
        button { background: #e65100; color: white; border: none; padding: 8px 20px;
                 border-radius: 6px; cursor: pointer; font-size: 14px; margin-top: 10px; }
        button:hover { background: #bf360c; }
        #result { margin-top: 8px; padding: 8px 15px; border-radius: 8px; font-size: 13px; }
        #versionCount { margin-top: 6px; font-size: 12px; color: #888; }
      </style>
    </head>
    <body>
      <div id="splash"><img src="${SPLASH_LOGO_URL}" alt=""></div>
      <h1 id="title" style="font-size: 28px; margin: 0 0 4px 0;">...</h1>
      <div id="version">...</div>
      <button onclick="checkForUpdates()">🔄 Pull Latest from GitHub</button>
      <form id="redirect-form" method="GET" action="${EMBED_PAGE_URL}" target="_top" style="display:inline;">
        <button id="reload-btn" type="submit" style="background:#2e7d32;color:white;border:none;padding:8px 20px;border-radius:6px;cursor:pointer;font-size:14px;margin-top:10px;">🔄 Reload Page</button>
      </form>
      <div id="result"></div>
      <div id="versionCount"></div>

      <script>
        // Pre-load Drive sound from server on page load (if configured)
        var _soundDataUrl = null;
        google.script.run
          .withSuccessHandler(function(dataUrl) { _soundDataUrl = dataUrl; })
          .withFailureHandler(function() {})
          .getSoundBase64();

        function playBeep() {
          try {
            var ctx = new (window.AudioContext || window.webkitAudioContext)();
            var osc = ctx.createOscillator();
            var gain = ctx.createGain();
            osc.connect(gain);
            gain.connect(ctx.destination);
            osc.frequency.value = 880;
            gain.gain.value = 0.3;
            osc.start();
            osc.stop(ctx.currentTime + 0.15);
          } catch(e) {}
        }

        function applyData(data) {
          for (var key in data) {
            var el = document.getElementById(key);
            if (el) {
              el.textContent = data[key];
              if (key === 'versionCount' && data[key].indexOf('LIMIT') !== -1) {
                el.style.color = '#d32f2f';
                el.style.fontWeight = 'bold';
              }
            }
          }
        }

        // Load initial data
        google.script.run
          .withSuccessHandler(function(data) { applyData(data); })
          .getAppData();

        // Poll for new pushed version every 15s (set by doPost via GitHub Action)
        var _autoPulling = false;
        function pollPushedVersionFromCache() {
          if (_autoPulling) return;
          google.script.run
            .withSuccessHandler(function(pushed) {
              if (!pushed) return;
              var current = (document.getElementById('version').textContent || '').trim();
              if (pushed !== current && pushed !== '') {
                _autoPulling = true;
                checkForUpdates();
                setTimeout(function() { _autoPulling = false; }, 30000);
              }
            })
            .readPushedVersionFromCache();
        }
        setInterval(pollPushedVersionFromCache, 15000);

        // Auto-pull from GitHub on every page load
        checkForUpdates();

        // Splash screen — fade out after 1 second
        setTimeout(function() {
          var splash = document.getElementById('splash');
          splash.style.opacity = '0';
          setTimeout(function() { splash.style.display = 'none'; }, 300);
        }, 1000);

        function checkForUpdates() {
          document.getElementById('result').style.background = '#fff3e0';
          document.getElementById('result').innerHTML = '⏳ Pulling...';
          google.script.run
            .withSuccessHandler(function(msg) {
              var wasUpdated = msg.indexOf('Updated to') === 0;
              document.getElementById('result').style.background = '#e8f5e9';
              document.getElementById('result').innerHTML = '✅ ' + msg;
              if (!wasUpdated) {
                setTimeout(function() { document.getElementById('result').innerHTML = ''; }, 2000);
                return;
              }
              // New version deployed — update dynamic content
              setTimeout(function() {
                google.script.run.writeVersionToSheet();
                google.script.run
                  .withSuccessHandler(function(data) {
                    applyData(data);
                    // Highlight reload button
                    var btn = document.getElementById('reload-btn');
                    btn.style.background = '#d32f2f';
                    btn.textContent = '⚠️ Update Available — Reload Page';
                    // Tell embedding page to reload
                    var reloadMsg = {type: 'gas-reload', version: data.version};
                    if (_soundDataUrl) reloadMsg.soundDataUrl = _soundDataUrl;
                    try { window.top.postMessage(reloadMsg, '*'); } catch(e) {}
                    try { window.parent.postMessage(reloadMsg, '*'); } catch(e) {}
                  })
                  .getAppData();
              }, 2000);
            })
            .withFailureHandler(function(err) {
              document.getElementById('result').style.background = '#ffebee';
              document.getElementById('result').innerHTML = '❌ ' + err.message;
            })
            .pullAndDeployFromGitHub();
        }
      </script>
    </body>
    </html>
  `;
  return HtmlService.createHtmlOutput(html)
    .setTitle(TITLE)
    .setXFrameOptionsMode(HtmlService.XFrameOptionsMode.ALLOWALL);
}

// POST endpoint — called by GitHub Action after merging to main.
// Supports two actions:
//   action=deploy        → directly pull + deploy from GitHub (primary)
//   action=writeC1       → write version to sheet C1 + set cache flag
function doPost(e) {
  var action = (e && e.parameter && e.parameter.action) || "";

  if (action === "deploy") {
    var result = pullAndDeployFromGitHub();
    return ContentService.createTextOutput(result);
  }

  if (action === "writeC1") {
    var value = (e.parameter.value) || "";
    if (SPREADSHEET_ID && SPREADSHEET_ID !== "YOUR_SPREADSHEET_ID") {
      try {
        var ss = SpreadsheetApp.openById(SPREADSHEET_ID);
        var sheet = ss.getSheetByName(SHEET_NAME);
        if (!sheet) sheet = ss.insertSheet(SHEET_NAME);
        sheet.getRange("C1").setValue(value + " — " + new Date().toLocaleString());
      } catch(e) {}
    }
    CacheService.getScriptCache().put("pushed_version", value, 3600);
    return ContentService.createTextOutput("OK");
  }

  return ContentService.createTextOutput("Unknown action");
}

function getAppData() {
  var data = { version: "v" + VERSION, title: TITLE };

  // Version count with caching
  var cache = CacheService.getScriptCache();
  var vStatus = cache.get("version_count_status");
  if (!vStatus) {
    try {
      var scriptId = ScriptApp.getScriptId();
      var totalVersions = 0;
      var vPageToken = null;
      do {
        var vListUrl = "https://script.googleapis.com/v1/projects/" + scriptId + "/versions"
          + (vPageToken ? "?pageToken=" + vPageToken : "");
        var vListResp = UrlFetchApp.fetch(vListUrl, {
          headers: { "Authorization": "Bearer " + ScriptApp.getOAuthToken() }
        });
        var vListData = JSON.parse(vListResp.getContentText());
        if (vListData.versions) totalVersions += vListData.versions.length;
        vPageToken = vListData.nextPageToken || null;
      } while (vPageToken);
      vStatus = totalVersions + "/200 versions";
      if (totalVersions >= 180) vStatus += " — APPROACHING LIMIT!";
      cache.put("version_count_status", vStatus, 21600);
    } catch(e) {
      vStatus = "Unable to check version count";
    }
  }
  data.versionCount = vStatus;
  return data;
}

function getSoundBase64() {
  if (!SOUND_FILE_ID || SOUND_FILE_ID === "") return null;
  var url = "https://drive.google.com/uc?export=download&id=" + SOUND_FILE_ID;
  var response = UrlFetchApp.fetch(url, { followRedirects: true });
  var blob = response.getBlob();
  var base64 = Utilities.base64Encode(blob.getBytes());
  var contentType = blob.getContentType() || "audio/mpeg";
  return "data:" + contentType + ";base64," + base64;
}

function readPushedVersionFromCache() {
  return CacheService.getScriptCache().get("pushed_version") || "";
}

function writeVersionToSheet() {
  if (!SPREADSHEET_ID || SPREADSHEET_ID === "YOUR_SPREADSHEET_ID") return;
  try {
    var ss = SpreadsheetApp.openById(SPREADSHEET_ID);
    var sheet = ss.getSheetByName(SHEET_NAME);
    if (!sheet) sheet = ss.insertSheet(SHEET_NAME);
    sheet.getRange("A1").setValue("v" + VERSION + " — " + new Date().toLocaleString());
  } catch(e) {}
}

function pullAndDeployFromGitHub() {
  var GITHUB_TOKEN = PropertiesService.getScriptProperties().getProperty("GITHUB_TOKEN");

  var apiUrl = "https://api.github.com/repos/"
    + GITHUB_OWNER + "/" + GITHUB_REPO + "/contents/" + FILE_PATH
    + "?ref=" + GITHUB_BRANCH + "&t=" + new Date().getTime();

  var fetchHeaders = { "Accept": "application/vnd.github.v3.raw" };
  if (GITHUB_TOKEN) {
    fetchHeaders["Authorization"] = "token " + GITHUB_TOKEN;
  }

  var response = UrlFetchApp.fetch(apiUrl, { headers: fetchHeaders });
  var newCode = response.getContentText();

  // Extract VERSION from the pulled code
  var versionMatch = newCode.match(/var VERSION\s*=\s*"([^"]+)"/);
  var pulledVersion = versionMatch ? versionMatch[1] : null;

  // Skip deployment if already up to date
  if (pulledVersion && pulledVersion === VERSION) {
    return "Already up to date (v" + VERSION + ")";
  }

  var scriptId = ScriptApp.getScriptId();
  var url = "https://script.googleapis.com/v1/projects/" + scriptId + "/content";
  var current = UrlFetchApp.fetch(url, {
    headers: { "Authorization": "Bearer " + ScriptApp.getOAuthToken() }
  });
  var currentFiles = JSON.parse(current.getContentText()).files;
  var manifest = currentFiles.find(function(f) { return f.name === "appsscript"; });

  var payload = {
    files: [
      { name: "Code", type: "SERVER_JS", source: newCode },
      manifest
    ]
  };

  UrlFetchApp.fetch(url, {
    method: "put",
    contentType: "application/json",
    headers: { "Authorization": "Bearer " + ScriptApp.getOAuthToken() },
    payload: JSON.stringify(payload)
  });

  var versionUrl = "https://script.googleapis.com/v1/projects/" + scriptId + "/versions";
  var versionResponse = UrlFetchApp.fetch(versionUrl, {
    method: "post",
    contentType: "application/json",
    headers: { "Authorization": "Bearer " + ScriptApp.getOAuthToken() },
    payload: JSON.stringify({ description: "v" + pulledVersion + " — from GitHub " + new Date().toLocaleString() })
  });
  var newVersion = JSON.parse(versionResponse.getContentText()).versionNumber;

  var deployUrl = "https://script.googleapis.com/v1/projects/" + scriptId
    + "/deployments/" + DEPLOYMENT_ID;
  UrlFetchApp.fetch(deployUrl, {
    method: "put",
    contentType: "application/json",
    headers: { "Authorization": "Bearer " + ScriptApp.getOAuthToken() },
    payload: JSON.stringify({
      deploymentConfig: {
        scriptId: scriptId,
        versionNumber: newVersion,
        description: "v" + pulledVersion + " (deployment " + newVersion + ")"
      }
    })
  });

  // Update version count cache
  var cleanupInfo = "";
  try {
    var totalVersions = 0;
    var vPageToken = null;
    do {
      var vListUrl = "https://script.googleapis.com/v1/projects/" + scriptId + "/versions"
        + (vPageToken ? "?pageToken=" + vPageToken : "");
      var vListResp = UrlFetchApp.fetch(vListUrl, {
        headers: { "Authorization": "Bearer " + ScriptApp.getOAuthToken() }
      });
      var vListData = JSON.parse(vListResp.getContentText());
      if (vListData.versions) totalVersions += vListData.versions.length;
      vPageToken = vListData.nextPageToken || null;
    } while (vPageToken);
    cleanupInfo = " | " + totalVersions + "/200 versions";
    var versionStatus = totalVersions + "/200 versions";
    if (totalVersions >= 180) versionStatus += " — APPROACHING LIMIT!";
    CacheService.getScriptCache().put("version_count_status", versionStatus, 21600);
  } catch(cleanupErr) {
    cleanupInfo = " | Version count error: " + cleanupErr.message;
  }

  // Set pushed_version cache flag for client-side polling
  CacheService.getScriptCache().put("pushed_version", "v" + pulledVersion, 3600);

  return "Updated to v" + pulledVersion + " (deployment " + newVersion + ")" + cleanupInfo;
}
// Developed by: ShadowAISolutions
