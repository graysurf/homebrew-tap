class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.2/nils-cli-v0.1.2-aarch64-apple-darwin.tar.gz"
      sha256 "b245168fa841c51a5f5fc6a8af5a6b151b46416e70ee3525f5671a953e7ef492"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.2/nils-cli-v0.1.2-x86_64-apple-darwin.tar.gz"
      sha256 "854049b1d8a61b910277f63bc7d19b8ca2450f4d7d08d9109cd32aeaa93ccccc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.2/nils-cli-v0.1.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3294c7854ae880d8661696141ca9b9aeee9c0ff75c87b338d9afa3d078033301"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.2/nils-cli-v0.1.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "23da80db9fb038dffabd116d7badbb0017cd66ddba8fea904db08d4a65486d4b"
    end
  end

  def install
    bin.install Dir["bin/*"]
    zsh_completion.install Dir["completions/zsh/*"]
  end

  test do
    system "git", "init", testpath
    cd testpath do
      system "#{bin}/git-scope", "--help"
    end
  end
end
