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

Outputs:

- Updates `Formula/nils-cli.rb` URLs + `sha256` for:
  - `aarch64-apple-darwin`
  - `x86_64-apple-darwin`
  - `aarch64-unknown-linux-gnu`
  - `x86_64-unknown-linux-gnu`
- Downloads `*.sha256` release assets into `$CODEX_HOME/out/homebrew-tap/nils-cli/<tag>/`.

Exit codes:

- `0`: success (including already up-to-date)
- `1`: update failed
- `2`: usage error

Failure modes:

- Missing prerequisites (`gh`, `python3`) or `gh` not authenticated.
- Target release tag not found or missing `*.sha256` assets.
- `Formula/nils-cli.rb` format changed (cannot find expected `url` + `sha256` pairs).

## Scripts (only entrypoints)

- `.codex/skills/homebrew-tap-bump-nils-cli/scripts/homebrew-tap-bump-nils-cli.sh`

## Workflow

- Bump to a specific version:
  - `bash .codex/skills/homebrew-tap-bump-nils-cli/scripts/homebrew-tap-bump-nils-cli.sh --version v0.1.3`
- Bump to latest:
  - `bash .codex/skills/homebrew-tap-bump-nils-cli/scripts/homebrew-tap-bump-nils-cli.sh --latest`

