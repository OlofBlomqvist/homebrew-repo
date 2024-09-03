class Oddbox < Formula
  desc "odd-box - reverse proxy server"
  homepage "https://github.com/OlofBlomqvist/odd-box"
  version "0.1.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.1/odd-box-aarch64-apple-darwin"
      sha256 "84cf54eabc004c7f17d40214afe5a4714cbb4035fea76895ac522693fc565578"
    else
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.1/odd-box-x86_64-apple-darwin"
      sha256 "6cd020b799df58b79ff6d36bc6747ead4123e27373d16fb58e3dd58cb679a576"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.1/odd-box-x86_64-unknown-linux-gnu"
      sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
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

