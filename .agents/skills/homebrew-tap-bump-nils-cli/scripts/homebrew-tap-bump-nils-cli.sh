#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  homebrew-tap-bump-nils-cli.sh (--version <vX.Y.Z|X.Y.Z> | --latest) [options]

Options:
  --package <name>        Homebrew formula/package name (default: nils-cli)
  --asset-prefix <name>   Release asset filename prefix (default: <package>)
  --repo <OWNER/REPO>     GitHub repo (default: graysurf/nils-cli)
  --formula <path>        Formula path (default: Formula/<package>.rb)
  --wait-release-timeout <seconds>
                          Wait timeout for release readiness (default: 1800; 0 = no timeout)
  --wait-release-interval <seconds>
                          Poll interval while waiting release readiness (default: 30)
  --release-workflow <name>
                          Workflow filename/name used to detect release CI run (default: release.yml)
  --assume-no-release-ci  Continue waiting without prompt when no release CI run is found
  --no-wait-release       Fail fast if release page/assets are not ready
  --dry-run               Print unified diff; do not write
  --no-ruby-check         Skip `ruby -c` validation
  --no-style              Skip `brew style` validation
  --no-commit             Skip committing the formula bump
  --no-push               Skip pushing commits/tags
  --no-tap-tag            Skip creating/pushing a tap git tag (release trigger)
  --tap-tag <tag>         Override tap git tag name (default: <package>-<tag>)
  --tap-tag-prefix <pfx>  Prefix for tap git tag (default: <package>-)
  --remote <name>         Git remote to push to (default: origin)
  -h, --help              Show help

Notes:
  - Requires the target git tag to exist in the source repo.
  - Waits until release page is usable (not draft + required binaries/sha256 assets present).
  - Downloads `*.sha256` assets into: $AGENTS_HOME/out/homebrew-tap/<package>/<tag>/
  - Pushing the tap tag triggers GitHub CI to create a GitHub Release.
  - After publishing (`git push`), runs: brew update && brew upgrade <package>
USAGE
}

package="nils-cli"
asset_prefix=""
repo="graysurf/nils-cli"
formula_rel=""
tag=""
dry_run="false"
latest="false"
wait_release="true"
wait_release_timeout="1800"
wait_release_interval="30"
release_workflow="release.yml"
assume_no_release_ci="false"
run_ruby_check="true"
run_brew_style="true"
run_commit="true"
run_push="true"
run_tap_tag="true"
tap_tag=""
tap_tag_prefix=""
remote="origin"

