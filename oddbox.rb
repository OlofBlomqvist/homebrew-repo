class Oddbox < Formula
  desc "odd-box - reverse proxy server"
  homepage "https://github.com/OlofBlomqvist/odd-box"
  version "0.1.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.3/odd-box-aarch64-apple-darwin"
      sha256 "a2e82b3f31209fd50e78f73ec761f62ebd22bf43b0fb2fe75184a028b6df6f15"
    else
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.3/odd-box-x86_64-apple-darwin"
      sha256 "b3fb3765d97a654f26acd8ebf3134e107eb7b302d2609d8e57353c601e7d5c71"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.3/odd-box-x86_64-unknown-linux-gnu"
      sha256 "d296f078dae6396ca7b553fe976304900b9a60c56d6022ab82712d830bfa5dda"
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

