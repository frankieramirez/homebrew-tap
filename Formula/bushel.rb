class Bushel < Formula
  desc "A lazydocker-style TUI for Apple Containers"
  homepage "https://github.com/frankieramirez/bushel"
  version "0.3.5"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/frankieramirez/bushel/releases/download/v0.3.5/bushel-aarch64-apple-darwin.tar.xz"
    sha256 "b3f117dea3814bc51cea0bf2c5f6f40cea150f3fa5b68b8fefe871a2b948ec26"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
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

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
