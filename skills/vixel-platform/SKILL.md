---
name: vixel-platform
description: Operate Vixel Film Studio with the installed CLI and automatically open its page in the Codex right browser sidebar. Use when a user asks Codex to work inside Vixel, create or review videos, edit a project or timeline, recover media jobs, or inspect release capabilities. This skill teaches platform operation; it does not prescribe a creative style or replace filmmaking skills.
---

# Operate Vixel

Run `vixel help` and `vixel capabilities` using the independently installed CLI.
Here and in returned command hints, replace `vixel` with the actual installed
path, such as `./.vixel-client/bin/vixel`; the installer does not modify PATH.
No Vixel source checkout is required. The standalone executable needs no Node.js.
Use `vixel docs` for JSON input examples, `vixel docs --topic workflow` for the
production walkthrough, and `vixel doctor` for read-only connection checks.
`vixel setup --directory <your working folder> --base-url <target origin>` installs
this Skill locally and starts browser OAuth if necessary; it never overwrites
a different Skill or switches an existing login to another origin. Read the
installed SKILL.md directly if your current task has not rediscovered Skills. Use `vixel docs` and `vixel docs --topic workflow` for JSON examples.
These commands work offline in both distributions; standalone users do not
need an npm package directory or local workflow.md file. In the product repository,
maintainers can also use `npm run --silent vixel -- help`; API code changes
follow the repository API SSOT. Treat capabilities as client implementation
metadata, not live provider proof.

## Work authoring through either transport

CLI `projects list/get/create`, `story get/put` and `plan get/put` now share
external operations with MCP `film_v1_projects`, `film_v1_project`,
`film_v1_project_create`, `film_v1_story_save` and `film_v1_plan_save`.
Existing CLI syntax keeps `--project` for the selected Work and `--input` for
write payloads. Create an empty Work with a stable key; it never asks the
internal Director to generate a story. Read the returned revision before writing.
Story and Plan writes replace whole arrays: preserve unrelated content, send
writable fields only, and recover uncertain writes with the same body/key.
Initial Plan writes require the canonical Script. Writes do not approve media
or start production. CLI and MCP now share explicit asset review, Shot references, Timeline patch/undo, export manifests and prepared releases. Run `vixel docs --topic workflow` for the historical rehearsal and exact commands; screenshots are included only in the optional npm package. Public posting and audience metrics remain unavailable; do not equate a prepared release with distribution.

## Complete a project in platform order

For an idea or template-to-film request, follow the existing Work checkpoints:
**Script (screenplay) → Story and Production Plan (Elements/Shots) → first looks
→ storyboard review → video → preview/export**. This is a dependency order,
not permission to spend or adopt media. Keep creative choices autonomous;
respect the user's scope and existing stage approvals. Standalone Generator
requests and edits to an existing ready Work do not restart this sequence.

Before creating the initial Elements/Shots, save the full screenplay through a
supported platform operation and read it back on the same Work revision. The
Script surface reads a document with `documentKey: "screenplay"` and
`kind: "script"`. Scene `script` fields, a premise, `story put`, or
`storyReadiness: "confirmed"` alone do not prove that this document exists.
Do not construct Elements/Shots first and report the Script as completed.
Use `screenplay get` with a JSON input containing `projectId`; use
`screenplay create` if its `document` is null, or `screenplay update` with the
returned `documentId` for an authorized revision. Writes require the current
revision/write version and a stable key. See the CLI README for exact inputs.
MCP equivalents are `film_v1_screenplay_get`, `film_v1_screenplay_create` and
`film_v1_screenplay_update`. Saving returns the canonical document and receipt;
it does not approve the screenplay or start Story/Plan/media automatically.
If the connected CLI/MCP cannot save the screenplay, use the supported website
path where available; otherwise report that exact missing step. Do not skip it,
invent a command, call the internal conversational Agent, or bypass the public
boundary. Reading template guidance and manually authoring a Work is not native
template execution; identify which path actually ran.

At each handoff, read back the saved result and its target bindings. An image
copied into a Work as `candidate` is not an adopted Element Main or a ready
reference. Verify the accepted Element/Shot pointers and current dependencies
before continuing. Use the supported, authorized adoption path when needed;
do not silently mark candidates accepted. Report the last completed checkpoint
and the actual blocker rather than treating a populated project as a finished
film. Do not delete or rebuild existing work merely to restore this order.

## Generate new media through Vixel

For Vixel production tasks, generate all new media through Vixel CLI/MCP,
including an initial cat/character reference. Do not use built-in imagegen or
direct provider calls and then upload their output as a substitute. Upload is
for user-supplied/existing material or explicitly requested external generation;
retain its provenance and distinguish imported media from platform generation.
Reuse suitable existing assets when within scope, but say they were reused.
If platform generation is unavailable, report the blocker instead of silently
switching tools. Existing cost limits and approvals still apply.

## Automatically open the right browser sidebar

When asked to operate the platform or make/review a video, open Vixel in the
Codex right browser panel yourself. Do not ask the user to open the sidebar,
type the address, or copy a project URL. Pure code or documentation work does not
need a platform tab.

1. Resolve the target origin from the user's request and CLI configuration
   (`auth status`). Keep browser and CLI on that same environment; never silently
   switch between local and production.