while [[ $# -gt 0 ]]; do
  case "${1:-}" in
    --package)
      if [[ $# -lt 2 ]]; then
        echo "error: --package requires a value" >&2
        usage >&2
        exit 2
      fi
      package="${2:-}"
      shift 2
      ;;
    --asset-prefix)
      if [[ $# -lt 2 ]]; then
        echo "error: --asset-prefix requires a value" >&2
        usage >&2
        exit 2
      fi
      asset_prefix="${2:-}"
      shift 2
      ;;
    --version)
      if [[ $# -lt 2 ]]; then
        echo "error: --version requires a value" >&2
        usage >&2
        exit 2
      fi
      tag="${2:-}"
      shift 2
      ;;
    --latest)
      latest="true"
      shift
      ;;
    --repo)
      if [[ $# -lt 2 ]]; then
        echo "error: --repo requires a value" >&2
        usage >&2
        exit 2
      fi
      repo="${2:-}"
      shift 2
      ;;
    --formula)
      if [[ $# -lt 2 ]]; then
        echo "error: --formula requires a path" >&2
        usage >&2
        exit 2
      fi
      formula_rel="${2:-}"
      shift 2
      ;;
    --wait-release-timeout)
      if [[ $# -lt 2 ]]; then
        echo "error: --wait-release-timeout requires seconds" >&2
        usage >&2
        exit 2
      fi
      wait_release_timeout="${2:-}"
      shift 2
      ;;
    --wait-release-interval)
      if [[ $# -lt 2 ]]; then
        echo "error: --wait-release-interval requires seconds" >&2
        usage >&2
        exit 2
      fi
      wait_release_interval="${2:-}"
      shift 2
      ;;
    --release-workflow)
      if [[ $# -lt 2 ]]; then
        echo "error: --release-workflow requires a value" >&2
        usage >&2
        exit 2
      fi
      release_workflow="${2:-}"
      shift 2
      ;;
    --assume-no-release-ci)
      assume_no_release_ci="true"
      shift
      ;;
    --no-wait-release)
      wait_release="false"
      shift
      ;;
    --dry-run)
      dry_run="true"
      shift
      ;;
    --no-ruby-check)
      run_ruby_check="false"
      shift
      ;;
    --no-style)
      run_brew_style="false"
      shift
      ;;
    --no-commit)
      run_commit="false"
      shift
      ;;
    --no-push)
      run_push="false"
      shift
      ;;
    --no-tap-tag)
      run_tap_tag="false"
      shift
      ;;
    --tap-tag)
      if [[ $# -lt 2 ]]; then
        echo "error: --tap-tag requires a value" >&2
        usage >&2
        exit 2
      fi
      tap_tag="${2:-}"
      shift 2
      ;;
    --tap-tag-prefix)
      if [[ $# -lt 2 ]]; then
        echo "error: --tap-tag-prefix requires a value" >&2
        usage >&2
        exit 2
      fi
      tap_tag_prefix="${2:-}"
      shift 2
      ;;
    --remote)
      if [[ $# -lt 2 ]]; then
        echo "error: --remote requires a value" >&2
        usage >&2
        exit 2
      fi
      remote="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown argument: ${1:-}" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$tag" && "$latest" != "true" ]]; then
  echo "error: must provide --version or --latest" >&2
  usage >&2
  exit 2
fi

if [[ -z "$package" || "$package" =~ [[:space:]] ]]; then
  echo "error: --package must be a non-empty formula name without spaces" >&2
  exit 2
fi

if [[ -z "$asset_prefix" ]]; then
  asset_prefix="$package"
fi

if [[ -z "$formula_rel" ]]; then
  formula_rel="Formula/${package}.rb"
fi

if [[ -z "$tap_tag_prefix" ]]; then
  tap_tag_prefix="${package}-"
fi

if ! [[ "$wait_release_timeout" =~ ^[0-9]+$ ]]; then
  echo "error: --wait-release-timeout must be an integer >= 0" >&2
  exit 2
fi

if ! [[ "$wait_release_interval" =~ ^[1-9][0-9]*$ ]]; then
  echo "error: --wait-release-interval must be an integer >= 1" >&2
  exit 2
fi

for cmd in gh python3 git; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "error: $cmd is required" >&2
    exit 1
  fi
done

if [[ "$run_push" == "true" && "$dry_run" != "true" ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "error: brew is required for post-publish upgrade (disable with --no-push)" >&2
    exit 1
  fi
fi

if [[ "$run_commit" == "true" && "$dry_run" != "true" ]]; then
  if ! command -v semantic-commit >/dev/null 2>&1; then
    echo "error: semantic-commit is required (disable with --no-commit)" >&2
    exit 1
  fi
fi

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "$repo_root" ]]; then
  echo "error: must run inside a git work tree" >&2
  exit 1
fi
cd "$repo_root"

if [[ "$latest" == "true" ]]; then
  tag="$(gh release view -R "$repo" --json tagName -q '.tagName')"
fi

if [[ "$tag" != v* ]]; then
  tag="v${tag}"
fi

targets=(
  "aarch64-apple-darwin"
  "x86_64-apple-darwin"
  "aarch64-unknown-linux-gnu"
  "x86_64-unknown-linux-gnu"
)

required_release_assets=()
for target_name in "${targets[@]}"; do
  required_release_assets+=("${asset_prefix}-${tag}-${target_name}.tar.gz")
  required_release_assets+=("${asset_prefix}-${tag}-${target_name}.tar.gz.sha256")
done

release_state="unknown"

release_readiness_status() {
  local json
  if ! json="$(gh release view "$tag" -R "$repo" --json isDraft,assets,publishedAt,url 2>/dev/null)"; then
    release_state="missing_release"
    echo "release page not found"
    return 1
  fi

  local status_line
  status_line="$(
    JSON_PAYLOAD="$json" python3 - "$tag" "${required_release_assets[@]}" <<'PY'
from __future__ import annotations

import json
import os
import sys


tag = sys.argv[1]
required_assets = sys.argv[2:]
data = json.loads(os.environ["JSON_PAYLOAD"])

if data.get("isDraft"):
    print("draft|release exists but is draft")
    raise SystemExit(0)

assets = [asset.get("name", "") for asset in data.get("assets", [])]
assets_set = set(assets)
missing = [name for name in required_assets if name not in assets_set]
if missing:
    print(f"missing_assets|missing {len(missing)} assets: {', '.join(missing)}")
    raise SystemExit(0)

published_at = data.get("publishedAt") or "unknown"
release_url = data.get("url") or "unknown"
print(f"ready|publishedAt={published_at} url={release_url}")
PY
  )"

  local state="${status_line%%|*}"
  local detail="${status_line#*|}"
  release_state="$state"

  if [[ "$state" == "ready" ]]; then
    echo "$detail"
    return 0
  fi

  echo "$detail"
  return 1
}

release_ci_state() {
  local json
  if ! json="$(
    gh run list -R "$repo" --workflow "$release_workflow" --limit 20 \
      --json status,conclusion,headBranch,displayTitle,event,url,createdAt 2>/dev/null
  )"; then
    if ! json="$(
      gh run list -R "$repo" --limit 20 \
        --json status,conclusion,headBranch,displayTitle,event,url,createdAt 2>/dev/null
    )"; then
      echo "unknown|failed to query GitHub Actions runs"
      return 0
    fi
  fi

  JSON_PAYLOAD="$json" python3 - "$tag" <<'PY'
from __future__ import annotations

import json
import os
import sys


tag = sys.argv[1]
active_states = {"queued", "in_progress", "waiting", "pending", "requested"}
runs = json.loads(os.environ["JSON_PAYLOAD"])
if not isinstance(runs, list):
    print("unknown|unexpected gh run list payload")
    raise SystemExit(0)

def is_match(run: dict[str, object]) -> bool:
    head_branch = str(run.get("headBranch") or "")
    title = str(run.get("displayTitle") or "")
    return (
        head_branch == tag
        or head_branch == f"refs/tags/{tag}"
        or tag in title
    )

matched = [run for run in runs if is_match(run)]
if not matched:
    print("none|no matched workflow runs for tag")
    raise SystemExit(0)

for run in matched:
    status = str(run.get("status") or "").lower()
    if status in active_states:
        url = run.get("url") or "unknown"
        event = run.get("event") or "unknown"
        print(f"active|status={status} event={event} url={url}")
        raise SystemExit(0)

latest = matched[0]
status = latest.get("status") or "unknown"
conclusion = latest.get("conclusion") or "unknown"
url = latest.get("url") or "unknown"
print(f"inactive|last status={status} conclusion={conclusion} url={url}")
PY
}

confirm_no_release_ci() {
  local ci_detail="$1"
  echo "warn: tag $tag exists but release page is not ready and no active release CI run was found." >&2
  echo "warn: $ci_detail" >&2
  if [[ "$assume_no_release_ci" == "true" ]]; then
    echo "warn: --assume-no-release-ci set; continue waiting for release readiness." >&2
    return 0
  fi
  if [[ ! -t 0 || ! -t 1 ]]; then
    echo "error: cannot prompt in non-interactive shell; use --assume-no-release-ci to continue waiting." >&2
    return 1
  fi

  local reply
  read -r -p "Continue waiting for release page readiness? [y/N] " reply
  case "${reply,,}" in
    y|yes)
      return 0
      ;;
    *)
      echo "error: aborted; trigger/publish release workflow for $tag then retry." >&2
      return 1
      ;;
  esac
}

