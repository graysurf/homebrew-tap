class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.5/nils-cli-v0.3.5-aarch64-apple-darwin.tar.gz"
      sha256 "e9675a75b52c6ce3c2aec4d3959577d40c81fa9902869693b3dd101341c32ab7"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.5/nils-cli-v0.3.5-x86_64-apple-darwin.tar.gz"
      sha256 "d2f95f5a4a59940035273039654ae0ddea11cabc6afd70e6097df459b76ea128"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.5/nils-cli-v0.3.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "97b9449db608de810e191b29b30bc0b15d28df5d6e25c9c964ca58e99a824a0b"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.5/nils-cli-v0.3.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "143cb51b64a1f820890bed579633101f7b922ad2f19816fc67293828db125677"
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
