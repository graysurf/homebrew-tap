class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.6/nils-cli-v0.1.6-aarch64-apple-darwin.tar.gz"
      sha256 "5015d149524309e3eec27f394911b3efd668619b65552b2ac8a5cf157321b5e0"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.6/nils-cli-v0.1.6-x86_64-apple-darwin.tar.gz"
      sha256 "2e9aab7cdd861714a0309bc23516a2a1c1b9b176fd8202791ee98b5024eaae0d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.6/nils-cli-v0.1.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "da3054e6dcc68c0ffd40f2d143f122d652a6f62308e2d3e5c9ab19f2f1dd1af2"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.6/nils-cli-v0.1.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "80d8ae45af60937b6982edc8543a41e5697fe4bec30f557c81846ca671faf82b"
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