wait_for_release_readiness() {
  local start_ts now_ts elapsed ci_line ci_state ci_detail
  local prompted_no_ci="false"
  start_ts="$(date +%s)"

  while true; do
    if detail="$(release_readiness_status)"; then
      echo "ok: release ready for $tag ($detail)"
      return 0
    fi

    echo "wait: release not ready for $tag ($detail)"

    if [[ "$release_state" == "missing_release" ]]; then
      ci_line="$(release_ci_state)"
      ci_state="${ci_line%%|*}"
      ci_detail="${ci_line#*|}"
      case "$ci_state" in
        active)
          echo "wait: release CI is running ($ci_detail)"
          ;;
        inactive|none|unknown)
          if [[ "$prompted_no_ci" != "true" ]]; then
            if ! confirm_no_release_ci "$ci_detail"; then
              return 1
            fi
            prompted_no_ci="true"
          else
            echo "wait: still waiting without active CI run ($ci_detail)"
          fi
          ;;
      esac
    fi

    if (( wait_release_timeout > 0 )); then
      now_ts="$(date +%s)"
      elapsed="$((now_ts - start_ts))"
      if (( elapsed >= wait_release_timeout )); then
        echo "error: timed out waiting for release readiness ($wait_release_timeout seconds)" >&2
        return 1
      fi
    fi

    sleep "$wait_release_interval"
  done
}

