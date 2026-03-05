class OddBoxPreview < Formula
  desc "odd-box reverse proxy server (preview)"
  homepage "https://github.com/OlofBlomqvist/odd-box"
  version "2.0.0-Preview1"

  # Homebrew on macOS requires an active URL spec during formula parsing.
  # odd-box formula builds are Linux-only, so this macOS spec is intentionally
  # marked unsupported via `depends_on :linux`.
  on_macos do
    url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0-Preview1/odd-box-x86_64-unknown-linux-musl"
    sha256 "b31882d0a0029ffeeea8288a35a939bc91c9cfed21923c62cac066c6c8a5287d"
    depends_on :linux
  end

  on_linux do
    on_intel do
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0-Preview1/odd-box-x86_64-unknown-linux-musl"
      sha256 "b31882d0a0029ffeeea8288a35a939bc91c9cfed21923c62cac066c6c8a5287d"
    end
  end

  def install
    bin.install "odd-box-x86_64-unknown-linux-musl" => "odd-box-preview"
  end


  def post_install
    system "/bin/chmod", "755", bin/"odd-box-preview"
  end

  test do
    assert_match "odd-box", shell_output("#{bin}/odd-box-preview --version")
  end
end
