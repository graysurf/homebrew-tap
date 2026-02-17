class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.2/nils-cli-v0.4.2-aarch64-apple-darwin.tar.gz"
      sha256 "d8839b63723231be424c3c67b51fc2eeb92f815fbe34f0b3eab507e3d0b7315c"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.2/nils-cli-v0.4.2-x86_64-apple-darwin.tar.gz"
      sha256 "87a3cd415fb603bdc0561b42dd3ebdcd2686c6e495a4908aec48c6e9aa74704f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.2/nils-cli-v0.4.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8f2a6e7fef020d9d56056bd518a3932d1e3a700d303acd74be9985c5df1ce8dc"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.2/nils-cli-v0.4.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6216f6fd4e6f60ddfe6feeb9e14b989a216379d5ebb14181cebeecfb15f24378"
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
