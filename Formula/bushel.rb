class Bushel < Formula
  desc "A lazydocker-style TUI for Apple Containers"
  homepage "https://github.com/frankieramirez/bushel"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frankieramirez/bushel/releases/download/v0.2.0/bushel-aarch64-apple-darwin.tar.xz"
      sha256 "19cc70257efc9dbfbd9fda52eaf01401f3e07065c10922dacc32586b353160bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frankieramirez/bushel/releases/download/v0.2.0/bushel-x86_64-apple-darwin.tar.xz"
      sha256 "d9a78bb97da89ad27c5356216d38e583c3d9ceedd58be0255ece1e5ab25139ed"
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
