class OddBox < Formula
  desc "odd-box reverse proxy server"
  homepage "https://github.com/OlofBlomqvist/odd-box"
  version "2.0.0"

  # Homebrew on macOS requires an active URL spec during formula parsing.
  # odd-box formula builds are Linux-only, so this macOS spec is intentionally
  # marked unsupported via `depends_on :linux`.
  on_macos do
    url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0/odd-box-x86_64-unknown-linux-gnu"
    sha256 "18ed1f23a2ea2e8cc0f2da129acf48429b7bf57d8a41de29c8e499c449351584"
    depends_on :linux
  end

  on_linux do
    on_intel do
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0/odd-box-x86_64-unknown-linux-gnu"
      sha256 "18ed1f23a2ea2e8cc0f2da129acf48429b7bf57d8a41de29c8e499c449351584"
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
