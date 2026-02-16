---
name: homebrew-tap-release-agent-workspace-launcher
description: Release Homebrew formula agent-workspace-launcher using shared bump script.
---

# Homebrew Tap Release Agent Workspace Launcher

## Contract

Prereqs:

- Run inside this `homebrew-tap` git work tree.
- `gh`, `python3`, `git`, `brew`, and `semantic-commit` available on `PATH`.
- Push permission to tap remote and source repo release visibility.
- Shared bump script exists at:
  `.agents/skills/_shared/homebrew-tap-release/homebrew-tap-bump-formula.sh`

Inputs:

- Required:
  - `--version <vX.Y.Z|X.Y.Z>` or `--latest`
- Optional (forwarded to shared script):
  - `--wait-release-timeout <seconds>`
  - `--wait-release-interval <seconds>`
  - `--assume-no-release-ci`
  - `--no-wait-release`
  - `--dry-run`
  - `--no-ruby-check`
  - `--no-style`
  - `--no-commit`
  - `--no-push`
  - `--no-tap-tag`
  - `--tap-tag <tag>`
  - `--tap-tag-prefix <pfx>`
  - `--remote <name>`
- Disallowed overrides (this skill locks target package/workflow):
  - `--package`
  - `--repo`
  - `--formula`
  - `--asset-prefix`
  - `--release-workflow`

Outputs:

- Bumps only `Formula/agent-workspace-launcher.rb` to the target source release.
- Wrapper fixes release workflow to `release-brew.yml`.
- Commits/pushes/tagging behavior follows forwarded flags from shared script.
- Post-publish performs `brew update && brew upgrade agent-workspace-launcher` unless push is disabled.

Exit codes:

- `0`: success
- `1`: failure
- `2`: usage error

Failure modes:

- Missing prerequisites or missing shared script.
- Shared script validation failure (tag not found, release assets not ready, formula format mismatch, push/tag failure).
- User passes locked arguments (`--package`, `--repo`, `--formula`, `--asset-prefix`, `--release-workflow`).

## Scripts (only entrypoints)

- `<PROJECT_ROOT>/.agents/skills/homebrew-tap-release-agent-workspace-launcher/scripts/homebrew-tap-release-agent-workspace-launcher.sh`

## Workflow

1. Run wrapper skill entrypoint with `--version` or `--latest`.
2. Wrapper forwards supported options to shared script and injects:
   `--package agent-workspace-launcher --repo graysurf/agent-workspace-launcher --formula Formula/agent-workspace-launcher.rb --release-workflow release-brew.yml`.
3. Shared script performs release readiness checks, formula update, commit/push/tag, and local upgrade.
