class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v2.2.10/nils-cli-v2.2.10-aarch64-apple-darwin.tar.gz"
      sha256 "8472f5c6edbcf54342e04f5b38054ec45f13ba5a5eb97fe3db141f6af0ad0706"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v2.2.10/nils-cli-v2.2.10-x86_64-apple-darwin.tar.gz"
      sha256 "e54832d6a8850d92388f89b992c2e9b211cf75df6bbf74a246fd5ab6a9a76a04"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v2.2.10/nils-cli-v2.2.10-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "24f30938a170786ed01db072ce18aae0a369cd1832db878ec548165d77ac83c7"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v2.2.10/nils-cli-v2.2.10-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d775b879317d8ffe32b026e1ada59bcceffb4fd761a111e8cb66d0dabee78ea1"
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
