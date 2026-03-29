#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import os
import pathlib
import re
import sys
import tempfile
import urllib.request


def kebab_case(name: str) -> str:
    tokens = re.split(r"[\s_]+", name.strip().lower())
    return "-".join(filter(None, tokens))


def download_file(url: str) -> pathlib.Path:
    fd, tmp = tempfile.mkstemp(prefix="cask-asset-")
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


def render_cask(
    name: str,
    version: str,
    arm_url: str,
    arm_sha: str,
    app_name: str,
    app_target: str,
    binary_name: str,
    binary_target: str,
    desc: str,
    homepage: str,
) -> str:
    installed_app_name = app_target or app_name
    binary_path = f"#{{appdir}}/{installed_app_name}/Contents/MacOS/{binary_name}"
    app_clause = f'app "{app_name}"'
    if installed_app_name != app_name:
        app_clause = f'app "{app_name}", target: "{installed_app_name}"'
    binary_clause = f'binary "{binary_path}"'
    if binary_target != binary_name:
        binary_clause = f'binary "{binary_path}", target: "{binary_target}"'

    return f'''cask "{name}" do
  version "{version}"

  on_arm do
    url "{arm_url}"
    sha256 "{arm_sha}"
  end

  depends_on arch: :arm64

  name "{installed_app_name.removesuffix('.app')}"
  desc "{desc}"
  homepage "{homepage}"

  {app_clause}
  {binary_clause}

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-drs", "com.apple.quarantine", "#{{appdir}}/{installed_app_name}"]
    system_command "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister",
                   args: ["-f", "#{{appdir}}/{installed_app_name}"]
    system_command "/usr/bin/mdimport",
                   args: ["#{{appdir}}/{installed_app_name}"]
  end
end
'''


def main() -> int:
    p = argparse.ArgumentParser(description="Generate a Homebrew cask for odd-box DMGs.")
    p.add_argument("--name", required=True)
    p.add_argument("--version", required=True)
    p.add_argument("--arm-url", required=True)
    p.add_argument("--app-name", required=True)
    p.add_argument("--app-target")
    p.add_argument("--binary-name", required=True)
    p.add_argument("--binary-target")
    p.add_argument("--desc", required=True)
    p.add_argument("--homepage", required=True)
    p.add_argument("--output-file", required=True)
    args = p.parse_args()
    app_target = args.app_target or args.app_name
    binary_target = args.binary_target or args.binary_name

    print(f"Downloading arm64 DMG from {args.arm_url}...")
    arm_path = download_file(args.arm_url)
    arm_sha = hash_file(arm_path)

    out = pathlib.Path(args.output_file)
    if not out.is_absolute():
        out = (pathlib.Path(__file__).resolve().parent / out).resolve()
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(
        render_cask(
            name=args.name,
            version=args.version,
            arm_url=args.arm_url,
            arm_sha=arm_sha,
            app_name=args.app_name,
            app_target=app_target,
            binary_name=args.binary_name,
            binary_target=binary_target,
            desc=args.desc,
            homepage=args.homepage,
        )
    )

    print(f"Wrote cask to {out}")
    print(f"SHA256 (arm64): {arm_sha}")

    arm_path.unlink(missing_ok=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
