# `zsh-git-good`

<p align="center">
  <img src="./asset/logo/zsh-git-good.png" width="35%" alt="zsh-git-good logo">
</p>

<h3 align="center">Prepared Git commit messages, right where you type them.</h3>

<p align="center">
  <a href="#-start-with-zsh-git-good">Start</a> ·
  <a href="#-operate-it-carefully">Safety and privacy</a> ·
  <a href="./docs/INSTALLATION.md">Installation</a> ·
  <a href="#-contributing">Contributing</a>
</p>

<p align="center">
  <img alt="Go 1.26+" src="https://img.shields.io/badge/go-1.26%2B-00ADD8?style=flat-square">
  <img alt="Zsh 5.0.8+" src="https://img.shields.io/badge/zsh-5.0.8%2B-89e051?style=flat-square">
  <img alt="Local deterministic default" src="https://img.shields.io/badge/default-local%20deterministic-2e7d32?style=flat-square">
</p>

`zsh-git-good` prepares commit-message candidates from your staged Git changes
and displays them through ordinary
[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) ghost
text. A private local daemon prepares candidates after each prompt. While you
type, the plugin looks up a candidate for the exact current staged state;
generation stays out of the typing path.

```zsh
git commit -m 'chore(cache): update 2 staged files'
# The message is prepared ghost text. Accept it with your usual
# autosuggestions binding, review the command, then press Enter yourself.
```

**Prepare, review, then commit.** Accepting a suggestion fills the shell buffer.
The plugin never stages files or executes a commit. The default provider is local
and deterministic; Ollama and OpenAI require explicit configuration. Normal use
requires no model, API key, account, telemetry, or cross-device sync.

## Contents

