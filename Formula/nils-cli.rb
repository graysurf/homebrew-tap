class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.8/nils-cli-v0.6.8-aarch64-apple-darwin.tar.gz"
      sha256 "527fc103b122fad76381030bdb0b9e28e5056869198222a1dd6b77ee24a7df1a"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.8/nils-cli-v0.6.8-x86_64-apple-darwin.tar.gz"
      sha256 "b78659d6eb5003bd08be5e5042face40fe24ae18255aeae4c9163beeee4ac294"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.8/nils-cli-v0.6.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2e9afd64bfa208ae7f4b79b25759309130ef1499600c393ef346a282f53666c4"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.8/nils-cli-v0.6.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5f12919b8be7551cf427563a7389ebcd6da470932f9e63a27f9191c46106d84f"
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
