class Jx < Formula
  desc "An interactive JSON explorer for the command line"
  homepage "https://github.com/sqwxl/jx"
  version "0.5.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sqwxl/jx/releases/download/v0.5.13/jx-aarch64-apple-darwin.tar.xz"
      sha256 "d9ddc2c5f65b204696209bf0b44de44fce587c2fdcff0a33713354f6e3ff5bb5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sqwxl/jx/releases/download/v0.5.13/jx-x86_64-apple-darwin.tar.xz"
      sha256 "6a0e3b497300adde285209ad5716c572e98349e52836778f2d8ff1864825b59b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sqwxl/jx/releases/download/v0.5.13/jx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e46f584330fcaad193c465426aa2395e096d66f761f80f2a4c044c8f03d3e874"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sqwxl/jx/releases/download/v0.5.13/jx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "731a8b888eabffe958b6634dd6416d35e0710ce8cfd8c846ecd41c2038f58ff7"
    end
  end
  license "Unlicense"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "jx" if OS.mac? && Hardware::CPU.arm?
    bin.install "jx" if OS.mac? && Hardware::CPU.intel?
    bin.install "jx" if OS.linux? && Hardware::CPU.arm?
    bin.install "jx" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
