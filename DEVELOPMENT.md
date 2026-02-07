# DEVELOPMENT.md

## Setup

Run from repository root:

```bash
command -v brew >/dev/null 2>&1
brew tap graysurf/tap
```

## Build

Validate formula structure and style:

```bash
ruby -c Formula/nils-cli.rb
HOMEBREW_NO_AUTO_UPDATE=1 brew style Formula/nils-cli.rb
```

## Test

Run the same checks used by CI:

```bash
HOMEBREW_NO_AUTO_UPDATE=1 brew install --formula ./Formula/nils-cli.rb
HOMEBREW_NO_AUTO_UPDATE=1 brew test nils-cli
```

## Notes

- CI reference: `.github/workflows/brew-test.yml`
- If `brew install` reports an already-installed version, run:
  `brew reinstall --formula ./Formula/nils-cli.rb`
