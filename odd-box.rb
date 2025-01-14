class OddBox < Formula
  desc "odd-box - reverse proxy server"
  homepage "https://github.com/OlofBlomqvist/odd-box"
  version "0.1.11"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.11/odd-box-aarch64-apple-darwin"
      sha256 "20d3dafd22820aa1e8f8aaeef85a2a4989562d021ae21ac50f26b98beb6227a8"
    else
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.11/odd-box-x86_64-apple-darwin"
      sha256 "732dc08cd077900b9c4c31f71ac885ae1c6e3197096721a4ec27baf7ee7d175b"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.11/odd-box-x86_64-unknown-linux-musl"
      sha256 "959d893cc4e086b3a80ac19f303dfbadc361ba35570bf1749cf00a3074f383cf"
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
