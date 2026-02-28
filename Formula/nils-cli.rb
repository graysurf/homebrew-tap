class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.8/nils-cli-v0.5.8-aarch64-apple-darwin.tar.gz"
      sha256 "d79029d98acd0a21dd4228f324ba00f3fe5255111539c68054a94ae4021ba066"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.8/nils-cli-v0.5.8-x86_64-apple-darwin.tar.gz"
      sha256 "6bb325554994d9f2ea6cd8cd45878618dd0e1a7c45bff701a7da43b1dc59b0d1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.8/nils-cli-v0.5.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0b071220fdb5cbce7a688188f35d8e030877e008ffe81fb908ad70d0086b3fb7"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.8/nils-cli-v0.5.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "975d768fdef7cb8cdc06dadfa95a255e846e29434d0e1dafaa5a872826e49f4f"
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
