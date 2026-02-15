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
- `brew` available on `PATH` (used for `brew style` and post-publish local upgrade).
- `semantic-commit` available on `PATH` (install via `brew install nils-cli`).
- `git-scope` available on `PATH` (required by `semantic-commit`).
- Git remote configured + push access (workflow ends with `git push`).
- For `--version`, the specified source git tag must already exist in `graysurf/nils-cli`.
- Optional: `ruby` for `ruby -c` formula syntax check.

Inputs:

- `--version <vX.Y.Z|X.Y.Z>`: target release tag to bump to.
- `--latest`: resolve the latest GitHub release tag.
- Optional:
  - `--repo <OWNER/REPO>` (default: `graysurf/nils-cli`)
  - `--formula <path>` (default: `Formula/nils-cli.rb`)
  - `--wait-release-timeout <seconds>`: max wait for release readiness (default: `1800`, `0` means no timeout).
  - `--wait-release-interval <seconds>`: polling interval while waiting release readiness (default: `30`).
  - `--release-workflow <name>`: workflow file/name used to detect release CI runs (default: `release.yml`).
  - `--assume-no-release-ci`: continue waiting without interactive prompt when no release CI run is found.
  - `--no-wait-release`: fail fast if release page/assets are not ready.
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
- Verifies the source tag exists before bumping.
- Waits for GitHub release readiness (`release` exists, not draft, all required `tar.gz` + `.sha256` assets present).
- If release page is missing and no active release CI run is detected, prompts whether to keep waiting (or uses `--assume-no-release-ci`).
- Downloads `*.sha256` release assets into `$AGENTS_HOME/out/homebrew-tap/nils-cli/<tag>/`.
- Commits the formula bump with `semantic-commit` (skipped for `--dry-run`, `--no-commit`, or no-op bumps).
- Pushes the commit to the configured remote (skipped for `--no-push`).
- Creates + pushes a tap git tag (default: `nils-cli-<tag>`; e.g. `nils-cli-v0.1.6`) to trigger GitHub CI to create the corresponding GitHub Release (skipped for `--no-tap-tag` or `--no-push`).
- After publish (`git push`), runs `brew update && brew upgrade nils-cli` to ensure local machine installs the latest binary.

Exit codes:

- `0`: success (including already up-to-date)
- `1`: update failed
- `2`: usage error

Failure modes:

- Missing prerequisites (`gh`, `python3`) or `gh` not authenticated.
- Missing `semantic-commit` or `git-scope` (required for commit step).
- Target source git tag not found.
- Release readiness timeout reached before required assets become available.
- Release page missing with no active CI run and user declines to continue waiting.
- Non-interactive shell cannot prompt when release page missing + no active CI run (unless `--assume-no-release-ci` is set).
- `Formula/nils-cli.rb` format changed (cannot find expected `url` + `sha256` pairs).
- Working tree has local changes (script refuses to run to avoid committing unrelated diffs).
- `git push` fails (auth, missing upstream, branch protections).
- Tap tag already exists on remote with a different target (push rejected).
- Post-publish local upgrade fails (`brew update` or `brew upgrade nils-cli`).

## Scripts (only entrypoints)

- `.agents/skills/homebrew-tap-bump-nils-cli/scripts/homebrew-tap-bump-nils-cli.sh`

## Workflow

- Bump to a specific version:
  - `bash .agents/skills/homebrew-tap-bump-nils-cli/scripts/homebrew-tap-bump-nils-cli.sh --version v0.1.3`
- Bump to latest:
  - `bash .agents/skills/homebrew-tap-bump-nils-cli/scripts/homebrew-tap-bump-nils-cli.sh --latest`
- Release still being published (wait up to 30 minutes, poll every 30 seconds):
  - `bash .agents/skills/homebrew-tap-bump-nils-cli/scripts/homebrew-tap-bump-nils-cli.sh --version v0.1.3 --wait-release-timeout 1800`
- After the script pushes the tap tag, GitHub Actions will create a GitHub Release for that tag (default tag pattern: `nils-cli-v*`; workflow: `.github/workflows/release.yml`).
- After publish completes, the script runs `brew update && brew upgrade nils-cli` so local install is refreshed to latest binary.
