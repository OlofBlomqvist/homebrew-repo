cask "odd-box" do
  version "2.0.0-Preview5"

  on_arm do
    url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0-Preview5/odd-box-aarch64-apple-darwin.dmg"
    sha256 "3c455732ef7dc3f522dd4335d80ccf4ac0a2140288c07fe7a56de2ca103bc918"
  end

  depends_on arch: :arm64

  name "Odd Box"
  desc "odd-box reverse proxy server"
  homepage "https://github.com/OlofBlomqvist/odd-box"

  app "Odd Box.app"
  binary "#{appdir}/Odd Box.app/Contents/MacOS/odd-box"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-drs", "com.apple.quarantine", "#{appdir}/Odd Box.app"]
    system_command "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister",
                   args: ["-f", "#{appdir}/Odd Box.app"]
    system_command "/usr/bin/mdimport",
                   args: ["#{appdir}/Odd Box.app"]
  end
end
