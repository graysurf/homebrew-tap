class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.0/nils-cli-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "3fed9b5df419507a9473a6df373034ef46bbb440b9859812a3d60a2690146640"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.0/nils-cli-v0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "926f64b90a9ff5cbe63b533c992a8b111eca2f61df122b59601f58fb22fa97ce"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.0/nils-cli-v0.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d4e53c715b344535985d99c8a922070bf2eada06f3d7eeb30c5566ce3eda6440"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.0/nils-cli-v0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "55687ed96094dabc8492a35fc04e953dbf87d9aac41fcbbf3e5be035cbde85d3"
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
