class Oddbox < Formula
  desc "odd-box - reverse proxy server"
  homepage "https://github.com/OlofBlomqvist/odd-box"
  version "0.1.5"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.5/odd-box-aarch64-apple-darwin"
      sha256 "afd4eef6eeebaff0be730a3e39a811d0950a4c8d8f200641d42c4e25916d6324"
    else
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.5/odd-box-x86_64-apple-darwin"
      sha256 "4d9da839f690ebb01f1531ac09db4cb01ac4671f37740c6cb488f33bdfc79610"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.5/odd-box-x86_64-unknown-linux-gnu"
      sha256 "bddaff6759fd4bf6d3812edb6d372c3fd8294c914a082eac22c12e155e22c771"
    end
  end

  def install
    if OS.mac?
      if Hardware::CPU.arm?
        bin.install "odd-box-aarch64-apple-darwin" => "oddbox"
      else
        bin.install "odd-box-x86_64-apple-darwin" => "oddbox"
      end
    elsif OS.linux?
      bin.install "odd-box-x86_64-unknown-linux-gnu" => "oddbox"
    end
  end

  test do
    assert_match "Usage", shell_output("#{bin}/oddbox --help", 1)
  end
end

