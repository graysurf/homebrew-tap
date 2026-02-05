class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.3/nils-cli-v0.2.3-aarch64-apple-darwin.tar.gz"
      sha256 "0d9ca8521e9672cbdf7ca4fdd3cf87f9f3f315a77d19398b220630361a1affdf"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.3/nils-cli-v0.2.3-x86_64-apple-darwin.tar.gz"
      sha256 "6342e1df93850e88faf61f2aab5a3e886222c8dc945fe3c4e799082a9a6443ce"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.3/nils-cli-v0.2.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0670c9a6d8e740563ff31b901d27cfbcab51b79c7de8af411debb945d8f50b26"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.3/nils-cli-v0.2.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2f29be37a64fa1096a2efd7b3b8a263cc8e9e9ebc4f8e853499172ef6024536c"
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
