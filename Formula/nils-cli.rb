class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.4/nils-cli-v0.5.4-aarch64-apple-darwin.tar.gz"
      sha256 "9e062b61daa44dc790b74d4ebddf2e15cc39c84efa2f6d4cc2b8ced7437b189d"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.4/nils-cli-v0.5.4-x86_64-apple-darwin.tar.gz"
      sha256 "9b9d2db86e56daaef5d3e71c580a52bb67977b5273059df1143aacfa99591430"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.4/nils-cli-v0.5.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b088aa61d7e5c5e478ce2d801d201b7da0f8b3f8e54745fef6ebdc22f7565332"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.4/nils-cli-v0.5.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1a40f9ddb9b73624e7bfc25761e335254ea1209007e36e4d17a35a275aaad8dc"
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
