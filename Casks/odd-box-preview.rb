cask "odd-box-preview" do
  version "2.0.0-RC1"

  on_arm do
    url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0-RC1/odd-box-aarch64-apple-darwin.dmg"
    sha256 "73aa5f575ce203d1af8bac7a7b421592abdeb92139302af5c2f2783b92b93621"
  end

  depends_on arch: :arm64

  name "Odd Box Preview"
  desc "odd-box reverse proxy server (preview)"
  homepage "https://github.com/OlofBlomqvist/odd-box"

  app "Odd Box Preview.app"
  binary "#{appdir}/Odd Box Preview.app/Contents/MacOS/odd-box", target: "odd-box-preview"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-drs", "com.apple.quarantine", "#{appdir}/Odd Box Preview.app"]
    system_command "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister",
                   args: ["-f", "#{appdir}/Odd Box Preview.app"]
    system_command "/usr/bin/mdimport",
                   args: ["#{appdir}/Odd Box Preview.app"]
  end
end
