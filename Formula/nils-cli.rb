class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.4/nils-cli-v0.1.4-aarch64-apple-darwin.tar.gz"
      sha256 "38125b1bab5a929e93f0e5125a41977e097fd463ce76da94e0741514bbb97ebe"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.4/nils-cli-v0.1.4-x86_64-apple-darwin.tar.gz"
      sha256 "29c6c29ac4e7d940ade11b66a9db1a540973e0e56591ff1766a901d88786ac45"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.4/nils-cli-v0.1.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8d8215ce759c6d14ecb66b42304a6948bad0566f803e07ae2318d4908bb173d0"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.4/nils-cli-v0.1.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ae0ce940ff97f70a7420c9e149e945b3c28523bc1de987e8867a8026ebfc0a18"
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
