# Vixel CLI · Film v1 alpha

Use the standalone Vixel client without installing Node.js, npm, Python or Bun.
Give your local coding agent `<TARGET_ORIGIN>/agent.md`; it downloads the correct
verified executable, installs the bundled platform Skill and starts browser login.
Vixel's server owns identity, wallet, canonical Work, provider routing, Jobs and
assets. The executable embeds only the client and public Skill/documentation.

In all examples, `vixel` means the executable you just installed. With the
one-link default prefix, use `./.vixel-client/bin/vixel` (Windows:
`.vixel-client\bin\vixel.exe`). The installer does not modify your PATH.

```sh
vixel setup --directory "$PWD" --base-url "<TARGET_ORIGIN>" --no-browser
vixel doctor
vixel docs
```

The optional npm fallback requires Node.js 22+. It is a separate distribution,
not a prerequisite for the standalone executable. Obtain its versioned tarball
and checksum from the target deployment's `/creator/mcp` page, then use
`npm install -g "./<DOWNLOADED_CLI_TARBALL>"` with the actual downloaded filename.
This npm artifact contains `src/`, the bundled Skill text, README, package
metadata and `docs/workflow.md` with rehearsal screenshots. It is not published
to the public npm registry.

Copy the exact target origin from the connection page into `<TARGET_ORIGIN>`
(in local development, for example, `http://localhost:5000`). Keep the browser
and CLI on that same origin; do not substitute a production deployment.

```bash
vixel auth login --base-url "<TARGET_ORIGIN>"
vixel account get --json
vixel models list --json
vixel help
```

The target must deploy Film v1. Source presence is not deployment or live-media
proof. Every command prints JSON `{ok:true,data:...}` or
`{ok:false,error:{code,message,...}}`. Exit codes: 0 success, 2 invalid local
input/config, 3 auth/redirect, 4 request/Job failure, 5 unavailable capability.
`--dry-run` sends no HTTP request and validates the local envelope, not live
pricing or nested platform policy. `--json` makes agent intent explicit.

## Project workflow for agents

For a full film, follow Script (screenplay) → Story/Production Plan with
Elements/Shots → first looks → storyboard review → video → preview/export.
For standalone Generator requests or targeted edits, keep the requested scope;
do not impose a new screenplay or rebuild an existing Work.

Before the initial production plan, verify the same Work revision contains a
saved document with `documentKey: "screenplay"` and `kind: "script"` and that
the required stage approval is satisfied. That is what the Script page reads.
`story put` writes a graph; its scene `script` fields and confirmed Story
readiness do not prove the screenplay was saved. Inspect actual `help` and
target capabilities: if saving the screenplay is unavailable, use the supported
website path or report the missing step. Do not skip to `plan put`, invent a
screenplay command, or use internal/admin routes to simulate completion.
Manual authoring from template guidance is not native template execution.

All new media for a Vixel task, including starter reference images, should be
generated through Vixel CLI/MCP. Do not silently use built-in/external generation
then upload its result. Distinguish user-provided/existing uploads, reused
assets, and explicitly requested external generation from new platform Jobs.
A copied `candidate` is not a ready Element reference; verify current accepted
bindings before dependent generation and use the supported adoption path.
The CLI does not grant additional adoption or spending authority.

In Codex, proactively show the target website in the right browser panel and
open the exact project once its ID is known. A queued panel request or a
successful API response is not proof of page loading or visual acceptance.
Use the installed Skill's surface mapping to select Script, the relevant
Element/Shot, or Timeline/Preview before operating. After a successful write
and canonical readback, refresh the same tab, restore its target selection and
inspect the changed result; preserve unsaved browser drafts. Refresh again at
an asynchronous Job's terminal result, without resubmitting it. Leave the final
result visible at delivery. These are Agent browser actions: CLI success does
not automatically navigate or refresh a Codex tab.
Report the last verified production checkpoint, actual Job/Asset IDs and credit
receipts; do not describe a project skeleton or single-image test as a complete
film workflow. Follow the platform Skill for browser handling and recovery.

## Author a Work (CLI 0.4.0)

`projects list/get/create`, `story get/put`, and `plan get/put` share the Film
external operation boundary with MCP projects/project/project_create,
story_save/plan_save. Existing command syntax is preserved. Creation never
invokes the internal Director and uses the same account capacity checks as the
website. Reads do not perform background recovery.

