class OddBoxPreview < Formula
  desc "odd-box reverse proxy server (preview)"
  homepage "https://github.com/OlofBlomqvist/odd-box"
  version "2.0.0-RC3"

  # Homebrew on macOS requires an active URL spec during formula parsing.
  # odd-box formula builds are Linux-only, so this macOS spec is intentionally
  # marked unsupported via `depends_on :linux`.
  on_macos do
    url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0-RC3/odd-box-x86_64-unknown-linux-gnu"
    sha256 "b0337e22fffdae6ff4f348a2a24c06d494b3407c8b5b623b96d2dafe8a5a8b04"
    depends_on :linux
  end

  on_linux do
    on_intel do
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0-RC3/odd-box-x86_64-unknown-linux-gnu"
      sha256 "b0337e22fffdae6ff4f348a2a24c06d494b3407c8b5b623b96d2dafe8a5a8b04"
    end
  end

  def install
    bin.install "odd-box-x86_64-unknown-linux-gnu" => "odd-box-preview"
  end


  def post_install
    system "/bin/chmod", "755", bin/"odd-box-preview"
  end

  test do
    assert_match "odd-box", shell_output("#{bin}/odd-box-preview --version")
  end
end
