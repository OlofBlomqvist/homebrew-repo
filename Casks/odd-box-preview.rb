cask "odd-box-preview" do
  version "2.0.0-Preview2"

  on_arm do
    url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0-Preview2/odd-box-aarch64-apple-darwin.dmg"
    sha256 "8e4fba3b0ebbaa5193f734ca94dab3a4ee57ffd90ba5f9020b4d71436b2cf170"
  end

  depends_on arch: :arm64

  name "odd-box-preview"
  desc "odd-box reverse proxy server (preview)"
  homepage "https://github.com/OlofBlomqvist/odd-box"

  app "Odd Box.app"
  binary "#{appdir}/Odd Box.app/Contents/MacOS/odd-box", target: "odd-box-preview"
end