```bash
vixel projects list --json
vixel projects create --input project.json --idempotency-key work-create-001
vixel projects get --project PROJECT_UUID --json
vixel story put --project PROJECT_UUID --input story.json --idempotency-key story-save-001
vixel plan put --project PROJECT_UUID --input plan.json --idempotency-key plan-save-001
```

`project.json` contains title, optional premise and aspectRatio (16:9 or
9:16). Save and read back the canonical Script before Story/Plan. `story.json`
contains the current expectedRevisionId/expectedWriteVersion and a complete
scenes array. A scene has sceneKey, kind (scene/ending), title, durationMs,
isStart, optional summary/script/requiresVideo/nextSceneKey/choice. `plan.json`
contains the current guard plus complete elements and shots arrays. Elements
use elementKey/kind/name/description. Element `kind` must be one of
`character`, `location`, `prop`, or `voice` (a person or robot is `character`,
not `role`). Shots use shotKey/sceneKey/title/durationMs,
optional purpose/camera/action/audioCue/prompt/visualElementKeys. Writable fields
only: do not send read-model IDs, accepted bindings or sortOrder. Preserve
unrelated content when replacing arrays. The initial plan rejects a missing
canonical Script. A stale guard conflicts; a same-key replay returns the
original receipt. These saves neither generate media nor approve it.

The complete workflow remains Script → Story/Plan → first looks → storyboard
review → video → Timeline → export → approved distribution → observations →
creator decision. This increment completes authoring transport parity only.
Adoption, Timeline and prepared releases share the Film MCP registry; local CLI export uses the server cut manifest.
Channels, posts and metrics remain unavailable in this
CLI; a release record is not a published social post.

## Authenticate

`auth login` opens browser OAuth, reuses Vixel's Google/email login, requests
`film.read film.write film.generate offline_access`, and receives a one-time
code on a random loopback port with S256 PKCE. `--no-browser` prints the URL for
manual opening on the same computer. Device authorization is not implemented.
Tokens stay in `~/.config/vixel/session.json` with 0600 permissions. Override
`VIXEL_CONFIG` to isolate environments. No token is printed in JSON output.

Use `auth status`, `auth refresh` and `auth logout`. Refresh is explicit and
rotates credentials; do not refresh one config concurrently. Failed revocation
retains the config for retry. You can also disconnect through `/creator/mcp`.
Saved credentials never follow redirects or an origin change. Optional
`--cookie-file` imports a private developer session; logout only removes that
local copy. `--local-development` requires a loopback server with an already
configured development bypass; it never enables one remotely.

## Save and read the Script

`screenplay get/create/update` share the MCP operations
`film_v1_screenplay_get/create/update` and the website's canonical document
owner. They use `/api/film-studio/v1/external/screenplay_*`; generic document
routes remain closed to bearer clients. Read requires `film.read`; create and
update require `film.write`, not `film.generate`.

Save `{"projectId":"PROJECT_UUID"}` as `script-read.json`, then:

```bash
vixel screenplay get --input script-read.json --json
```

The result contains `document` (null if absent), `revision` and the Script
`webUrl`. For the initial screenplay, create `script-create.json` using the
returned revision, replacing the placeholder UUIDs:

```json
{
  "projectId": "PROJECT_UUID",
  "expectedRevisionId": "REVISION_UUID",
  "expectedWriteVersion": 0,
  "title": "A Small Home",
  "content": "# A Small Home\n\nINT. WINDOW — DAWN\n\nA kitten follows the warm light.",
  "format": "markdown"
}
```

```bash
vixel screenplay create --input script-create.json --idempotency-key screenplay-create-001 --json
vixel screenplay get --input script-read.json --json
```

The server fixes `documentKey=screenplay` and `kind=script`. Do not send these
fields or an owner in the input. To update, include the returned `documentId`,
current revision guard and full title/content in `script-update.json`, then run
`vixel screenplay update --input script-update.json --idempotency-key screenplay-update-001`.
Supported formats are `markdown` (default) and `plain_text`; content must be
nonblank and remains subject to document and transport size limits.

