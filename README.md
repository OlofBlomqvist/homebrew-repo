# OlofBlomqvist Homebrew Tap

This tap distributes odd-box binaries through Homebrew.

```bash
brew tap OlofBlomqvist/repo
```

## Installing odd-box

### Linux (stable CLI)

```bash
brew install OlofBlomqvist/repo/odd-box
```

### macOS (preview app + CLI, Apple Silicon)

```bash
brew install --cask OlofBlomqvist/repo/odd-box-preview
```

### Linux (preview CLI)

```bash
brew install OlofBlomqvist/repo/odd-box-preview
```

## Upgrading

```bash
# Stable
brew upgrade OlofBlomqvist/repo/odd-box

# Preview
brew upgrade OlofBlomqvist/repo/odd-box-preview
brew upgrade --cask OlofBlomqvist/repo/odd-box-preview
```

## Releasing new formulas/casks

Generation is handled by:

```bash
./g.sh <version> [--preview] [--os macos|linux|all]
```

Examples:

```bash
# Stable Linux formula only
./g.sh 0.1.12 --os linux

# Stable, attempt both platforms (macOS cask auto-skips if no DMG exists)
./g.sh 0.1.12 --os all

# Preview Linux + macOS
./g.sh 2.0.0-Preview1 --preview --os all
```

Required release assets:

- Linux formula: `odd-box-x86_64-unknown-linux-musl`
- macOS cask: `odd-box-aarch64-apple-darwin.dmg`

Notes:

- macOS casks are arm64-only.
- If the macOS DMG is missing (for example no-UI releases), `g.sh` prints a warning and skips cask generation.

After running `g.sh`, review and commit:

```bash
git add Formula/ Casks/ g.sh generate_formula.py generate_cask.py README.md
git commit -m "Update Homebrew formulas/casks"
git push
```
