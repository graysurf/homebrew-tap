class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.3/nils-cli-v0.1.3-aarch64-apple-darwin.tar.gz"
      sha256 "44495105b15412e9dc899edcd7af8609b4143c128d3f226801dc34e512c16a6f"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.3/nils-cli-v0.1.3-x86_64-apple-darwin.tar.gz"
      sha256 "5ef56b40bea9095856aeb71ef87c4c7e3e175137e2fab54fc2dbd13eead4351d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.3/nils-cli-v0.1.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b7fc68a0c454a6b60c45f1a87c05e2cb920c3194626f12053468c395f1488a79"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.3/nils-cli-v0.1.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "49210b57b8be67c68acab1cfb4b6fb79c2d81789cf8eb7c8d4bc89e3db6df345"
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
