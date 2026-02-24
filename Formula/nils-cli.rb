class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.1/nils-cli-v0.5.1-aarch64-apple-darwin.tar.gz"
      sha256 "93670faafe7d01a524f7c5cbef0877435873e8931673a15e68cf51e982d976b5"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.1/nils-cli-v0.5.1-x86_64-apple-darwin.tar.gz"
      sha256 "e52648b1f1ba9410334bf3329619cf4379e96cab8ac6d01e8ab595efb85366da"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.1/nils-cli-v0.5.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8c8c36c5168a21ecdd84cac5f222aef4a0b04e3ae0ee8dd0ad1ef24d7b457eb9"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.1/nils-cli-v0.5.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "93fb363a54c001a0bf694e17d09fbe54c1658170b3ca1f02796a34e82438ecb3"
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
