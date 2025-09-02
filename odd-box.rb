class OddBox < Formula
  desc "odd-box - reverse proxy server"
  homepage "https://github.com/OlofBlomqvist/odd-box"
  version "0.1.12"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.12/odd-box-aarch64-apple-darwin"
      sha256 "33fb63799f45e7ff890f434f059206fbf732fe8560d25e44c259df7e00824dcd"
    else
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.12/odd-box-x86_64-apple-darwin"
      sha256 "20ff93f665dd193c80a05697ab2331bba14bb792c15052d343f01a855640c346"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/OlofBlomqvist/odd-box/releases/download/v0.1.12/odd-box-x86_64-unknown-linux-musl"
      sha256 "ebb5db8be223a265e5105ea4b35166ec0f5d5a63cdc1f3f4807417b43d771cd6"
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
