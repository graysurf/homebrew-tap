class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.7/nils-cli-v0.6.7-aarch64-apple-darwin.tar.gz"
      sha256 "2676df235dab1304353913252bca89d37da7554577bec18e39052e33a1341135"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.7/nils-cli-v0.6.7-x86_64-apple-darwin.tar.gz"
      sha256 "8792f56d365fb933e9ab99a096cca73a223b52be2096aff96d31dc83335eefbe"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.7/nils-cli-v0.6.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "58241e1eb61bca19b4447cf970e918bba34d67a0a3cce0a3f9f3cf6f24e6c150"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.7/nils-cli-v0.6.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f5de000ba2db3886ae90a0a4dbdf7b5c44016013572d1dfba4fd94c361e32ff8"
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
