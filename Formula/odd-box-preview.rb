class OddBoxPreview < Formula
  desc "odd-box reverse proxy server (preview)"
  homepage "https://github.com/OlofBlomqvist/odd-box"
  version "2.0.0-Preview6"

  # Homebrew on macOS requires an active URL spec during formula parsing.
  # odd-box formula builds are Linux-only, so this macOS spec is intentionally
  # marked unsupported via `depends_on :linux`.
  on_macos do
    url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0-Preview6/odd-box-x86_64-unknown-linux-gnu"
    sha256 "9bd61689ea3df6fb75ee2f5a74dbab515c38fd11f78e56460467480a1a0b1d77"
    depends_on :linux
  end

  on_linux do
    on_intel do
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0-Preview6/odd-box-x86_64-unknown-linux-gnu"
      sha256 "9bd61689ea3df6fb75ee2f5a74dbab515c38fd11f78e56460467480a1a0b1d77"
    end
  end

  def install
    bin.install "odd-box-x86_64-unknown-linux-gnu" => "odd-box"
  end


  def post_install
    system "/bin/chmod", "755", bin/"odd-box"
  end

  test do
    assert_match "odd-box", shell_output("#{bin}/odd-box --version")
  end
end
