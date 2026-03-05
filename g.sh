#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: ./g.sh <version> [--preview] [--os macos|linux|all]

Examples:
  ./g.sh 0.1.13-RC2 --preview --os linux
  ./g.sh 0.1.13-RC2 --preview --os all

Notes:
- This generator writes new files under Formula/ and Casks/.
- macOS generation requires the arm64 DMG uploaded in the release assets.
USAGE
}

if [[ $# -eq 0 ]]; then
  usage >&2
  exit 1
fi

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage
  exit 0
fi

VERSION="$1"
shift

PREVIEW=false
GENERATE_MACOS=true
GENERATE_LINUX=true

set_os_selection() {
  case "$1" in
    macos|darwin|cask)
      GENERATE_MACOS=true
      GENERATE_LINUX=false
      ;;
    linux|formula)
      GENERATE_MACOS=false
      GENERATE_LINUX=true
      ;;
    all)
      GENERATE_MACOS=true
      GENERATE_LINUX=true
      ;;
    *)
      echo "error: unsupported --os value '$1'" >&2
      usage >&2
      exit 1
      ;;
  esac
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --preview)
      PREVIEW=true
      shift
      ;;
    --os)
      [[ $# -ge 2 ]] || {
        echo "error: --os requires a value" >&2
        usage >&2
        exit 1
      }
      set_os_selection "$2"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown argument '$1'" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ "${PREVIEW}" == true ]]; then
  NAME="odd-box-preview"
  DESC="odd-box reverse proxy server (preview)"
  FORMULA_BINARY_TARGET="odd-box-preview"
  CASK_BINARY_TARGET="odd-box-preview"
  CHANNEL_SUFFIX=" (preview)"
else
  NAME="odd-box"
  DESC="odd-box reverse proxy server"
  FORMULA_BINARY_TARGET="odd-box"
  CASK_BINARY_TARGET="odd-box"
  CHANNEL_SUFFIX=""
fi

TAG="v${VERSION}"
BASE_URL="https://github.com/OlofBlomqvist/odd-box/releases/download/${TAG}"

LINUX_X86_URL="${BASE_URL}/odd-box-x86_64-unknown-linux-musl"
LINUX_ARM_URL="${BASE_URL}/odd-box-aarch64-unknown-linux-musl"
MAC_ARM_DMG_URL="${BASE_URL}/odd-box-aarch64-apple-darwin.dmg"

url_exists() {
  local url="$1"
  curl -fsI "$url" >/dev/null 2>&1
}

echo "==> Generating Homebrew files for ${NAME} v${VERSION}${CHANNEL_SUFFIX}"
echo "    Base URL: ${BASE_URL}"

auto_linux_arm_args=()
if [[ "${GENERATE_LINUX}" == true ]]; then
  if url_exists "${LINUX_ARM_URL}"; then
    auto_linux_arm_args=(--linux-arm-url "${LINUX_ARM_URL}")
  else
    echo "[linux] arm64 asset not found, generating intel-only formula"
  fi

  echo "[linux] Generating Formula/${NAME}.rb..."
  if [[ ${#auto_linux_arm_args[@]} -gt 0 ]]; then
    python3 generate_formula.py \
      --name "${NAME}" \
      --version "${VERSION}" \
      --desc "${DESC}" \
      --homepage "https://github.com/OlofBlomqvist/odd-box" \
      --linux-x86-url "${LINUX_X86_URL}" \
      "${auto_linux_arm_args[@]}" \
      --binary-name "odd-box" \
      --binary-target "${FORMULA_BINARY_TARGET}" \
      --output-file "Formula/${NAME}.rb"
  else
    python3 generate_formula.py \
      --name "${NAME}" \
      --version "${VERSION}" \
      --desc "${DESC}" \
      --homepage "https://github.com/OlofBlomqvist/odd-box" \
      --linux-x86-url "${LINUX_X86_URL}" \
      --binary-name "odd-box" \
      --binary-target "${FORMULA_BINARY_TARGET}" \
      --output-file "Formula/${NAME}.rb"
  fi
fi

if [[ "${GENERATE_MACOS}" == true ]]; then
  echo "[macos] Checking DMG assets..."
  if ! url_exists "${MAC_ARM_DMG_URL}"; then
    echo "[macos] arm64 DMG asset not found: ${MAC_ARM_DMG_URL}" >&2
    echo "[macos] skipping cask generation (expected for no-UI releases)." >&2
    GENERATE_MACOS=false
  fi

  if [[ "${GENERATE_MACOS}" == true ]]; then
    echo "[macos] Generating Casks/${NAME}.rb..."
    python3 generate_cask.py \
      --name "${NAME}" \
      --version "${VERSION}" \
      --arm-url "${MAC_ARM_DMG_URL}" \
      --binary-name "odd-box" \
      --binary-target "${CASK_BINARY_TARGET}" \
      --desc "${DESC}" \
      --homepage "https://github.com/OlofBlomqvist/odd-box" \
      --output-file "Casks/${NAME}.rb"
  fi
fi

echo
echo "==> Done. Review and commit:"
if [[ "${GENERATE_LINUX}" == true ]]; then
  echo "    Formula/${NAME}.rb"
fi
if [[ "${GENERATE_MACOS}" == true ]]; then
  echo "    Casks/${NAME}.rb"
fi
