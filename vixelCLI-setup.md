# Set up Vixel CLI and Skill

This is Vixel's public client distribution, not the platform or an OAuth issuer.
Stable entry: https://cli.vixelai.com/vixelCLI-setup.md
Read https://cli.vixelai.com/current.json for the current release. This guide
is pinned to 0.5.5. If the manifest recommends another version, reload
both documents before installing; do not combine different releases.
Installers and archives remain on the versioned GitHub Release.

## Check your environment

Use a coding agent with terminal, local filesystem and network access. If these
tools are unavailable, explain that CLI setup needs a coding-agent task; do not
simulate installation. A chat-only client can use its supported remote MCP
connector instead. Local video export additionally requires FFmpeg and FFprobe.

## Choose the platform

Use the platform origin explicitly requested by the user. If none was given,
use https://drama.vixelai.com. Keep a local request such as
http://localhost:5000 unchanged. Never use github.com or raw.githubusercontent.com
or cli.vixelai.com as the platform origin. The CLI domain hosts public setup
files only; send OAuth and API requests to the selected Vixel platform. Downloading/installing does not authorize paid generation,
account creation, payments, publishing or any other platform writes.

## Install and read the Skill

On macOS/Linux, download the release's install.sh, read it, and run it with both
origins. Replace PLATFORM_ORIGIN below with the selected platform:

```sh
curl -fsSL 'https://github.com/Vixel-AI/vixel-cli/releases/download/v0.5.5/install.sh' -o vixel-install.sh
sh vixel-install.sh --base-url 'PLATFORM_ORIGIN' --download-base-url 'https://github.com/Vixel-AI/vixel-cli/releases/download/v0.5.5' --prefix "$PWD/.vixel-client"
export VIXEL_CONFIG="$PWD/.vixel-session/session.json"
./.vixel-client/bin/vixel setup --directory "$PWD" --base-url 'PLATFORM_ORIGIN' --no-browser
```

Windows x64: download/read install.ps1 from the same release, run it with
-BaseUrl PLATFORM_ORIGIN -DownloadBaseUrl 'https://github.com/Vixel-AI/vixel-cli/releases/download/v0.5.5' -Prefix "$PWD\.vixel-client",
set VIXEL_CONFIG to this task's new session.json path, then use
.vixel-client\bin\vixel.exe for setup and other commands. Do not bypass OS
security or execution policies. Windows ARM64 is not provided.

No Node, npm, Python or Bun installation is needed. The installer verifies the
archive checksum before extraction. Never import another task's credentials.
Do not change HOME or CODEX_HOME. Use --no-login if only installing for now.
Read the installed .agents/skills/vixel-platform/SKILL.md and its README.
Use the actual executable path throughout; installation does not modify PATH.
Different existing binaries/Skill files are preserved for explicit review.

## Browser login and visible results

Keep the one OAuth callback process alive. Open its exact URL in Codex's right
browser panel, reuse that tab and verify it loaded. Follow the available host
browser tools. If the request is queued, report queued, not visible success.
The user may need to enter a password, MFA or consent in the browser.
After login, run doctor and inspect data.ready and each check; then follow the
installed Skill's operation-to-surface mapping. Navigate the same tab to the
requested Work, refresh after CLI writes/canonical readback and terminal Jobs,
restore the target selection and inspect actual results. Preserve unsaved drafts.
Leave the verified result visible at delivery. Absent/denied browser tools must
be reported; never bypass a denial or claim unobserved UI success.

All platform operations use the selected platform, not the download host.
Use CLI help, capabilities and docs for available contracts. Connecting is not
permission to generate, spend or publish. Preserve quote limits, revision guards,
request keys and same-Job recovery. Do not repeat writes to refresh stale UI.
For chat-only clients use their supported MCP setup at PLATFORM_ORIGIN/api/mcp;
a pasted URL alone cannot install a connector or grant tool permissions.

## Release scope

This is an Alpha client distribution. Only macOS ARM64 installation has been
executed in the release environment; other binaries are cross-compiled and need
target-host verification. A downloadable client does not prove the selected
platform has deployed every API or that a complete media workflow passes.
`vixel docs --topic workflow` is a historical rehearsal, not current evidence.
