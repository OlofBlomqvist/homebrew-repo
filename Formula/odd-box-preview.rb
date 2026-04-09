class OddBoxPreview < Formula
  desc "odd-box reverse proxy server (preview)"
  homepage "https://github.com/OlofBlomqvist/odd-box"
  version "2.0.0-Preview3"

  # Homebrew on macOS requires an active URL spec during formula parsing.
  # odd-box formula builds are Linux-only, so this macOS spec is intentionally
  # marked unsupported via `depends_on :linux`.
  on_macos do
    url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0-Preview3/odd-box-x86_64-unknown-linux-musl"
    sha256 "c5d32320be6fd84066b08281cda05ad57398eba15d624b4274281d25788e3113"
    depends_on :linux
  end

  on_linux do
    on_arm do
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0-Preview3/odd-box-aarch64-unknown-linux-musl"
      sha256 "f5c4dc4a125cc11795a735c9d77886373502051d86c9782c6b3d764dffc8a3df"
    end
    on_intel do
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0-Preview3/odd-box-x86_64-unknown-linux-musl"
      sha256 "c5d32320be6fd84066b08281cda05ad57398eba15d624b4274281d25788e3113"
    end
  end

  def install
    if Hardware::CPU.arm?
      bin.install "odd-box-aarch64-unknown-linux-musl" => "odd-box-preview"
    else
      bin.install "odd-box-x86_64-unknown-linux-musl" => "odd-box-preview"
    end
  end


  def post_install
    system "/bin/chmod", "755", bin/"odd-box-preview"
  end

  test do
    assert_match "odd-box", shell_output("#{bin}/odd-box-preview --version")
  end
end
