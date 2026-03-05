cask "odd-box-preview" do
  version "2.0.0-Preview1"

  on_arm do
    url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0-Preview1/odd-box-aarch64-apple-darwin.dmg"
    sha256 "df38edf05c99cf40329784e0d4b266a851fa00b2f20fc3dccd81a37953af61a8"
  end

  depends_on arch: :arm64

  name "odd-box-preview"
  desc "odd-box reverse proxy server (preview)"
  homepage "https://github.com/OlofBlomqvist/odd-box"

  app "Odd Box.app"
  binary "#{appdir}/Odd Box.app/Contents/MacOS/odd-box", target: "odd-box-preview"
end
