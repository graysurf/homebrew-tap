#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skill_root="$(cd "${script_dir}/.." && pwd)"
entrypoint="${skill_root}/scripts/homebrew-tap-release-nils-cli.sh"
shared_script="${skill_root}/../_shared/homebrew-tap-release/homebrew-tap-bump-formula.sh"

if [[ ! -f "${skill_root}/SKILL.md" ]]; then
  echo "error: missing SKILL.md" >&2
  exit 1
fi
if [[ ! -f "$entrypoint" ]]; then
  echo "error: missing scripts/homebrew-tap-release-nils-cli.sh" >&2
  exit 1
fi
if [[ ! -x "$entrypoint" ]]; then
  echo "error: entrypoint is not executable: $entrypoint" >&2
  exit 1
fi
if [[ ! -x "$shared_script" ]]; then
  echo "error: shared script missing or not executable: $shared_script" >&2
  exit 1
fi

help_out="$(bash "$entrypoint" --help)"
if [[ "$help_out" != *"Release \`nils-cli\` via the shared bump script."* ]]; then
  echo "error: help output missing nils-cli description" >&2
  exit 1
fi

set +e
bash "$entrypoint" --package other >/dev/null 2>&1
status=$?
set -e
if [[ "$status" -ne 2 ]]; then
  echo "error: expected locked --package to fail with exit 2; got $status" >&2
  exit 1
fi

echo "ok: project skill smoke checks passed"
