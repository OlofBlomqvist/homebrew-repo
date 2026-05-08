class OddBoxPreview < Formula
  desc "odd-box reverse proxy server (preview)"
  homepage "https://github.com/OlofBlomqvist/odd-box"
  version "2.0.0-RC3"

  # Homebrew on macOS requires an active URL spec during formula parsing.
  # odd-box formula builds are Linux-only, so this macOS spec is intentionally
  # marked unsupported via `depends_on :linux`.
  on_macos do
    url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0-RC3/odd-box-x86_64-unknown-linux-gnu"
    sha256 "f6c1706d6270f3e28675ae3bf83cc219c161f775bd8cb264e11777fc253ef7e1"
    depends_on :linux
  end

  on_linux do
    on_intel do
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0-RC3/odd-box-x86_64-unknown-linux-gnu"
      sha256 "f6c1706d6270f3e28675ae3bf83cc219c161f775bd8cb264e11777fc253ef7e1"
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
