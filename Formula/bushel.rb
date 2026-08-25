class Bushel < Formula
  desc "A lazydocker-style TUI for Apple Containers"
  homepage "https://github.com/frankieramirez/bushel"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frankieramirez/bushel/releases/download/v0.2.1/bushel-aarch64-apple-darwin.tar.xz"
      sha256 "ef219fbad5b5bf8c31ae07c3319dfb82f049f0293399491febb22e4bb1a93441"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frankieramirez/bushel/releases/download/v0.2.1/bushel-x86_64-apple-darwin.tar.xz"
      sha256 "d41e93312b927b96e7ed1014209335da46ea8f135b6cfd091aad871d27817b52"
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
