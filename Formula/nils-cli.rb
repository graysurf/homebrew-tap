class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.8/nils-cli-v0.1.8-aarch64-apple-darwin.tar.gz"
      sha256 "0104beb27fc7b401133b3382fa040f6e986026ea9716b04435926f3d460b436f"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.8/nils-cli-v0.1.8-x86_64-apple-darwin.tar.gz"
      sha256 "dc74846de19d5d11ee62a0de961433e13c51235e07e078ae1f909af0a441c474"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.8/nils-cli-v0.1.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "378cceb7c6e83e5a319a561874e2025afe03cacf2cb16053b7d277427e688eb2"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.8/nils-cli-v0.1.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4e9097ed5677292d1cb98636f5f8f5bd0af3cb36717feb0bf2f7a77c4269b0c1"
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
