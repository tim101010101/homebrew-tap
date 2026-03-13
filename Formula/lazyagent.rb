class Lazyagent < Formula
  desc "A lazygit-style TUI for managing AI coding agent sessions"
  homepage "https://github.com/tim101010101/lazyagent"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tim101010101/lazyagent/releases/download/v0.3.0/lazyagent-aarch64-apple-darwin.tar.xz"
      sha256 "e1b906baad6961d03c8e1b21960f29dd61d9c2d95ef6c3b2588c01f8f3e5adbb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tim101010101/lazyagent/releases/download/v0.3.0/lazyagent-x86_64-apple-darwin.tar.xz"
      sha256 "40634856cac7d4e2fd2309760ce8f8366660f7520049e1c4c0ef6f785f41d486"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tim101010101/lazyagent/releases/download/v0.3.0/lazyagent-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8dac64b6c26fd63f1b9c8ab5f346b742aec406ef6dbe93062c438d4f4b11aa04"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tim101010101/lazyagent/releases/download/v0.3.0/lazyagent-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "de86af8c2b2957e33115a57b8da020213da5ede15e1094e5f92181019813756a"
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
