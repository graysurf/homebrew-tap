class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.6/nils-cli-v0.2.6-aarch64-apple-darwin.tar.gz"
      sha256 "3b0aab4a0f08011f1dab21b09081ab7ec58f488601326ff2f5f3255e8f5f776f"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.6/nils-cli-v0.2.6-x86_64-apple-darwin.tar.gz"
      sha256 "7be5093010a9cc36b426c4772b72211a207af19524928bdb795e9abf238509de"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.6/nils-cli-v0.2.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "50dfd117fb15d3292f96e19578569d60bce5c168023de456e25e826446060c75"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.6/nils-cli-v0.2.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d634077b706449408a5284c26a3a2f3d6639e9aca6d01fd35cbe23b7a64fcc5b"
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
