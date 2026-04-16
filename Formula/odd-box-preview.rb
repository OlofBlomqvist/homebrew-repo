class OddBoxPreview < Formula
  desc "odd-box reverse proxy server (preview)"
  homepage "https://github.com/OlofBlomqvist/odd-box"
  version "2.0.0-Preview4"

  # Homebrew on macOS requires an active URL spec during formula parsing.
  # odd-box formula builds are Linux-only, so this macOS spec is intentionally
  # marked unsupported via `depends_on :linux`.
  on_macos do
    url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0-Preview4/odd-box-x86_64-unknown-linux-gnu"
    sha256 "0ee113f747a6c6914e32e43345301ee85c70eb4384a5d83910a1e77c516dcc06"
    depends_on :linux
  end

  on_linux do
    on_arm do
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0-Preview4/odd-box-aarch64-unknown-linux-musl"
      sha256 "10ff0300c6b09a34cd140d291653b45bd5bd1f0bbc2512b5a571c8afebdc6f72"
    end
    on_intel do
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0-Preview4/odd-box-x86_64-unknown-linux-gnu"
      sha256 "0ee113f747a6c6914e32e43345301ee85c70eb4384a5d83910a1e77c516dcc06"
    end
  end

  def install
    if Hardware::CPU.arm?
      bin.install "odd-box-aarch64-unknown-linux-musl" => "odd-box-preview"
    else
      bin.install "odd-box-x86_64-unknown-linux-gnu" => "odd-box-preview"
    end
  end


  def post_install
    system "/bin/chmod", "755", bin/"odd-box-preview"
  end

  test do
    assert_match "odd-box", shell_output("#{bin}/odd-box-preview --version")
  end
end
