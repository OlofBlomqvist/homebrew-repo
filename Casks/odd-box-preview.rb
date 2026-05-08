cask "odd-box-preview" do
  version "2.0.0-RC3"

  on_arm do
    url "https://github.com/OlofBlomqvist/odd-box/releases/download/v2.0.0-RC3/odd-box-aarch64-apple-darwin.dmg"
    sha256 "61e8748523f5ad5ddca70a72827785b3a9ca1b00422091b6bebaa058375c63d0"
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
