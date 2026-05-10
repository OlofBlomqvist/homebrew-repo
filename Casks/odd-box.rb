cask "odd-box" do
  version "2.0.0"

  on_arm do
    url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0/odd-box-aarch64-apple-darwin.dmg"
    sha256 "49d889e175794b253b0ad8dee41d68d56cc2ad743917979343044288beb12476"
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
