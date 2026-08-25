class Bushel < Formula
  desc "A lazydocker-style TUI for Apple Containers"
  homepage "https://github.com/frankieramirez/bushel"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frankieramirez/bushel/releases/download/v0.1.0/bushel-aarch64-apple-darwin.tar.xz"
      sha256 "27e792047f60033887f9ec6ca07adabd3d6d4676765d6f6e85f6fdf8598c20e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frankieramirez/bushel/releases/download/v0.1.0/bushel-x86_64-apple-darwin.tar.xz"
      sha256 "2511647bcf2e1c6b4be43f4bb5a84dcf78b254e630b3461eb6dd63e785635243"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "bushel"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "bushel"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