if ! gh api "repos/$repo/git/ref/tags/$tag" >/dev/null 2>&1; then
  echo "error: required source tag not found: $repo@$tag" >&2
  exit 1
fi
echo "ok: verified source tag exists: $repo@$tag"

if [[ ! -f "$formula_rel" ]]; then
  echo "error: formula not found: $formula_rel" >&2
  exit 1
fi

if [[ "$dry_run" != "true" && "$run_commit" == "true" ]]; then
  if [[ -n "$(git status --porcelain --untracked-files=no)" ]]; then
    echo "error: working tree has local changes; commit or stash first" >&2
    exit 1
  fi
fi

agents_home="${AGENTS_HOME:-$HOME/.agents}"
outdir="$agents_home/out/homebrew-tap/$package/$tag"
mkdir -p "$outdir"

if [[ "$wait_release" == "true" ]]; then
  wait_for_release_readiness
else
  if ! detail="$(release_readiness_status)"; then
    echo "error: release is not ready for $tag ($detail)" >&2
    echo "error: rerun without --no-wait-release to wait automatically." >&2
    exit 1
  fi
  echo "ok: release ready for $tag ($detail)"
fi

gh release download "$tag" -R "$repo" --pattern "*.sha256" --dir "$outdir" --clobber >/dev/null

python3 - "$formula_rel" "$repo" "$tag" "$outdir" "$dry_run" "$asset_prefix" <<'PY'
from __future__ import annotations

import difflib
import re
import sys
from pathlib import Path


def die(msg: str) -> None:
    print(f"error: {msg}", file=sys.stderr)
    raise SystemExit(1)


def parse_sha256_file(path: Path) -> str:
    raw = path.read_text("utf-8", errors="replace").strip()
    if not raw:
        die(f"empty sha256 file: {path}")
    sha = raw.split()[0].strip()
    if not re.fullmatch(r"[0-9a-f]{64}", sha):
        die(f"invalid sha256 in {path}: {sha!r}")
    return sha


formula_rel, repo, tag, outdir, dry_run_raw, asset_prefix = sys.argv[1:]
dry_run = dry_run_raw.strip().lower() == "true"

targets = [
    "aarch64-apple-darwin",
    "x86_64-apple-darwin",
    "aarch64-unknown-linux-gnu",
    "x86_64-unknown-linux-gnu",
]

sha_by_target: dict[str, str] = {}
missing_sha_files: list[str] = []
for target in targets:
    sha_file = Path(outdir) / f"{asset_prefix}-{tag}-{target}.tar.gz.sha256"
    if not sha_file.is_file():
        missing_sha_files.append(sha_file.name)
        continue
    sha_by_target[target] = parse_sha256_file(sha_file)

if missing_sha_files:
    die(
        f"missing sha256 assets in {outdir}: {', '.join(missing_sha_files)} "
        f"(did you publish the .sha256 assets for {tag}?)"
    )

formula_path = Path(formula_rel)
old_text = formula_path.read_text("utf-8", errors="replace")
lines = old_text.splitlines(keepends=True)

found: dict[str, int] = {t: 0 for t in targets}

