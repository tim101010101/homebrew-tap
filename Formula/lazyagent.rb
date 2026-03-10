class Lazyagent < Formula
  desc "A lazygit-style TUI for managing AI coding agent sessions"
  homepage "https://github.com/tim101010101/lazyagent"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tim101010101/lazyagent/releases/download/v0.2.1/lazyagent-aarch64-apple-darwin.tar.xz"
      sha256 "33847412ee401bdba4b5819994a6efd11f5acd53c7f93d0601aed1d5baba7a93"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tim101010101/lazyagent/releases/download/v0.2.1/lazyagent-x86_64-apple-darwin.tar.xz"
      sha256 "2d7ba962d21f2baba42a304cc03b04ac3ea80d446c7a95cc10ab7128e47b39da"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tim101010101/lazyagent/releases/download/v0.2.1/lazyagent-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "88b144985ddafa48847180968ac59e5e9ab82e68a8bb3cc71adc6ab342e79034"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tim101010101/lazyagent/releases/download/v0.2.1/lazyagent-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ba50b24a3308efa43091c212f7525878c30ca01b6d254e9fb5813bd7d8eeed13"
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
