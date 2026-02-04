class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.1/nils-cli-v0.2.1-aarch64-apple-darwin.tar.gz"
      sha256 "cc5b1691d1d5c4dafc247249735afadf3653920fbdcfd5e15f4e8cde6723029c"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.1/nils-cli-v0.2.1-x86_64-apple-darwin.tar.gz"
      sha256 "29320ec624839681cd18ea5e68b28db63f6ee41e2a140934cf368cd49ffb273f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.1/nils-cli-v0.2.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cf5d831765e6e529a112020ab52e1dc24e7728ac0fb7d4a0cf397e6e979afe30"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.1/nils-cli-v0.2.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "25419dbd692bde7d60036971600d180eb2552326412048a09cd0d6eca19f3af0"
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
