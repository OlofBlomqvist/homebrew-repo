class OddBox < Formula
  desc "odd-box reverse proxy server"
  homepage "https://github.com/OlofBlomqvist/odd-box"
  version "0.1.12"

  # Homebrew on macOS requires an active URL spec during formula parsing.
  # odd-box formula builds are Linux-only, so this macOS spec is intentionally
  # marked unsupported via `depends_on :linux`.
  on_macos do
    url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.12/odd-box-x86_64-unknown-linux-musl"
    sha256 "ebb5db8be223a265e5105ea4b35166ec0f5d5a63cdc1f3f4807417b43d771cd6"
    depends_on :linux
  end

  on_linux do
    on_intel do
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.12/odd-box-x86_64-unknown-linux-musl"
      sha256 "ebb5db8be223a265e5105ea4b35166ec0f5d5a63cdc1f3f4807417b43d771cd6"
    end
  end

  def install
    bin.install "odd-box-x86_64-unknown-linux-musl" => "odd-box"
  end


  def post_install
    system "/bin/chmod", "755", bin/"odd-box"
  end

  test do
    assert_match "odd-box", shell_output("#{bin}/odd-box --version")
  end
end
