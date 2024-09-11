class Oddbox < Formula
  desc "odd-box - reverse proxy server"
  homepage "https://github.com/OlofBlomqvist/odd-box"
  version "0.1.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.2/odd-box-aarch64-apple-darwin"
      sha256 "cb26e099e0039cee511021b9d484836fb1052fc769581fbbd588bd90773e80b5"
    else
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.2/odd-box-x86_64-apple-darwin"
      sha256 "5f3dd1db1fdafa81034216e2e96953951aa236d6a261896f473a25e6f03c42dd"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.2/odd-box-x86_64-unknown-linux-gnu"
      sha256 "a6d93a40ace36fe4ebddbb8df8ece24c2db97850e275b527672f5863c410ba02"
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

