class Jx < Formula
  desc "An interactive JSON explorer for the command line"
  homepage "https://github.com/sqwxl/jx"
  version "0.5.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sqwxl/jx/releases/download/v0.5.8/jx-aarch64-apple-darwin.tar.xz"
      sha256 "ff56556ee80e9c2b077026e3a729d01a3d114b7f046b5846cef96966a549d8ff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sqwxl/jx/releases/download/v0.5.8/jx-x86_64-apple-darwin.tar.xz"
      sha256 "17f27372e48b8f3b73ae585e8ebb729248b926e2e061a7b8c013337b9f2d82d2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sqwxl/jx/releases/download/v0.5.8/jx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "92113e323018958705b7ad21ca33bfbe8818ee50808784c60a53d61595affaa6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sqwxl/jx/releases/download/v0.5.8/jx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "930fc37a5f3bd3ff47d50fceb93130c8a279af4656175e3abd902e3aafbd4818"
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