2. Use `mcp__codex_app__open_in_codex` with the resolved URL:

   ```json
   {"placement":"right","target":{"type":"browser","url":"<resolved platform URL>"}}
   ```

   This tool opens the panel only. Its success is not proof that the page loaded,
   the user is signed in, or a video plays.
3. Inspect and operate that in-app browser using available browser tools. With
   `mcp__cua_repl.js`, discover and reuse the matching in-app tab; if none exists,
   use `cua.createBrowserTab("iab", resolvedUrl, { visible: true })`. Follow the
   tool's initialization and returned API documentation. Prefer this sidebar
   over launching Chrome or another external browser; avoid duplicate tabs.
4. Leave the installation document after setup: show the connection page for
   connection checks, then the requested working surface. Once a Work ID is
   known, reuse the same tab for that exact Work before operating on it. Follow
   returned URLs or observed links and controls; do not invent route parameters.
   Select the surface for the operation, not just the project landing page:

   | CLI operation | Surface to show |
   | --- | --- |
   | Account / connection setup | Connection page; after login return from consent to the requested task |
   | Screenplay read/write | The Work's Script |
   | Story / Plan | Story or the corresponding Elements/Shots view |
   | Element reference / first look | The selected Element in Visuals |
   | Shot storyboard / video | The selected Shot in Storyboard/Visuals |
   | Timeline / export | Timeline or Preview |
   | Standalone Generator media | Generator / My Assets for that result |

5. After a successful CLI write or a small coherent group of writes, read back
   the canonical result, then refresh this same browser tab with `tab.reload()`
   (or the page's visible refresh control). First check for unsaved user edits;
   do not discard a draft or approve an unload warning. If a draft blocks
   refresh, preserve it and report that the browser view is not yet verified.
   After loading, reselect the intended surface and Element/Shot if reload
   reset local selection. Inspect the actual changed text, asset, status or cut
   and confirm the same Work/target as the CLI receipt. Merely focusing the tab,
   requesting `open_in_codex`, or receiving CLI success is not a refresh check.
6. For asynchronous media, poll the original Job through CLI. Refresh at the
   submitted/running stage when useful and at completion, failure or recovery;
   do not reload on every poll or submit again because the page looks stale.
   Inspect the completed candidate; play requested video when available and
   check composition, continuity, timing, text and audio. If the page still
   disagrees with canonical readback after one refresh/reselection, report a
   UI synchronization gap without repeating the mutation or charge.
7. Before delivery, refresh and inspect the final target again unless already
   verified after the last change, and leave that result visible in the same
   right-side tab. Preserve the tab with `markDeliverable()` where supported.
   Report CLI completion and browser verification separately when either is
   blocked. Do not leave the user on agent.md, OAuth success or an old preview.

Use CLI for supported reads, mutations and job polling; use the browser for
login, UI-only interactions and visual review. Do not submit the same generation
through both surfaces. Browser and CLI must operate on the same canonical Work.
For UI-only export, verify the resulting artifact before reporting completion.
If sidebar/browser tools are unavailable, state that limitation and continue
useful CLI work; never claim the panel opened or the video was reviewed.
If the open request returns `queued`, report that state. A browser-operation
denial must not be bypassed with another browser or automation tool.

## Establish identity and execute the bounded media loop

Use `auth status`, `account get`, `models list`, `generator workspace` and
`generator assets` before operating. `auth login --no-browser --base-url ORIGIN`
prints the exact PKCE browser URL; open it in the right sidebar and keep the CLI
callback alive. The user reviews the grant; do not request credentials or copy
browser secrets. `auth refresh` rotates expired access; old deployments fail
closed. Keep browser and CLI on the same origin.

Run `vixel docs` for exact JSON inputs. Prefer `generation quote`
then `generation submit` with the exact `quoteId`, user-approved `maxCredits`
and stable key. Connecting alone does not authorize spending. Default to
Generator for standalone media; Work mode needs an explicit project/target and
current revision guard. No-cost quote must not create the workspace. For local
references explicitly use `generator init`, then `assets upload`; only finalized
owned assets are references. `assets download` writes a new explicit local file.
For multi-panel Work Shot storyboards, put `options.storyboardMode: "sequence"`
in quote and submit. Omission means a single opening frame; descriptive prose
does not select the mode. Inspect the actual output before advancing to video.

Read/wait the returned Job ID. On an unknown outcome use `requests get` with the
original key, never a replacement generation. After top-up use same-Job resume.
Reflect actual candidate/accepted status and review in the browser. The MCP
alternative uses the identical `film_v1_*` operations discoverable through the public MCP tool schemas. Use `asset_review` only after explicit review authorization; read back accepted target pointers. A storyboard alone is not a Timeline clip: add stills explicitly with `timeline_patch` when a Story Reel is requested. Preserve exact Shot binding and every projected sibling. `timeline_undo` uses a current guard and the original receipt.

CLI `exports render` needs local FFmpeg/FFprobe, an exact revision input and a new output path. It uses the server `export_manifest`, downloads owned hashed bytes, rechecks the cut after rendering and writes an MP4 plus local JSON receipt. Default output is watermarked; `--clean` requires entitlement. The manifest describes the first canonical route and excludes unready slots; inspect issues before claiming a complete film. `releases upload` saves the reviewed final MP4; `releases create` prepares its immutable release. Neither publishes it. Never use legacy administrator routes to fill social/metrics gaps. Keep product
copy in English. Source/tests do not prove deployment or live provider quality.
