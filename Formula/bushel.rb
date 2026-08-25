class Bushel < Formula
  desc "A lazydocker-style TUI for Apple Containers"
  homepage "https://github.com/frankieramirez/bushel"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frankieramirez/bushel/releases/download/v0.1.1/bushel-aarch64-apple-darwin.tar.xz"
      sha256 "f6847436af8769a81315839b01303e6bd544b77fb4dff6e44c64bbcfc7de1e46"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frankieramirez/bushel/releases/download/v0.1.1/bushel-x86_64-apple-darwin.tar.xz"
      sha256 "116374752874fbd4914db90f5806b14bbd8694e7c966fe66f74f9af2d76e6bc1"
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
