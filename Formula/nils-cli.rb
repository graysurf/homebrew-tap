class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  version "0.1.0"
  license "MIT OR Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.0/nils-cli-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "2ef7e02cae344db376cacf162e0e2e57f4162fea1b501a55594e25df09e581e4"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.0/nils-cli-v0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "b14ed148421b79179b9696af70799d1915bbca013ced1e425c4e319f3e4111ef"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.0/nils-cli-v0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7aa1dcbb40b94a400f702d5e16b5806367114d2b865320d71be4d8d52e184f55"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.0/nils-cli-v0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6d7ad8b10ef50d4d580eb002be88c1b45e54236ff910cc01179873af33aed9d3"
    end
  end

  def install
    bin.install Dir["bin/*"]
    zsh_completion.install Dir["completions/zsh/*"]
  end

  test do
    system "#{bin}/git-scope", "--help"
  end
end