- [🚀 Start with zsh-git-good](#-start-with-zsh-git-good)
- [🤔 Why zsh-git-good?](#-why-zsh-git-good)
- [🔎 How it works](#-how-it-works)
- [👀 Choose an entry point](#-choose-an-entry-point)
- [🧪 See it in action](#-see-it-in-action)
- [🛟 Operate it carefully](#-operate-it-carefully)
- [📚 Learn more](#-learn-more)
- [🌟 Contributing](#-contributing)
- [License and release status](#license-and-release-status)

## 🚀 Start with zsh-git-good

### Prerequisites

Install Git, Zsh 5.0.8 or newer, Go 1.26 or newer, and
[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions).
The dependency must load before this plugin. The current CI configuration pins
Go 1.26.7. Make is used for the build; Python 3 is needed for the full test suite
and release preparation, but not ordinary runtime.

For example, on Fedora:

```zsh
sudo dnf install git zsh zsh-autosuggestions golang make python3
```

The Fedora autosuggestions package normally installs its source at
`/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh`. Setup also discovers
common Homebrew locations or accepts an explicit `--autosuggestions` path.
Ollama, Neovim, and an OpenAI API key are optional.

### Build and use the setup wizard

From a reviewed source checkout:

```zsh
git clone https://github.com/gongahkia/zsh-git-good.git
cd zsh-git-good
make build
.build/zsh-git-good setup --wizard
```

The wizard reviews the installation prefix, shell startup file, dependency,
provider, message preferences, and keybinding before applying changes. It
installs the helper and plugin and manages one marked startup block, with
backups and undo information. It honors `ZDOTDIR` and preserves symlinked
startup files. Selecting a provider does not download a model or grant cloud
access.

Open a fresh Zsh session, then verify the installation:

```zsh
zsh-git-good version --json
zsh-git-good doctor --check
zsh-git-good setup --check --demo
```

The demo uses a disposable repository and isolated product data to prepare a
real deterministic suggestion through the daemon/socket path. It creates no
commit and cleans up its temporary daemon and files.

### Install without managed shell edits

For manual shell configuration, use the source installer instead of the wizard:

```zsh
make build
sh scripts/install.sh --source "$PWD" --prefix "$HOME/.local"
```

Add these lines to `.zshrc` after loading `zsh-autosuggestions`:

```zsh
path=("$HOME/.local/bin" $path)
source "$HOME/.local/share/zsh-git-good/zsh-git-good.plugin.zsh"
```

This script installs the executable and plugin, plus license/notices files when
present. It does not edit `.zshrc`. A custom prefix uses the same `bin` and
`share/zsh-git-good` layout. Inspect `Makefile`, `scripts/install.sh`, and
`zsh-git-good.plugin.zsh` before installation; there is no required remote
shell installer.

For development, run `make build`, load autosuggestions, and source the checkout:

```zsh
path=("$PWD/.build" $path)
source "$PWD/zsh-git-good.plugin.zsh"
```

### Compatibility and existing installations

| Environment | Recorded evidence |
| --- | --- |
| Fedora Linux 43 | Source/runtime, shell integration, setup, removal, and release-snapshot checks were exercised locally. |
| macOS `amd64` | The October 2026 audit records Go/Zsh/Neovim integration, lifecycle, race, fuzz, and snapshot checks on an Intel Mac. |
| Linux and macOS `amd64` / `arm64` | Snapshot builds cover all four targets; cross-compilation alone does not establish runtime support on every target. |
| Other operating systems and shells | Not verified; the interactive plugin requires Zsh and zsh-autosuggestions. |

The optional Neovim adapter emits activity only. Bash, Fish, and PowerShell do
not have suggestion adapters. See [installation evidence](docs/INSTALLATION.md)
for the tested versions and remaining release checks.

The project rename changes the executable, plugin filename, `git-good` strategy,
`ZSH_GIT_GOOD_*` variables, Lua module, and product-specific XDG directories.
Previous installations and data are **not migrated automatically**. Before
switching, use the previous installed helper to remove its managed integration,
or remove its manual source line and unload it. Start a fresh shell after
installing this version. Review any preferences you copy into the new config
location, update repository policy filenames to `.zsh-git-good.toml`, and grant
optional data access again through the new helper. Old installation records and
undo journals should remain with the version that created them.

## 🤔 Why zsh-git-good?

A commit message should describe the changes you actually staged. Preparing it
in the background lets the shell offer useful text while keeping review and
execution in your hands.

| When you need to… | zsh-git-good helps by… |
| --- | --- |
| start a commit message without leaving the terminal | supplying ghost text through your existing autosuggestions acceptance and dismissal bindings |
| avoid reusing a message after staging different changes | matching candidates to exact Git index, HEAD, branch, configuration, repository, and worktree identities |
| keep typing independent of inference | preparing candidates in the daemon and performing only a bounded lookup from the strategy |
| follow repository conventions | validating declarative type/scope, path mapping, line-length, capitalization, and body policies |
| inspect why a message was proposed or withheld | exposing context metadata, grounding results, provider provenance, and actionable diagnostics |
| keep normal use local | using deterministic generation by default, with separately configured local/cloud providers |
| tune or temporarily stop suggestions | offering validated preferences, explicit feedback, disable/enable, and expiring snoozes |
| recover from installation or configuration mistakes | recording managed changes with backups, conservative repair, and undo |

The plugin registers `git-good` ahead of existing strategies and leaves display
to zsh-autosuggestions. It does not define a `git` function, replace the prompt,
or install a separate terminal renderer.

## 🔎 How it works

1. **Observe after the prompt.** A background request starts the private daemon
   when needed and snapshots the current repository. The default idle timeout is
   15 minutes.
2. **Identify the exact staged state.** Git plumbing reads the index tree,
   HEAD/unborn state, branch, and repository/worktree identity. Relevant settings
   and context versions participate in the fingerprint. A private copy of the
   index keeps the real index unchanged.
3. **Prepare bounded context and candidates.** Background generation compiles
   staged metadata and selected staged content, applies redaction, then invokes
   the configured provider. The default deterministic provider uses conservative
   metadata and textual facts. Optional provider output is treated as untrusted.
4. **Validate before publication.** Grounding checks evidence references and
   unsupported claims; repository policy and optional local style learning rank
   eligible candidates. Superseded jobs are cancelled, and staged state is
   checked again around atomic cache publication.
5. **Look up while typing.** The strategy accepts a conservative commit-message
   command subset and requests only an already prepared candidate matching the
   current fingerprint. Missing, stale, conflicting, or unsupported states yield
   quietly so other autosuggestion strategies can continue.
6. **Let you accept and execute.** A matching candidate extends your typed
   prefix with shell-safe text. Your ordinary keybinding accepts it into the
   buffer; only your subsequent command submission runs Git.

Unstaged content is excluded from generation. Git may create an immutable,
unreferenced tree object while calculating an index identity, but the plugin
creates no commit, ref, or staged entry. Exact identity and bounded retention
handle obsolete cache records; they do not claim to eliminate every publication
race. See [architecture](docs/ARCHITECTURE.md) for the full concurrency and
freshness model.

## 👀 Choose an entry point

| Entry point | Best for | Start here |
| --- | --- | --- |
| Zsh ghost text | preparing a subject during your usual commit workflow | Type `git commit -m ` after staging changes. |
| Guided setup | installing, customizing, repairing, disabling, or removing | `zsh-git-good setup --wizard` |
| Scripted preferences | applying a validated batch of settings | `zsh-git-good setup customize --set commit.line_length=72` |
| Troubleshooting | inspecting the installed shell, daemon, and current repository | `zsh-git-good doctor --check` and `zsh-git-good status --cwd . --json` |
| Candidate inspection | reviewing prepared messages and their evidence | `zsh-git-good candidates --cwd .` and `zsh-git-good explain --cwd . --json` |
| Commit-body composition | editing a prepared subject and a staged-path body | `zsh-git-good compose --cwd .` |
| Evaluation | checking a synthetic corpus or replaying local history | `zsh-git-good evaluate --fixtures --json` |
| Optional Neovim activity | contributing file/diagnostic metadata with consent | `require("zsh-git-good").setup(...)` |

`compose` reports a private message-file path after editor and state checks; it
does not invoke `git commit`. A repository policy requiring a body reserves an
eligible subject for compose instead of showing it as ghost text.

## 🧪 See it in action

### Prepare, accept, and cycle a message

Stage the changes you want to describe with your normal Git workflow, then return
to the prompt. Type `git commit -m `, including the trailing space, and accept
with your usual autosuggestions binding. Continuing to type a prefix narrows the
existing candidates.

Ctrl-X followed by g (`^Xg`) cycles prepared candidates in the `emacs` and `viins`
keymaps by default. It wraps at the end without generating new text or starting
a daemon. The next prompt resets selection to the primary candidate. Disable
cycling before loading the plugin with `ZSH_GIT_GOOD_CYCLE_KEYBINDING=none`, or
set a persistent binding in configuration.

The parser accepts forms such as `git commit -m ` and
`command git commit -m `. It rejects shell operators/substitutions, completed
message arguments, `--amend`, `--fixup`, `--squash`, unrelated commands, and
cursors away from the end. Suggestions always describe the staged snapshot;
review commands using `-a` separately because Git can include unstaged tracked
changes when executing them.

### Inspect and tune

```zsh
zsh-git-good observe --cwd .
zsh-git-good status --cwd . --json
zsh-git-good fingerprint --cwd .
zsh-git-good candidates --cwd .
zsh-git-good explain --cwd . --json
zsh-git-good suggest --cwd . --buffer 'git commit -m ' --json

zsh-git-good setup customize \
  --set commit.capitalization=sentence \
  --set commit.line_length=72 \
  --set suggestions.candidate_count=2
zsh-git-good config show
zsh-git-good feedback useful --candidate 1 --cwd .
zsh-git-good feedback show --cwd .
```

Explicit `observe` schedules background work. Inspection commands report state
without starting generation. Feedback labels a currently prepared candidate and
retains scoped hashes and labels, rather than candidate text. Other labels are
`too-generic` and `incorrect`. New shells pick up keybinding changes; subsequent
observations pick up generation preferences.

### Pause, repair, and recover

```zsh
zsh-git-good disable --repo --cwd .
zsh-git-good enable --repo --cwd .
zsh-git-good snooze 30m --repo --cwd .
zsh-git-good enable --repo --cwd .

zsh-git-good doctor --json
zsh-git-good doctor --check
zsh-git-good doctor --fix
zsh-git-good undo list
zsh-git-good undo <transaction-id>
zsh-git-good daemon stop
```

Disable, enable, and snooze apply globally when `--repo` is omitted. Doctor
reports exact actions; `--check` verifies real normal/login shell startup, and
`--fix` makes supported repairs with backups. It preserves ambiguous shell
blocks, conflicting later edits, and unowned artifacts for manual review.
Stopping the daemon alone is temporary: the next enabled prompt can start it.

### Troubleshoot a quiet prompt

| Symptom | Check |
| --- | --- |
| No ghost text after staging | Return to a prompt, allow preparation to finish, then inspect `status --cwd . --json` and `candidates --cwd .`. |
| Plugin is inactive | Load zsh-autosuggestions first and run `doctor --check` in a fresh shell. |
| Candidates exist but the typed prefix has no match | Inspect `suggest --cwd . --buffer 'git commit -m prefix' --json`; typing does not request a new generation. |
| Suggestions remain hidden | Check disable/snooze state, index conflicts, unsupported command syntax, and any required-body policy. |
| Optional provider fails | Inspect `doctor --json`, provider settings, model availability, and the configured fallback; OpenAI requires a grant and has no fallback. |

The typing strategy stays quiet on failure. Administrative commands distinguish
pending generation, stale state, unmatched prefixes, provider errors, and
configuration problems without printing raw compiled context.

## 🛟 Operate it carefully

### Configuration and repository policy

Global TOML lives at `$XDG_CONFIG_HOME/zsh-git-good/config.toml`, falling back to
`$HOME/.config/zsh-git-good/config.toml`. `ZSH_GIT_GOOD_CONFIG` overrides that
path for testing or troubleshooting. Unknown keys and malformed values are
rejected. A representative configuration is:

```toml
[daemon]
idle_timeout = "15m"
max_active_repositories = 32
max_generation_concurrency = 2

[cache]
max_records = 512
max_bytes = 33554432
max_age = "168h"

[provider]
name = "deterministic"
timeout = "8s"
fallback = "deterministic"

[grounding]
ambiguity = "conservative"

[commit]
line_length = 72
capitalization = "lower"
body = "optional"

[suggestions]
candidate_count = 3

[learning]
enabled = true

[activity]
retention = "30m"
max_events = 256

[zsh]
cycle_keybinding = "^Xg"
cycle_keymaps = ["emacs", "viins"]
```

Repository policy uses `.zsh-git-good.toml` and only the supported `[commit]`
keys. For example:

```toml
[commit]
convention = "conventional"
types = ["feat", "fix", "test", "docs"]
scopes = ["api", "cli"]
scope_paths = ["internal/api=api", "cmd=cli"]
line_length = 72
capitalization = "lower"
body = "optional" # forbid, optional, or required
```

Policy participates in the candidate fingerprint. It cannot select providers,
read credentials, grant activity/cloud access, weaken redaction, or execute
commands. See [configuration](docs/CONFIGURATION.md) and
[repository policy](docs/POLICY.md) for the full grammar, bounds, and precedence.

### Providers and context

Background context compilation selects bounded staged paths and patch content,
nearby declarations, manifests, history/branch evidence, and consented derived
activity signals. Working-tree content is excluded. Common secret-pattern
redaction and untrusted-data framing apply before provider submission; redaction
cannot guarantee detection of every secret.

| Provider | Requirements and behavior | Validation boundary |
| --- | --- | --- |
| `deterministic` | Default; uses staged metadata and conservative textual facts, without a model or network. | Covered by the deterministic regression/evaluation path. |
| `deterministic-baseline` | Frozen metadata-template control for comparisons. | Useful for reproducible evaluation; not a separate interactive frontend. |
| `ollama` | Explicit model selection and an already available runtime at `http://127.0.0.1:11434`; no automatic model pull. | Documented small-model trials failed their local gate; model usefulness is not established by mock tests. |
| `openai` | Explicit model, environment credential, and provider-specific context grant; `fallback = "none"`. | Mock contract coverage; live compatibility and quality remain unverified. |

For Ollama, configure an already installed model:

```toml
[provider]
name = "ollama"
model = "your-installed-model"
timeout = "8s"
fallback = "deterministic" # or "none"

[ollama]
context_tokens = 4096
output_tokens = 256
cold_timeout = "30s"
keep_alive = "5m"
```

For OpenAI, select a model available to your account and disable fallback:

```toml
[provider]
name = "openai"
model = "your-openai-model"
timeout = "8s"
fallback = "none"
```

Then provide the credential in the environment and explicitly review/grant
context classes:

```zsh
export OPENAI_API_KEY='...'
zsh-git-good cloud preview --provider openai --cwd . --json
zsh-git-good cloud grant openai \
  --classes staged_diff,repository_context --confirm
zsh-git-good cloud revoke openai
```

Preview inspects bounded categories. A grant replaces the complete set of
allowed classes. Each HTTP attempt rechecks permission and the exact staged
state. Revocation invalidates cloud-derived cache records. Requests are
non-streaming with `store: false`; that setting is not a guarantee about all
provider-side data handling. Credentials are read at request time and are not
stored in configuration, prompts, or candidate records. See
[providers](docs/PROVIDERS.md), [context](docs/CONTEXT.md), and
[cloud controls](docs/CLOUD.md).

### Local privacy, storage, and freshness

The daemon normally listens at `$XDG_RUNTIME_DIR/zsh-git-good/daemon.sock`, with
a private XDG cache fallback. Its socket is `0600` inside a `0700` directory.
IPC is local, versioned, bounded, and deadline-limited. Normal typing performs
an exact-state lookup without compiling context or contacting a provider.

Candidate cache records contain generated message metadata and provenance;
they can reveal information derived from staged paths. Default retention is
512 records, 32 MiB, and seven days. Records are isolated by repository and
worktree, and malformed, expired, or excess records are collected. A narrow
publication race can leave an obsolete record, but an exact fingerprint/scope
lookup will not serve it for a different staged state.

Preferences, learning, feedback, lifecycle backups, and evaluation reports use
product-specific XDG locations. Local history reports and edited message files
can contain private text. Keep them outside public working trees and review
retention settings for sensitive repositories. Details are in
[privacy](docs/PRIVACY.md) and the [threat model](docs/THREAT-MODEL.md).

### Activity and Neovim

Activity collection starts disabled. Retention settings alone do not grant it:

```zsh
zsh-git-good permissions
zsh-git-good permissions enable activity
zsh-git-good permissions revoke activity
```

With consent, asynchronous shell hooks emit allowlisted Git, test, and build
classes, exit status, and duration. They retain no command arguments,
environment, standard input, or terminal output. Events are bounded,
repository/worktree-scoped, and memory-only. Grant revocation, clearing, or
expiry invalidates suggestions derived from the old activity state.

Neovim 0.10+ can contribute file events and capped diagnostic severity counts.
Add this checkout to its runtime path, grant activity, then configure:

```lua
require("zsh-git-good").setup({
  file_events = true,
  diagnostics = true,
})
```

The adapter emits metadata such as buffer paths and session IDs; it reads no
buffer content, calls no provider, and renders no suggestions. Installers do
not install the Lua adapter. See [activity](docs/ACTIVITY.md) and
[Neovim setup](docs/NEOVIM.md).

### Learning, feedback, and commit bodies

Local style learning is enabled by default. It aggregates bounded type/scope,
subject-shape, and limited verb statistics from completed local commits, then
reranks candidates that already passed policy and grounding. It does not retain
commit subjects/bodies, diffs, remotes, credentials, or provider grants in the
learning profile. Linked worktrees share a profile while their candidate caches
remain separate.

```zsh
zsh-git-good learning status --cwd .
zsh-git-good learning inspect --cwd . --json
zsh-git-good learning disable --cwd .
zsh-git-good learning reset --cwd .
zsh-git-good learning export --cwd . > profile.json
zsh-git-good learning import --cwd . --file profile.json
```

Importing from a known matching clone requires `--confirm`. Learning statistics
and explicit usefulness feedback are separate from human evaluation ratings.
See [learning](docs/LEARNING.md).

For a body, use the explicit editor workflow:

```zsh
zsh-git-good compose --cwd .
zsh-git-good compose --cwd . --candidate 1 --json
```

Compose proposes a prepared subject and bounded staged-path body, invokes the
configured Git editor, and rechecks staged identity and policy afterwards. It
reports an owner-only message-file path. If state or policy changes during
editing, the file is retained for review. User edits remain user-authored; they
are not relabeled as automatically grounded claims. See [compose](docs/COMPOSE.md).

### Updates, removal, and recovery

There is no automatic updater. Review the desired source revision and rebuild.
For an installation managed by setup:

```zsh
cd /path/to/zsh-git-good
git pull --ff-only
make build
.build/zsh-git-good setup upgrade --source "$PWD"
zsh-git-good version --json
zsh-git-good doctor --check
```

For a manual installation, rerun `scripts/install.sh` with the same prefix and
start a fresh shell. Stop an older daemon with `zsh-git-good daemon stop` so the
next prompt starts the installed build.

Remove a managed installation with:

```zsh
zsh-git-good uninstall
```

The command retains preferences and recovery data and prints the private
helper's exact undo command, which works after the installed binary is removed.
An already-open shell can unload its hooks with `zsh_git_good_unload`.
`zsh-git-good uninstall --purge-local-data` explicitly removes product-owned
local data and backups and therefore does not retain that recovery path.

For a manual installation, remove its source line from `.zshrc`, unload or
restart the shell, and run:

```zsh
sh scripts/uninstall.sh --prefix "$HOME/.local"
# Optional: also remove the standard product-specific XDG data directories.
sh scripts/uninstall.sh --prefix "$HOME/.local" --purge-local-data
```

The script does not guess custom `ZSH_GIT_GOOD_*` directories. Managed purge
validates dedicated product paths and refuses ambiguous ownership. Repository
policy files remain in their repositories. See [installation](docs/INSTALLATION.md)
and the [lifecycle guide](docs/DOGFOOD-IMPLEMENTATION.md).

### Snapshots and evaluation evidence

Local snapshots cross-compile Linux/macOS `amd64` and `arm64` archives and
produce checksums and an SPDX SBOM. Packaging includes the executable, plugin,
README, changelog, and available license/notices files. The manual release
preparation workflow generates reviewable archives and a Homebrew formula; it
does not publish them.

```zsh
make release-snapshot VERSION=0.1.0-rc.1 DIST=dist/0.1.0-rc.1
(cd dist/0.1.0-rc.1 && sha256sum -c checksums.txt)
sh scripts/install-release.sh \
  --archive dist/0.1.0-rc.1/zsh-git-good_0.1.0-rc.1_linux-amd64.tar.gz \
  --prefix "$HOME/.local"
```

Verify an independently obtained archive against a reviewed checksum before
installation. The archive installer restricts member names/types and stages
files privately. Snapshots remain validation artifacts pending the license and
release requirements described below.

Evaluate the synthetic corpus or replay eligible local history:

```zsh
zsh-git-good evaluate --fixtures --json
zsh-git-good evaluate --fixtures --partition held-out --json
zsh-git-good evaluate --repo /absolute/path/to/repository --limit 50 --json
```

The current synthetic corpus has 8 development and 19 held-out cases. Evaluation
uses the actual background generation, grounding, ranking, cache-publication,
and exact-lookup path, with separate socket and terminal tests. Reports are
private JSON/Markdown under the XDG state directory and omit raw replay diffs.
Automatic checks do not prove semantic usefulness or user preference. The
project also provides a blinded human-comparison workflow; see
[evaluation](docs/EVALUATION.md) and [reliability](docs/RELIABILITY.md).

## 📚 Learn more

| Topic | Documentation |
| --- | --- |
| Product scope and runtime design | [Product](docs/PRODUCT.md), [architecture](docs/ARCHITECTURE.md) |
| Installation, snapshots, and everyday administration | [Installation](docs/INSTALLATION.md), [setup/repair/removal](docs/DOGFOOD-IMPLEMENTATION.md) |
| Preferences and message rules | [Configuration](docs/CONFIGURATION.md), [repository policy](docs/POLICY.md) |
| Candidate evidence and generation | [Context](docs/CONTEXT.md), [grounding](docs/GROUNDING.md), [providers](docs/PROVIDERS.md) |
| Optional data sources and permissions | [Cloud](docs/CLOUD.md), [activity](docs/ACTIVITY.md), [Neovim](docs/NEOVIM.md), [learning](docs/LEARNING.md) |
| Commit bodies | [Compose](docs/COMPOSE.md) |
| Security and validation boundaries | [Privacy](docs/PRIVACY.md), [threat model](docs/THREAT-MODEL.md), [evaluation](docs/EVALUATION.md), [reliability](docs/RELIABILITY.md) |
| Release preparation and licensing | [Release checklist](docs/RELEASE-CHECKLIST.md), [license review](docs/LICENSE-REVIEW.md), [changelog](CHANGELOG.md), [third-party notices](THIRD_PARTY_NOTICES) |

## 🌟 Contributing

The repository contains a Go helper/daemon, the Zsh strategy plugin, and an
optional Lua activity emitter. Preserve exact staged-state matching, bounded
work, shell-safe output, explicit provider permissions, and user-controlled
execution when changing these components.

Run the relevant checks first, then the full suite before a broad change:

```zsh
make build
make test lint
go test -race ./...
make fuzz FUZZ_TIME=3s
make bench
```

`make test` covers Go packages, Python packaging/qualification tests, setup,
real-Zsh integration, synthetic evaluation, release installation, installed
plugin dogfooding, a bounded multi-shell soak, and lifecycle rehearsals. Neovim
runs when available and reports a skip otherwise. Point tests at an installed
autosuggestions source when it is outside the default location:

```zsh
export ZSH_AUTOSUGGESTIONS_SOURCE=/absolute/path/zsh-autosuggestions.zsh
TERM=xterm-256color make test lint
```

Useful narrower targets include `test-go`, `test-zsh`, `test-eval`,
`test-reliability`, `test-nvim`, `test-install`, `test-dogfood`, `test-soak`, and
`test-lifecycle`. `make lint` runs Go vet, formatting and shell syntax checks,
and rejects `eval` or a `git` override in product paths. Run broad suites
sequentially when checking timing-sensitive behavior.

`make test-live-ollama` is explicitly opt-in. It needs a separately started
loopback runtime and an already installed model named by
`ZSH_GIT_GOOD_LIVE_OLLAMA_MODEL`. Ordinary checks use local fixtures/mocks and
require neither model downloads nor cloud generation. See
[reliability](docs/RELIABILITY.md) for what each gate establishes.

## License and release status

This repository contains an RC1-quality V1 implementation and local release
preparation tooling. The deterministic provider is the validated default.
Documented Ollama trials did not pass their local evaluation gate, and OpenAI
has mock contract coverage only. Cross-compilation and local checks do not
establish hosted CI success, public distribution, or live-provider usefulness.

No project license has been selected, and the repository has no `LICENSE` file.
Publishing or redistributing artifacts remains blocked until the maintainer
adds one. Do not treat generated snapshots or a prepared formula as a published
release. See [license review](docs/LICENSE-REVIEW.md),
[third-party notices](THIRD_PARTY_NOTICES), and [changelog](CHANGELOG.md).
