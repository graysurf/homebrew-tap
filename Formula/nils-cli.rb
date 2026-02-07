class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.7/nils-cli-v0.2.7-aarch64-apple-darwin.tar.gz"
      sha256 "2d9f44d752248cb8e9b2990ecb9c8300f0e44465b1b9d55d457179db5767098d"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.7/nils-cli-v0.2.7-x86_64-apple-darwin.tar.gz"
      sha256 "45d9a5c83169fe31309e3e4bce4e0fb46a2a0ddf93c198af9c18306fcc1d1550"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.7/nils-cli-v0.2.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0d23fe83648ea613285b5b613cdf7cb1d7639b8cdb7c54ae1a7b33b292236e1a"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.7/nils-cli-v0.2.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7855664610057caa5b0c909520229c0061468d5a2061051840608d6bda388b27"
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
