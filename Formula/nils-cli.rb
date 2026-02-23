class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.8/nils-cli-v0.4.8-aarch64-apple-darwin.tar.gz"
      sha256 "45902d1449b74253fa0fc18d05842ce9c95aa70f851fb9e8f1554be4de40b561"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.8/nils-cli-v0.4.8-x86_64-apple-darwin.tar.gz"
      sha256 "5331566ea1ca8825176099ef4b4ef9baea3c2e1b67f34215569ae7fd47b9c68d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.8/nils-cli-v0.4.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d32638f6cfafecc5d9752155b885cf4740361c5e4ceb0f1ac06f1076d1326c2d"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.8/nils-cli-v0.4.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "121fa716e968bbb893d5f804980a69fdddaa18ff9d0a9b8721870b90e8e72c93"
    end
  end

  def install
    bin.install Dir["bin/*"]
    zsh_completion.install Dir["completions/zsh/*"]

    bash_files = Dir["completions/bash/*"]
    bash_completion_files = bash_files.reject { |f| File.basename(f) == "aliases.bash" }
    bash_completion.install bash_completion_files if bash_completion_files.any?

    bash_aliases = bash_files.find { |f| File.basename(f) == "aliases.bash" }
    pkgshare.install bash_aliases => "aliases.bash" if bash_aliases
  end

  test do
    system "git", "init", testpath
    cd testpath do
      system "#{bin}/git-scope", "--help"
    end
  end
end
