#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import os
import pathlib
import tempfile
import urllib.request
from urllib.parse import urlparse


def download_file(url: str) -> pathlib.Path:
    fd, tmp = tempfile.mkstemp(prefix="formula-asset-")
    os.close(fd)
    pathlib.Path(tmp).unlink(missing_ok=True)
    with urllib.request.urlopen(url) as response, open(tmp, "wb") as out:
        while True:
            chunk = response.read(8192)
            if not chunk:
                break
            out.write(chunk)
    return pathlib.Path(tmp)


def hash_file(path: pathlib.Path) -> str:
    sha256 = hashlib.sha256()
    with path.open("rb") as f:
        for block in iter(lambda: f.read(8192), b""):
            sha256.update(block)
    return sha256.hexdigest()


def class_name(name: str) -> str:
    return "".join(p.capitalize() for p in name.replace("_", "-").split("-") if p)


def render_formula(
    name: str,
    version: str,
    desc: str,
    homepage: str,
    linux_x86_url: str,
    linux_x86_sha: str,
    linux_arm_url: str | None,
    linux_arm_sha: str | None,
    binary_name: str,
    binary_target: str,
    linux_x86_asset: str,
    linux_arm_asset: str | None,
) -> str:
    if linux_arm_asset:
        install_section = f'''  def install
    if Hardware::CPU.arm?
      bin.install "{linux_arm_asset}" => "{binary_target}"
    else
      bin.install "{linux_x86_asset}" => "{binary_target}"
    end
  end
'''
    else:
        install_section = f'''  def install
    bin.install "{linux_x86_asset}" => "{binary_target}"
  end
'''

    arm_block = ""
    if linux_arm_url and linux_arm_sha:
        arm_block = f'''    on_arm do
      url "{linux_arm_url}"
      sha256 "{linux_arm_sha}"
    end
'''

    return f'''class {class_name(name)} < Formula
  desc "{desc}"
  homepage "{homepage}"
  version "{version}"

  # Homebrew on macOS requires an active URL spec during formula parsing.
  # odd-box formula builds are Linux-only, so this macOS spec is intentionally
  # marked unsupported via `depends_on :linux`.
  on_macos do
    url "{linux_x86_url}"
    sha256 "{linux_x86_sha}"
    depends_on :linux
  end

  on_linux do
{arm_block}    on_intel do
      url "{linux_x86_url}"
      sha256 "{linux_x86_sha}"
    end
  end

{install_section}

  def post_install
    system "/bin/chmod", "755", bin/"{binary_target}"
  end

  test do
    assert_match "odd-box", shell_output("#{{bin}}/{binary_target} --version")
  end
end
'''


def main() -> int:
    p = argparse.ArgumentParser(description="Generate a Homebrew Linux formula for odd-box assets.")
    p.add_argument("--name", required=True)
    p.add_argument("--version", required=True)
    p.add_argument("--desc", required=True)
    p.add_argument("--homepage", required=True)
    p.add_argument("--linux-x86-url", required=True)
    p.add_argument("--linux-arm-url")
    p.add_argument("--binary-name", default="odd-box")
    p.add_argument("--binary-target", default="odd-box")
    p.add_argument("--output-file", required=True)
    args = p.parse_args()

    print(f"Downloading Linux x86_64 artifact from {args.linux_x86_url}...")
    x86_path = download_file(args.linux_x86_url)
    x86_sha = hash_file(x86_path)
    x86_asset = pathlib.Path(urlparse(args.linux_x86_url).path).name

    arm_sha = None
    arm_path = None
    arm_asset = None
    if args.linux_arm_url:
        print(f"Downloading Linux arm64 artifact from {args.linux_arm_url}...")
        arm_path = download_file(args.linux_arm_url)
        arm_sha = hash_file(arm_path)
        arm_asset = pathlib.Path(urlparse(args.linux_arm_url).path).name

    out = pathlib.Path(args.output_file)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(
        render_formula(
            name=args.name,
            version=args.version,
            desc=args.desc,
            homepage=args.homepage,
            linux_x86_url=args.linux_x86_url,
            linux_x86_sha=x86_sha,
            linux_arm_url=args.linux_arm_url,
            linux_arm_sha=arm_sha,
            binary_name=args.binary_name,
            binary_target=args.binary_target,
            linux_x86_asset=x86_asset,
            linux_arm_asset=arm_asset,
        )
    )

    print(f"Wrote formula to {out}")
    print(f"SHA256 (x86_64): {x86_sha}")
    if arm_sha:
        print(f"SHA256 (arm64): {arm_sha}")

    x86_path.unlink(missing_ok=True)
    if arm_path:
        arm_path.unlink(missing_ok=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