Writes return the canonical document, revision, change summary and durable
receipt. After an ambiguous write, retain the exact body/key and repeat that
same operation; replay returns the original receipt without another mutation.
A new key with a stale revision conflicts; changed content with the original
key also conflicts. Only the canonical screenplay can be updated through this
adapter. Saving charges no credits and creates no Story, Elements, Shots or
media Jobs, and does not approve the screenplay or update an existing Plan.

## Quote, submit and recover

Save this as `quote.json`:

```json
{"mode":"generator","mediaKind":"image","prompt":"A silver paper boat on a quiet blue lake.","options":{"aspectRatio":"16:9"}}
```

```bash
vixel generation quote --input quote.json --json
```

Quotes create no workspace, Job, debit or provider request. After the user
approves the displayed cost, copy these exact inputs into `submit.json` and add
returned `quoteId` and your explicit `maxCredits`. Then:

```bash
vixel generation submit --input submit.json --idempotency-key boat-image-001 --json
vixel jobs wait --project PROJECT_ID --id JOB_ID --wait-timeout 120000
vixel generator assets --json
vixel open
```

Read `data.job.id` and `data.job.projectId` from submission. The server rechecks
normalized inputs, model version, references, revision and pricing before a new
Job. No client-side discount applies. `mode:work` additionally requires explicit
`projectId`, `target:{kind:"element"|"shot",id:...}`, `expectedRevisionId` and
`expectedWriteVersion`; never infer the latest project. Audio uses website
approval and is not exposed through this generation adapter. Old raw
`generation create`/`prepare` bearer routes are denied.

For a multi-panel Shot storyboard, explicitly set
`options.storyboardMode: "sequence"` in both quote and submit. Without it, Shot
images use the existing single opening-frame contract; prose alone cannot
select sequence mode. Sequence mode is supported only for Work Shot targets,
and follows the same canonical prompt, references and pricing as the website.
Changing this option requires a fresh quote and a new intentional request key.

After a timeout, preserve the original key and body. Put
`{"idempotencyKey":"boat-image-001"}` in `request.json` and run
`vixel requests get --input request.json`. Not found may mean still in flight;
never manufacture a replacement key. Repeating the same accepted submission
returns the original Job, even after its Work/model changes. Changed inputs
with that key conflict. `jobs get`/`wait` read; `jobs sync` reconciles and
`jobs resume` explicitly resumes the same blocked Job after top-up. These last
two use `--input empty.json` (`{}`) and a stable `--idempotency-key` for the CLI
envelope; recovery itself is bound to the existing Job ID. No write is retried
automatically. `candidate` and `accepted` retain the server's actual meaning.

## Local references and downloads

Run `generator workspace` to inspect without creating. Run `generator init`
explicitly if you need a private workspace for reference upload. Put its
`projectId`, `expectedRevisionId` (workspace `revisionId`),
`expectedWriteVersion` (workspace `writeVersion`), a `label` and `mimeType` in
`upload.json`; video requires its actual `durationMs` where required.

```bash
vixel assets upload --file reference.png --input upload.json --idempotency-key boat-reference-001
vixel assets download --project PROJECT_ID --id ASSET_ID --output ./result.png
```

Upload computes size/SHA-256, requests an intent, sends bytes to the HTTPS
signed URL without account credentials, then finalizes through the platform.
The server verifies bytes and ownership. Keep the original input/key on failure.
Reference uploads support images and video, bounded to 24 MiB and 128 MiB respectively by server policy.
Downloads use the authenticated same-origin media endpoint, refuse redirects,
cap at 128 MiB, and never overwrite an existing destination. For a Work copy,
use `assets add-to-work` with source asset and exact destination revision guard.
It copies a candidate for review, not canonical adoption.

## Compatibility and evidence

The CLI and Film MCP share bounded media operations and canonical Work
authoring, including screenplay, Story, Plan, review, Timeline and prepared
release operations. Their schemas remain owned by the Film API; verify the
actual target deployment rather than inferring live readiness from client help. Social posting, server rendering and analytics are
not available; do not substitute legacy admin routes. Release creation prepares
a record and never publishes a post.

Local HTTP/OAuth/PostgreSQL tests and a packed-artifact install check are
separate from real account login, live provider completion and browser media
review. Production enables only after those environment-specific checks.

