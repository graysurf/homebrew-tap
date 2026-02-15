# graysurf Homebrew tap

## nils-cli

A Rust CLI workspace scaffold for building multiple independently packaged binaries. See: [nils-cli](https://github.com/graysurf/nils-cli)

### Included CLIs

#### API testing stack

- `api-rest`: REST request runner from file-based JSON specs, with history + Markdown reports.
- `api-gql`: GraphQL operation runner for `.graphql` files (variables, history, reports, schema).
- `api-test`: Suite runner that orchestrates REST/GraphQL cases and outputs JSON (optional JUnit).

#### Git tooling

- `git-scope`: Git change inspector (tracked/staged/unstaged/all/commit) with optional file output.
- `git-cli`: Git tools dispatcher (utils/reset/commit/branch/ci/open).
- `git-summary`: Per-author contribution summaries over preset or custom date ranges.
- `git-lock`: Label-based commit locks per repo (lock/list/diff/unlock/tag).

#### Agent and workflow tooling

- `agent-docs`: Deterministic policy-document resolver for agent workflows (`resolve`, `contexts`, `add`, `baseline`).
- `agentctl`: Provider-neutral control plane (`provider`, `diag`, `debug`, `workflow`, `automation`).
- `codex-cli`: Helper CLI for Codex workflows (auth, diagnostics, rate-limit checks, Starship snippets).
- `semantic-commit`: Helper CLI for generating staged context and creating semantic commits.
- `plan-tooling`: Plan Format v1 tooling CLI (to-json/validate/batches/scaffold).

#### Automation and utility CLIs

- `macos-agent`: macOS desktop automation primitives for app/window discovery, input actions, screenshot, and wait helpers.
- `fzf-cli`: Interactive `fzf` toolbox for files, Git, processes, and ports.
- `memo-cli`: Capture-first memo workflow CLI with agent enrichment loop (`add`, `list`, `search`, `report`, `fetch`, `apply`).
- `image-processing`: Batch image transformation CLI (convert/resize/rotate/crop/pad/optimize).
- `screen-record`: macOS ScreenCaptureKit + Linux (X11) recorder for a single window or display with optional audio.
- `cli-template`: Minimal template binary for validating workspace packaging patterns.

## Install

```bash
brew tap graysurf/tap
brew install nils-cli
```

## Zsh aliases (optional)

`nils-cli` ships an opt-in Zsh aliases file (designed to avoid clobbering user-defined aliases/functions).

After `brew install nils-cli`, add this to your `~/.zshrc`:

```bash
# nils-cli aliases (optional)
if [[ -f "$(brew --prefix nils-cli)/share/zsh/site-functions/aliases.zsh" ]]; then
  source "$(brew --prefix nils-cli)/share/zsh/site-functions/aliases.zsh"
fi
```

## Bash completion + aliases (optional)

`nils-cli` ships Bash completion scripts for each CLI, plus an opt-in Bash aliases file (for `gs*`/`cx*`/`ff*`).

1) Enable Homebrew bash-completion (macOS/Linuxbrew):

```bash
brew install bash-completion@2
```

Then add this to your `~/.bashrc` (or `~/.bash_profile`, depending on your setup):

```bash
# Homebrew bash completion
if command -v brew >/dev/null 2>&1; then
  BREW_PREFIX="$(brew --prefix)"
  [[ -r "${BREW_PREFIX}/etc/profile.d/bash_completion.sh" ]] && . "${BREW_PREFIX}/etc/profile.d/bash_completion.sh"
fi
```

2) (Optional) Enable `nils-cli` Bash aliases:

```bash
# nils-cli aliases (optional)
if [[ -f "$(brew --prefix nils-cli)/share/nils-cli/aliases.bash" ]]; then
  source "$(brew --prefix nils-cli)/share/nils-cli/aliases.bash"
fi
```

## Install (Script)

The install script supports macOS and Linux. It will install Homebrew (Linuxbrew on Linux) if missing.

From a cloned repo:

```bash
bash scripts/install.sh
```

One-liner (review before running):

```bash
curl -fsSL https://raw.githubusercontent.com/graysurf/homebrew-tap/main/scripts/install.sh | bash
```

## Upgrade

```bash
brew upgrade nils-cli
```

## CI

- macOS workflow: `.github/workflows/ci-macos.yml`
- Linux workflow: `.github/workflows/ci-linux.yml`
- Shared workflow: `.github/workflows/brew-test.yml`
