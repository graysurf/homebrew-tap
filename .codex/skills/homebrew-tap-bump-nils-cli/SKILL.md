---
name: homebrew-tap-bump-nils-cli
description: Bump Formula/nils-cli.rb to a specified or latest nils-cli GitHub release.
---

# Homebrew Tap: Bump nils-cli

## Contract

Prereqs:

- Run inside this `homebrew-tap` git work tree.
- `gh` authenticated with access to `graysurf/nils-cli` releases.
- `python3` available on `PATH`.
- `semantic-commit` available on `PATH` (install via `brew install nils-cli`).
- `git-scope` available on `PATH` (required by `semantic-commit`).
- Git remote configured + push access (workflow ends with `git push`).
- Optional: `ruby` for `ruby -c` formula syntax check.
- Optional: `brew` for `brew style` (skipped if missing).

Inputs:

- `--version <vX.Y.Z|X.Y.Z>`: target release tag to bump to.
- `--latest`: resolve the latest GitHub release tag.
- Optional:
  - `--repo <OWNER/REPO>` (default: `graysurf/nils-cli`)
  - `--formula <path>` (default: `Formula/nils-cli.rb`)
  - `--dry-run`: print a unified diff; do not write files.
  - `--no-ruby-check`: skip `ruby -c` check.
  - `--no-style`: skip `brew style` check.
  - `--no-commit`: do not commit the formula bump.
  - `--no-push`: do not push commits/tags.
  - `--no-tap-tag`: do not create/push a tap git tag (release trigger).
  - `--tap-tag <tag>`: override tap git tag name (default: `nils-cli-<tag>`).
  - `--tap-tag-prefix <pfx>`: prefix for tap git tag (default: `nils-cli-`).
  - `--remote <name>`: git remote to push to (default: `origin`).

Outputs:

- Updates `Formula/nils-cli.rb` URLs + `sha256` for:
  - `aarch64-apple-darwin`
  - `x86_64-apple-darwin`
  - `aarch64-unknown-linux-gnu`
  - `x86_64-unknown-linux-gnu`
- Downloads `*.sha256` release assets into `$CODEX_HOME/out/homebrew-tap/nils-cli/<tag>/`.
- Commits the formula bump with `semantic-commit` (skipped for `--dry-run`, `--no-commit`, or no-op bumps).
- Pushes the commit to the configured remote (skipped for `--no-push`).
- Creates + pushes a tap git tag (default: `nils-cli-<tag>`; e.g. `nils-cli-v0.1.6`) to trigger GitHub CI to create the corresponding GitHub Release (skipped for `--no-tap-tag` or `--no-push`).

Exit codes:

- `0`: success (including already up-to-date)
- `1`: update failed
- `2`: usage error

Failure modes:

- Missing prerequisites (`gh`, `python3`) or `gh` not authenticated.
- Missing `semantic-commit` or `git-scope` (required for commit step).
- Target release tag not found or missing `*.sha256` assets.
- `Formula/nils-cli.rb` format changed (cannot find expected `url` + `sha256` pairs).
- Working tree has local changes (script refuses to run to avoid committing unrelated diffs).
- `git push` fails (auth, missing upstream, branch protections).
- Tap tag already exists on remote with a different target (push rejected).

## Scripts (only entrypoints)

- `.codex/skills/homebrew-tap-bump-nils-cli/scripts/homebrew-tap-bump-nils-cli.sh`

## Workflow

- Bump to a specific version:
  - `bash .codex/skills/homebrew-tap-bump-nils-cli/scripts/homebrew-tap-bump-nils-cli.sh --version v0.1.3`
- Bump to latest:
  - `bash .codex/skills/homebrew-tap-bump-nils-cli/scripts/homebrew-tap-bump-nils-cli.sh --latest`
- After the script pushes the tap tag, GitHub Actions will create a GitHub Release for that tag (default tag pattern: `nils-cli-v*`; workflow: `.github/workflows/release.yml`).
