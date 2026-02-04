# graysurf Homebrew tap

## nils-cli

A Rust CLI workspace scaffold for building multiple independently packaged binaries. See: [nils-cli](https://github.com/graysurf/nils-cli)

### Included CLIs

- `api-rest`: File-based REST API caller + Markdown report generator.
- `api-gql`: File-based GraphQL API caller + Markdown report generator + schema helper.
- `api-test`: API test suite runner (JSON results + Markdown summary; optional JUnit).
- `git-scope`: Show git changes by scope (tracked/staged/unstaged/all/commit), optional content output.
- `git-summary`: Summarize git activity across preset or custom date ranges.
- `git-lock`: Create named commit locks and diff/tag/unlock them later.
- `fzf-cli`: fzf-powered pickers for files/dirs/git status/commits/branches/tags, processes, and ports.
- `semantic-commit`: Semantic commit helper (staged context + commit from prepared message).
- `plan-tooling`: Plan Format v1 tooling (to-json/validate/batches/scaffold).
- `image-processing`: Batch image transformations (convert/resize/rotate/crop/pad/optimize).
- `codex-cli`: Codex CLI helpers for authentication, rate-limit checks, and Starship prompt integration.
- `cli-template`: Minimal template binary for validating workspace packaging.

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
