---
name: homebrew-tap-bump-nils-cli
description: Bump a Homebrew formula to a specified or latest GitHub release (defaults to nils-cli).
---

# Homebrew Tap: Bump Formula Release

## Contract

Prereqs:

- Run inside this `homebrew-tap` git work tree.
- `gh` authenticated with access to source repo releases.
- `python3` available on `PATH`.
- `brew` available on `PATH` (used for `brew style` and post-publish local upgrade).
- `semantic-commit` available on `PATH` (install via `brew install nils-cli`).
- `git-scope` optional (`semantic-commit` falls back to `git show` summary).
- Git remote configured + push access (workflow ends with `git push`).
- For `--version`, the specified source git tag must already exist in source repo.
- Optional: `ruby` for `ruby -c` formula syntax check.

Inputs:

- `--version <vX.Y.Z|X.Y.Z>`: target release tag to bump to.
- `--latest`: resolve the latest GitHub release tag.
- Optional:
  - `--package <name>` (default: `nils-cli`)
  - `--asset-prefix <name>` (default: `<package>`)
  - `--repo <OWNER/REPO>` (default: `graysurf/nils-cli`)
  - `--formula <path>` (default: `Formula/<package>.rb`)
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
  - `--tap-tag <tag>`: override tap git tag name (default: `<package>-<tag>`).
  - `--tap-tag-prefix <pfx>`: prefix for tap git tag (default: `<package>-`).
  - `--remote <name>`: git remote to push to (default: `origin`).

Outputs:

- Updates target formula URLs + `sha256` for:
  - `aarch64-apple-darwin`
  - `x86_64-apple-darwin`
  - `aarch64-unknown-linux-gnu`
  - `x86_64-unknown-linux-gnu`
- Verifies the source tag exists before bumping.
- Waits for GitHub release readiness (`release` exists, not draft, all required `tar.gz` + `.sha256` assets present).
- If release page is missing and no active release CI run is detected, prompts whether to keep waiting (or uses `--assume-no-release-ci`).
- Downloads `*.sha256` release assets into `$AGENTS_HOME/out/homebrew-tap/<package>/<tag>/`.
- Commits the formula bump with `semantic-commit` (skipped for `--dry-run`, `--no-commit`, or no-op bumps).
- Pushes the commit to the configured remote (skipped for `--no-push`).
- Creates + pushes a tap git tag (default: `<package>-<tag>`; e.g. `nils-cli-v0.1.6`) to trigger GitHub CI to create the corresponding GitHub Release (skipped for `--no-tap-tag` or `--no-push`).
- After publish (`git push`), runs `brew update && brew upgrade <package>` to ensure local machine installs the latest binary.

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
- Target formula format changed (cannot find expected `url` + `sha256` pairs).
- Working tree has local changes (script refuses to run to avoid committing unrelated diffs).
- `git push` fails (auth, missing upstream, branch protections).
- Tap tag already exists on remote with a different target (push rejected).
- Post-publish local upgrade fails (`brew update` or `brew upgrade <package>`).

## Scripts (only entrypoints)

- `.agents/skills/homebrew-tap-bump-nils-cli/scripts/homebrew-tap-bump-nils-cli.sh`

## Workflow

- Bump to a specific version:
  - `bash .agents/skills/homebrew-tap-bump-nils-cli/scripts/homebrew-tap-bump-nils-cli.sh --version v0.1.3`
- Bump to latest:
  - `bash .agents/skills/homebrew-tap-bump-nils-cli/scripts/homebrew-tap-bump-nils-cli.sh --latest`
- Bump `agent-workspace-launcher`:
  - `bash .agents/skills/homebrew-tap-bump-nils-cli/scripts/homebrew-tap-bump-nils-cli.sh --package agent-workspace-launcher --repo graysurf/agent-workspace-launcher --formula Formula/agent-workspace-launcher.rb --version v1.1.0 --release-workflow release-brew.yml`
- Release still being published (wait up to 30 minutes, poll every 30 seconds):
  - `bash .agents/skills/homebrew-tap-bump-nils-cli/scripts/homebrew-tap-bump-nils-cli.sh --version v0.1.3 --wait-release-timeout 1800`
- After the script pushes the tap tag, GitHub Actions will create a GitHub Release for that tag (workflow: `.github/workflows/release.yml`).
- After publish completes, the script runs `brew update && brew upgrade <package>` so local install is refreshed to latest binary.
