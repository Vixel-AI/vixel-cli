# Vixel CLI release notes

## 0.5.7 · Alpha · 2026-10-03

### Browser login recovery

- Wait up to 15 minutes for browser approval, starting after the login link is
  ready. Use `--login-timeout SECONDS` for a bounded 1–1800 second wait.
- Print progress while waiting so coding agents retain the running terminal
  session instead of stopping it after opening the browser.
- Stop the approval timer when the callback arrives. Token exchange and account
  verification still have to succeed before login is reported as complete.
- Handle timeout and interruption with recovery guidance and preserve the
  previous saved login on failure.
- Explain same-computer callbacks and the difference between CLI and native
  MCP-host login. Refreshing an old callback is not a new login attempt.

### Getting started

The README now leads with setup and example prompts. The branded setup guide
includes an upgrade path that preserves session configuration and custom Skill
files. Installers and binaries are pinned to this release with SHA-256 hashes.

### Verification and limits

The CLI suite includes actual process timeout/SIGINT/SIGTERM and fresh retry.
macOS ARM64 installation, upgrade preservation, bundled Skill setup, offline
docs, corrupt-download rejection and isolated OAuth recovery were exercised.
The other four targets are cross-compiled, not executed on their target hosts.
Fixture acceptance is not a real identity-provider or end-to-end media test.

A killed process or a browser on another computer can still leave an unreachable
old callback. Check connection status and start a fresh login only when needed.
This client release does not change native MCP-host authentication or approve
any generation, account write, purchase or publication.

## 0.5.5 · Alpha · 2026-09-29

Standalone executables include the platform Skill and public docs; no Node.js
installation required. Installers support a separate download base URL with
checksum verification; platform login stays on the selected Vixel origin.

Verified at that release: macOS ARM64 install/reinstall, Skill setup, offline
docs, tampered archive rejection, separate artifact host/redirects, CLI tests
and isolated OAuth fixture. Other targets were cross-compiled only. These
checks did not prove real Google authorization, production API deployment or
an end-to-end media workflow. No provider credentials or application/server
source were included. Versioned downloads remain available.
