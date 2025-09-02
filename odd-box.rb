class OddBox < Formula
  desc "odd-box - reverse proxy server"
  homepage "https://github.com/OlofBlomqvist/odd-box"
  version "0.1.12"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.12/odd-box-aarch64-apple-darwin"
      sha256 "1b72b58ba3dff9187c7d546b7876db96a2c798a6278c534b8b1bf78b0ebb16ea"
    else
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.12/odd-box-x86_64-apple-darwin"
      sha256 "21dcc595923ce81489885734d5e91c93ab0e8d37f0c9153e6c9739f846fbc1ab"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.12/odd-box-x86_64-unknown-linux-musl"
      sha256 "cf706b98e6f681d22ccbf034f72ac9e256120f574899821040b282b6e6b02bfc"
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
