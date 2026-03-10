class Lazyagent < Formula
  desc "A lazygit-style TUI for managing AI coding agent sessions"
  homepage "https://github.com/tim101010101/lazyagent"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tim101010101/lazyagent/releases/download/v0.2.1/lazyagent-aarch64-apple-darwin.tar.xz"
      sha256 "7d6071d0f8b6164be21ca79034104c18afde7963deb752c51caa5af03949171c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tim101010101/lazyagent/releases/download/v0.2.1/lazyagent-x86_64-apple-darwin.tar.xz"
      sha256 "82cfd960cfd3d0a0aa2c2ca2f4a0cf4b811d75f02f88d5029ffed650c3b3b052"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tim101010101/lazyagent/releases/download/v0.2.1/lazyagent-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ecd40fd2b80a83fa5fa3e4ac3397543c4bdfd24ac4b942de6044e4e4f719c41e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tim101010101/lazyagent/releases/download/v0.2.1/lazyagent-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "57b1208ad62fb8bf880edc8bf29704e2a0b44775d74be94f801017db399dd990"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "lazyagent" if OS.mac? && Hardware::CPU.arm?
    bin.install "lazyagent" if OS.mac? && Hardware::CPU.intel?
    bin.install "lazyagent" if OS.linux? && Hardware::CPU.arm?
    bin.install "lazyagent" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
