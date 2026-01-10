class Jx < Formula
  desc "An interactive JSON explorer for the command line"
  homepage "https://github.com/sqwxl/jx"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sqwxl/jx/releases/download/v0.6.0/jx-aarch64-apple-darwin.tar.xz"
      sha256 "b65c87ba7918b95b12c32ca69af9d1f05d61a4469f73e65c011bab65e79b4423"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sqwxl/jx/releases/download/v0.6.0/jx-x86_64-apple-darwin.tar.xz"
      sha256 "2ddc6cab1d165e96b04a473651db53211c6602d809162192020df2749a73fac4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sqwxl/jx/releases/download/v0.6.0/jx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "faaecafa67e53d5c16fb82f29c86ae5b85f2fdae55cf1febc7b0a7672eacf84f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sqwxl/jx/releases/download/v0.6.0/jx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fb6e209e683ddd46856ee5ece64112f77a3cab2eb77d11b7c6a9c85cc9c42661"
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
