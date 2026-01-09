class Jx < Formula
  desc "An interactive JSON explorer for the command line"
  homepage "https://github.com/sqwxl/jx"
  version "0.5.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sqwxl/jx/releases/download/v0.5.9/jx-aarch64-apple-darwin.tar.xz"
      sha256 "35604c8f4becf22c2d2207719fc499b31cf364f8ad3a74838e74a2cc44a99270"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sqwxl/jx/releases/download/v0.5.9/jx-x86_64-apple-darwin.tar.xz"
      sha256 "d24ba20cc5a3b3b80af9d28007a5f0353b23db6adfaef6f87eee2a154842f5d7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sqwxl/jx/releases/download/v0.5.9/jx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3e7897a9dadac177fcb1b898c9c34dd0c5e55f811f7d3bf1ef97deec6b1fdbba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sqwxl/jx/releases/download/v0.5.9/jx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4cecb3528f6f352f714b527a76fc9e6f52648548dba2fa660043408f46b09f16"
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
