# Vixel CLI

Create with Vixel from your AI agent. Standalone client **0.5.5 (Alpha)**,
with the platform Skill and public documentation included. No Node.js required.

**Give your agent this URL:**
https://raw.githubusercontent.com/Vixel-AI/vixel-cli/main/agent.md

Default platform: https://drama.vixelai.com. For local testing, tell your agent
to use **http://localhost:5000**. Downloads and platform authentication are
separate. This repository does not contain Vixel's application/server source.

- [Download 0.5.5](https://github.com/Vixel-AI/vixel-cli/releases/tag/v0.5.5)
- [Agent setup](agent.md)
- [CLI reference](CLI.md)
- [Platform Skill](skills/vixel-platform/SKILL.md)
- [Current release and hashes](current.json)
- [Platform connection page](https://drama.vixelai.com/creator/mcp)

| Build | Validation |
| --- | --- |
| darwin-arm64 | Installation executed on release host |
| darwin-x64 | Cross-compiled; not executed on target host |
| linux-arm64 | Cross-compiled; not executed on target host |
| linux-x64 | Cross-compiled; not executed on target host |
| windows-x64 | Cross-compiled; not executed on target host |

The installer verifies SHA-256 and preserves different existing files. Versioned
assets are retained; this repository's current.json selects the recommended
Alpha. Hashes identify the release bytes; they are not OS signing/notarization.

The client uses Vixel's browser OAuth and server-side identity, wallet, Jobs and
canonical Work operations. Availability depends on the selected platform.
Social publishing/analytics adapters are not shipped. Local exports additionally
need FFmpeg/FFprobe. No paid generation is authorized merely by installation.
