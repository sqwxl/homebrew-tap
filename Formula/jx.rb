class Jx < Formula
  desc "An interactive JSON explorer for the command line"
  homepage "https://github.com/sqwxl/jx"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sqwxl/jx/releases/download/v0.7.0/jx-aarch64-apple-darwin.tar.xz"
      sha256 "1b3a3544cde7c4e176f092a012eb022db1149e4b0b7092d95b4fe911f5dab8bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sqwxl/jx/releases/download/v0.7.0/jx-x86_64-apple-darwin.tar.xz"
      sha256 "f8c05953dc1a37bc46e49ea54b2ec2a333926b63c2c552bac43eca680341f192"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sqwxl/jx/releases/download/v0.7.0/jx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0d4adbbf1574a659771cc4f75144841b18b025f74770b64c4b54a2a87b37b5ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sqwxl/jx/releases/download/v0.7.0/jx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fc34402541905e128dcc35715d33c4344916aac544be53c3995f656a54e63bbe"
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