for i, line in enumerate(lines):
    stripped = line.lstrip()
    if not stripped.startswith('url "'):
        continue

    for target in targets:
        if f"-{target}.tar.gz" not in line:
            continue

        indent = line[: len(line) - len(stripped)]
        url = f"https://github.com/{repo}/releases/download/{tag}/{asset_prefix}-{tag}-{target}.tar.gz"
        lines[i] = f'{indent}url "{url}"\n'

        j = i + 1
        while j < len(lines) and not lines[j].strip():
            j += 1
        if j >= len(lines):
            die(f"{formula_rel}: expected sha256 after url for {target}")

        sha_line = lines[j].lstrip()
        if not sha_line.startswith('sha256 "'):
            die(f"{formula_rel}: expected sha256 after url for {target} (found: {lines[j].strip()!r})")
        lines[j] = f'{indent}sha256 "{sha_by_target[target]}"\n'
        found[target] += 1

for target, count in found.items():
    if count == 0:
        die(f"{formula_rel}: did not find url for target {target}")
    if count > 1:
        die(f"{formula_rel}: found {count} url entries for target {target} (expected 1)")

new_text = "".join(lines)
if new_text == old_text:
    print(f"ok: already up to date: {formula_rel} ({tag})")
    raise SystemExit(0)

if dry_run:
    diff = difflib.unified_diff(
        old_text.splitlines(keepends=True),
        new_text.splitlines(keepends=True),
        fromfile=formula_rel,
        tofile=formula_rel,
    )
    sys.stdout.writelines(diff)
    raise SystemExit(0)

formula_path.write_text(new_text, encoding="utf-8")
print(f"ok: updated {formula_rel} -> {tag}")
PY

if [[ "$dry_run" == "true" ]]; then
  exit 0
fi

formula_changed="false"
if ! git diff --quiet -- "$formula_rel"; then
  formula_changed="true"
fi

if [[ "$run_ruby_check" == "true" ]]; then
  if command -v ruby >/dev/null 2>&1; then
    ruby -c "$formula_rel" >/dev/null
  else
    echo "warn: ruby not found; skipping ruby -c" >&2
  fi
fi

if [[ "$run_brew_style" == "true" ]]; then
  if command -v brew >/dev/null 2>&1; then
    HOMEBREW_NO_AUTO_UPDATE=1 brew style "$formula_rel" >/dev/null
  else
    echo "warn: brew not found; skipping brew style" >&2
  fi
fi

echo "ok: bumped $package formula to $tag"
echo "ok: sha256 assets cached in: $outdir"

if [[ "$formula_changed" != "true" ]]; then
  exit 0
fi

if [[ "$run_commit" == "true" ]]; then
  git add "$formula_rel"
  printf 'chore(formula): bump %s to %s\n' "$package" "$tag" | semantic-commit commit
else
  echo "warn: --no-commit set; leaving changes uncommitted" >&2
  exit 0
fi

if [[ "$run_tap_tag" == "true" ]]; then
  if [[ -z "$tap_tag" ]]; then
    tap_tag="${tap_tag_prefix}${tag}"
  fi
  if ! git check-ref-format --allow-onelevel "refs/tags/$tap_tag" >/dev/null 2>&1; then
    echo "error: invalid tap tag name: $tap_tag" >&2
    exit 1
  fi
  if git rev-parse -q --verify "refs/tags/$tap_tag" >/dev/null 2>&1; then
    echo "ok: tap tag already exists locally: $tap_tag"
  else
    git tag -a "$tap_tag" -m "chore(formula): bump $package to $tag"
    echo "ok: created tap tag: $tap_tag"
  fi
fi

if [[ "$run_push" == "true" ]]; then
  if ! git remote get-url "$remote" >/dev/null 2>&1; then
    echo "error: unknown git remote: $remote" >&2
    exit 1
  fi
  branch="$(git rev-parse --abbrev-ref HEAD)"
  if [[ -z "$branch" || "$branch" == "HEAD" ]]; then
    echo "error: detached HEAD; cannot push" >&2
    exit 1
  fi
  git push "$remote" "$branch"
  if [[ "$run_tap_tag" == "true" ]]; then
    git push "$remote" "$tap_tag"
    echo "ok: pushed tap tag: $tap_tag (CI will create a GitHub Release)"
  fi
  brew update
  HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade "$package"
  echo "ok: local $package upgraded to latest Homebrew version"
else
  echo "warn: --no-push set; skipping git push" >&2
fi
