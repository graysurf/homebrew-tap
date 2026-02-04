#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  homebrew-tap-bump-nils-cli.sh (--version <vX.Y.Z|X.Y.Z> | --latest) [options]

Options:
  --repo <OWNER/REPO>     GitHub repo (default: graysurf/nils-cli)
  --formula <path>        Formula path (default: Formula/nils-cli.rb)
  --dry-run               Print unified diff; do not write
  --no-ruby-check         Skip `ruby -c` validation
  --no-style              Skip `brew style` validation
  --no-commit             Skip committing the formula bump
  --no-push               Skip pushing commits/tags
  --no-tap-tag            Skip creating/pushing a tap git tag (release trigger)
  --tap-tag <tag>         Override tap git tag name (default: nils-cli-<tag>)
  --tap-tag-prefix <pfx>  Prefix for tap git tag (default: nils-cli-)
  --remote <name>         Git remote to push to (default: origin)
  -h, --help              Show help

Notes:
  - Downloads `*.sha256` assets into: $CODEX_HOME/out/homebrew-tap/nils-cli/<tag>/
  - Pushing the tap tag triggers GitHub CI to create a GitHub Release.
USAGE
}

repo="graysurf/nils-cli"
formula_rel="Formula/nils-cli.rb"
tag=""
dry_run="false"
latest="false"
run_ruby_check="true"
run_brew_style="true"
run_commit="true"
run_push="true"
run_tap_tag="true"
tap_tag=""
tap_tag_prefix="nils-cli-"
remote="origin"

while [[ $# -gt 0 ]]; do
  case "${1:-}" in
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

for cmd in gh python3 git; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "error: $cmd is required" >&2
    exit 1
  fi
done

if [[ "$run_commit" == "true" && "$dry_run" != "true" ]]; then
  for cmd in semantic-commit git-scope; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      echo "error: $cmd is required (disable with --no-commit)" >&2
      exit 1
    fi
  done
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

codex_home="${CODEX_HOME:-$HOME/.codex}"
outdir="$codex_home/out/homebrew-tap/nils-cli/$tag"
mkdir -p "$outdir"

gh release download "$tag" -R "$repo" --pattern "*.sha256" --dir "$outdir" --clobber >/dev/null

python3 - "$formula_rel" "$repo" "$tag" "$outdir" "$dry_run" <<'PY'
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


formula_rel, repo, tag, outdir, dry_run_raw = sys.argv[1:]
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
    sha_file = Path(outdir) / f"nils-cli-{tag}-{target}.tar.gz.sha256"
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
        url = f"https://github.com/{repo}/releases/download/{tag}/nils-cli-{tag}-{target}.tar.gz"
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

echo "ok: bumped nils-cli formula to $tag"
echo "ok: sha256 assets cached in: $outdir"

if [[ "$formula_changed" != "true" ]]; then
  exit 0
fi

if [[ "$run_commit" == "true" ]]; then
  git add "$formula_rel"
  printf 'chore(formula): bump nils-cli to %s\n' "$tag" | semantic-commit commit
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
    git tag -a "$tap_tag" -m "chore(formula): bump nils-cli to $tag"
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
else
  echo "warn: --no-push set; skipping git push" >&2
fi
