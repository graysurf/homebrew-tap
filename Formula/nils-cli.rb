class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.8/nils-cli-v0.2.8-aarch64-apple-darwin.tar.gz"
      sha256 "3ba98b73dca8e5f2c3a339f013d080397c8920682c7b2cba4791391c52261dbb"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.8/nils-cli-v0.2.8-x86_64-apple-darwin.tar.gz"
      sha256 "9be0351d442a68b70ca4054668acc422f95bb78d29bf827518ffd8c0ea75ef17"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.8/nils-cli-v0.2.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "476024d161881110203f4a0ce22837dcd4607a6819006a3d3edd9aa65284da12"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.8/nils-cli-v0.2.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b4110cf77287e47adad3660732a2c1f0011c0a5b20e87fada6a69baba1b8c965"
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
