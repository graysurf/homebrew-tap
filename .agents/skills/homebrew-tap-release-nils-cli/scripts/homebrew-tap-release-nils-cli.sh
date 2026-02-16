#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  homebrew-tap-release-nils-cli.sh (--version <vX.Y.Z|X.Y.Z> | --latest) [options]

Release `nils-cli` via the shared bump script.

Notes:
  - This entrypoint locks package settings:
    --package nils-cli
    --repo graysurf/nils-cli
    --formula Formula/nils-cli.rb
  - Forwarded options include:
    --version, --latest, --wait-release-timeout, --wait-release-interval,
    --release-workflow, --assume-no-release-ci, --no-wait-release, --dry-run,
    --no-ruby-check, --no-style, --no-commit, --no-push, --no-tap-tag,
    --tap-tag, --tap-tag-prefix, --remote
USAGE
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
shared_script="${script_dir}/../../_shared/homebrew-tap-release/homebrew-tap-bump-formula.sh"

if [[ ! -x "$shared_script" ]]; then
  echo "error: shared script is missing or not executable: $shared_script" >&2
  exit 1
fi

for arg in "$@"; do
  case "$arg" in
    --package|--repo|--formula|--asset-prefix)
      echo "error: $arg is fixed by this entrypoint and cannot be overridden" >&2
      exit 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      :
      ;;
  esac
done

exec bash "$shared_script" \
  --package nils-cli \
  --repo graysurf/nils-cli \
  --formula Formula/nils-cli.rb \
  "$@"
