class Oddbox < Formula
  desc "odd-box - reverse proxy server"
  homepage "https://github.com/OlofBlomqvist/odd-box"
  version "0.1.8"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.8/odd-box-aarch64-apple-darwin"
      sha256 "54d215690094a17230b53de14224f90b7c958729c4162b760d3fffdb36d0cbd8"
    else
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.8/odd-box-x86_64-apple-darwin"
      sha256 "7160cd010a0b3d254786e3f7dc4ad06476fa2a995c108342bb5eacdab207b62b"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.8/odd-box-x86_64-unknown-linux-gnu"
      sha256 "7cf39d995a9820fe1f27df9f50180b88a46f92031dd17a1f1e3297602d0f797c"
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
      bin.install "odd-box-x86_64-unknown-linux-gnu" => "odd-box"
    end
  end

  test do
    assert_match "Usage", shell_output("#{bin}/oddbox --help", 1)
  end
end

