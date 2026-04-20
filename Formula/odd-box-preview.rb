class OddBoxPreview < Formula
  desc "odd-box reverse proxy server (preview)"
  homepage "https://github.com/OlofBlomqvist/odd-box"
  version "2.0.0-Preview5"

  # Homebrew on macOS requires an active URL spec during formula parsing.
  # odd-box formula builds are Linux-only, so this macOS spec is intentionally
  # marked unsupported via `depends_on :linux`.
  on_macos do
    url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0-Preview5/odd-box-x86_64-unknown-linux-gnu"
    sha256 "d07c847bc8c598e1c11adc706406694701f68e5e20bb18626a3ab00edba37877"
    depends_on :linux
  end

  on_linux do
    on_intel do
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0-Preview5/odd-box-x86_64-unknown-linux-gnu"
      sha256 "d07c847bc8c598e1c11adc706406694701f68e5e20bb18626a3ab00edba37877"
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
