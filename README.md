# Vixel CLI

![Vixel — Make films with your AI agent. Original brand illustration of a lighthouse keeper returning a lost star to the sky.](assets/vixel-hero.png)

Develop stories, characters and shot videos with Codex or another coding agent.
Review your project and media in Vixel, and continue with Director.

[Get started](#get-started) · [Watch a film](#made-with-vixel) · [Try a prompt](#try-a-prompt) · [CLI reference](CLI.md) · [Download 0.5.7](https://github.com/Vixel-AI/vixel-cli/releases/tag/v0.5.7)

## Get started

Open a working folder in your coding agent and paste:

```text
Set up Vixel using https://cli.vixelai.com/vixelCLI-setup.md
```

Your agent downloads the matching executable, installs the Vixel Skill, and
opens browser login. Sign in to your Vixel account, then return to the agent.
**Keep the terminal session running while you sign in.**

No source checkout, Node.js, npm, Python or Bun is required. You need an agent
with terminal, file and network access. Browser login requires the CLI and
browser to run on the same computer. For a remote or chat-only environment,
see [MCP connections](https://drama.vixelai.com/creator/mcp).

## Made with Vixel

**Why Is the Ocean Blue?** · A 40-second animated film by the Vixel team.

<table>
  <tr>
    <td width="33%"><a href="https://www.vixelai.com/case-studies/why-is-the-ocean-blue"><img src="https://www.vixelai.com/case-studies/why-is-the-ocean-blue/scene-1.jpg" alt="A curious blue water drop holds a glass beside the ocean." width="280"></a></td>
    <td width="33%"><a href="https://www.vixelai.com/case-studies/why-is-the-ocean-blue"><img src="https://www.vixelai.com/case-studies/why-is-the-ocean-blue/scene-2.jpg" alt="A smiling sun and colorful characters gather on the beach." width="280"></a></td>
    <td width="33%"><a href="https://www.vixelai.com/case-studies/why-is-the-ocean-blue"><img src="https://www.vixelai.com/case-studies/why-is-the-ocean-blue/scene-3.jpg" alt="Two water-drop characters share a moment by the sea." width="280"></a></td>
  </tr>
</table>

Frames from the finished film. [Watch the film →](https://www.vixelai.com/case-studies/why-is-the-ocean-blue)

## Try a prompt

**Start a short film**

```text
Use Vixel to develop a 30-second animated film about a tiny lighthouse keeper
who helps a lost star get home. Show me the screenplay before making images.
```

**Explore a character**

```text
Help me design a retired detective who runs a flower shop. Prepare a character
portrait in Vixel and show me the prompt and credit estimate before generating.
```

**Continue an existing project**

```text
Open my Vixel project and review the storyboard with me. Keep the characters
and accepted images. Suggest a stronger opening before we create shot videos.
```

These are starting prompts, not pre-generated examples. Your agent checks the
connected platform's available operations and asks for any required approval.

## From an idea to a film

```text
Script → Characters & shots → First looks → Storyboard → Video → Cut & export
```

- **One project across agent and browser.** Continue in Vixel without moving
  your story and media into a separate tool.
- **Images and videos with visible costs.** Review the quote before an
  authorized generation; standalone creations appear in My Assets.
- **Keep the material you like.** Review candidates, reuse accepted references,
  and change selected shots without rebuilding the whole project.
- **Recover the original job.** Inspect a slow or interrupted generation before
  retrying, instead of accidentally submitting it twice.

The Skill guides your agent; the CLI performs supported Vixel operations.
Your agent handles creative planning. Vixel owns project state, media jobs,
account permissions and credits. Local video export also needs FFmpeg/FFprobe.
Automatic social posting and audience analytics are not available through this CLI.

## Accounts and credits

Downloading and installing the client does not spend Vixel credits. Image and
video generation uses your Vixel account and the platform's quoted credit cost.
Your coding agent's subscription is separate. Connecting an agent does not
approve paid generation or publishing.

## Already installed?

Ask your agent:

```text
Update my Vixel CLI using https://cli.vixelai.com/vixelCLI-setup.md.
Keep my existing login and review any local Skill changes before replacing them.
```

The installer needs `--upgrade` (`-Upgrade` on Windows) to replace a different
binary. Use the same install folder, platform and session configuration. Skill
updates are separate: setup preserves differing files so custom instructions
are not lost. See the [update guide](https://cli.vixelai.com/vixelCLI-setup.md#updating-an-existing-installation).

## Login help

If the browser says **127.0.0.1 refused to connect**, the waiting process may
have ended—or login may already have finished. Ask your agent to check
`auth status` using the same executable and session. If needed, refresh an
expired session or start a new login and open its new URL. Do not refresh the
old callback page or share the `code`, `state`, or session credentials.

Version 0.5.7 waits up to 15 minutes and prints progress while you sign in.
If you connected through a native MCP connector, check that connector's login;
it is separate from CLI login.

## Downloads and documentation

**Current release: 0.5.7 · Alpha.** This public repository contains the
client distribution, Skill and documentation. It does not contain the Vixel
application/server source and is not an open-source license grant.

- [Release notes](RELEASE_NOTES.md) · [Versioned downloads](https://github.com/Vixel-AI/vixel-cli/releases/tag/v0.5.7)
- [Agent setup guide](https://cli.vixelai.com/vixelCLI-setup.md) · [CLI reference](CLI.md)
- [Platform Skill](skills/vixel-platform/SKILL.md) · [Current version and SHA-256 hashes](current.json)
- [Report a problem](https://github.com/Vixel-AI/vixel-cli/issues) — include the version, OS and error text; omit credentials and private project content.

<details>
<summary>Supported builds and verification</summary>

| Build | Verification |
| --- | --- |
| darwin-arm64 | Executed on release host; see release notes for checks |
| darwin-x64 | Cross-compiled; not executed on target host |
| linux-arm64 | Cross-compiled; not executed on target host |
| linux-x64 | Cross-compiled; not executed on target host |
| windows-x64 | Cross-compiled; not executed on target host |

The installer verifies SHA-256 before installation. Checksums identify the
release bytes; they are not OS signing or notarization. Windows ARM64 is not
provided. Installation checks do not prove every media workflow on every host.

</details>
