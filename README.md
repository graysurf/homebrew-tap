# graysurf Homebrew tap

## nils-cli

- Source: https://github.com/graysurf/nils-cli
- Summary: A Rust CLI workspace scaffold for building multiple independently packaged binaries.

## Install

```bash
brew tap graysurf/tap
brew install nils-cli
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