## Complete production walkthrough

Run `vixel docs --topic workflow` for the historical rehearsal inputs, results and test boundaries. This works offline in the standalone executable. Its illustrative screenshots are files in the optional npm package; they are not installed by standalone setup. CLI 0.4.0 adds shared review/Shot-reference/Timeline/release adapters and local `exports render`. Install FFmpeg and FFprobe on the client. `exports render --project ID --input revision.json --output final.mp4` writes a watermarked cut plus `final.mp4.json`; `--clean` requires the current account entitlement. Rendering downloads verified owned assets, never invokes a paid model, refuses overwrite and rechecks the Work after rendering. It follows the same accepted first canonical route as browser Preview; inspect manifest issues/containsStills before describing production as complete. Local rendering is not a hosted render service or a published release.

`releases upload --input upload.json --file final.mp4 --idempotency-key KEY` accepts the exact project/revision/write version, label, `mimeType: "video/mp4"` and durationMs. It records a reviewed final cut. `releases create` then binds that asset to a prepared release; it does not publish to social media.

## Manual Skill installation (optional)

The connection page also offers the reviewed `vixel-platform` Skill and its SHA-256.
As an alternative to `setup`, save it as `.agents/skills/vixel-platform/SKILL.md`
in your own working folder and ask Codex to use it. No product repository is
needed. Read the walkthrough with `vixel docs --topic workflow`; only the npm
distribution also includes a physical `docs/workflow.md` and screenshot files.
Connecting still requires the deployment’s browser OAuth.
A local deployment must configure `VIXEL_MCP_PUBLIC_BASE_URL` to the same origin
shown to the client (including localhost vs 127.0.0.1). Do not bypass a resource mismatch.


## One-link setup (standalone 0.5+)

Public client releases are distributed separately from the Vixel application at
`https://github.com/Vixel-AI/vixel-cli`. The release's `agent.md` selects its
versioned artifacts; the requested platform origin still owns OAuth and API
calls. For a separate artifact host, pass `--download-base-url <release assets
URL>` to install.sh (`-DownloadBaseUrl` on Windows) while keeping `--base-url`
set to the platform. Never sign in to the download host or send it session tokens.
Without this option, local/deployment downloads still use `<TARGET_ORIGIN>/downloads`.

Give your local coding agent `<TARGET_ORIGIN>/agent.md`. The public instructions
select a platform build from `/downloads/vixel-standalone-manifest.json` and
install a SHA-256-verified executable. End users need no Node.js, npm or Bun.
Bun is used only on the release build machine; compilation is not encryption.
macOS arm64/x64, Linux arm64/x64 and Windows x64 build targets are provided.
Execution verification is recorded per target; cross-compilation alone does not
prove Windows/Linux compatibility. Windows ARM64 is not provided.

```sh
vixel setup --directory "$PWD" --base-url "<TARGET_ORIGIN>" --no-browser
vixel doctor
vixel docs
vixel docs --topic skill
vixel docs --topic workflow
```

Setup installs the bundled platform Skill and README under the chosen working
folder's `.agents/skills/vixel-platform/`. It never overwrites differing files;
review a conflict rather than replacing custom guidance. It records platform
selection next to the existing private session configuration, without changing
an existing connection to another origin. Use a separate `VIXEL_CONFIG` for
another platform. Repeating setup with identical content is safe. `--no-login`
installs the Skill only; otherwise missing authentication starts browser OAuth,
and an expired refreshable session is refreshed. `--no-browser` prints the URL
for the Agent's sidebar while the one callback listener remains alive.

Read the installed Skill in the current task. Automatic Skill discovery may
require refreshing the host or starting a new task. Setup does not install an
MCP connector or modify global Agent settings. Chat-only agents need their
host's supported connector flow; a URL alone cannot grant tools or permissions.

Doctor is read-only: inspect `data.ready` and each check, not just `ok`.
It checks the installation, bundled Skill, platform OAuth metadata and account.
It never generates, spends, creates a Work or silently logs in. `docs` returns
bundled public reference text even before login. The workflow document includes
historical rehearsal image links available in the npm package; it is not live
acceptance evidence. FFmpeg/FFprobe are separate optional dependencies for local
movie export; setup and image creation do not require them.
