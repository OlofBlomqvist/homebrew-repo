class OddBox < Formula
  desc "odd-box - reverse proxy server"
  homepage "https://github.com/OlofBlomqvist/odd-box"
  version "0.1.8"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.10/odd-box-aarch64-apple-darwin"
      sha256 "d20c037b1dbb5ecce666856ec5910e782a681c13c0e24ac3802be13406e39a8d"
    else
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.10/odd-box-x86_64-apple-darwin"
      sha256 "6d6ffdbe2c886500faeb68f719d11aa86a2df3b09b5de269a5b04140e75041e3"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.10/odd-box-x86_64-unknown-linux-musl"
      sha256 "78f6784e1f9b812f968296dadc541e6d4e7745ef57e0097cac7a04631569b04e"
    end
  end

  def install
    if OS.mac?
      if Hardware::CPU.arm?
        bin.install "odd-box-aarch64-apple-darwin" => "odd-box"
      else
        bin.install "odd-box-x86_64-apple-darwin" => "odd-box"
      end
    elsif OS.linux?
      bin.install "odd-box-x86_64-unknown-linux-musl" => "odd-box"
    end
  end

  test do
    assert_match "Usage", shell_output("#{bin}/odd-box --help", 1)
  end
end
