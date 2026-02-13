class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.6/nils-cli-v0.3.6-aarch64-apple-darwin.tar.gz"
      sha256 "5a60989980542aa11ef2927e285106d6f4b3b1b2ca9240007027988273e48942"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.6/nils-cli-v0.3.6-x86_64-apple-darwin.tar.gz"
      sha256 "28ea1f22b9efbb8a0aa5bb8194afd94d6337aa6e1488f181e3d7624c228ae689"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.6/nils-cli-v0.3.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "59c0ba220791833a3771b244c013631ebfe0dab0c2cac22c96c9f34503f2f847"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.6/nils-cli-v0.3.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "41a0bfa50956579b01e6d108cf7899c5bca5ccba75a227740165f18ab32bc2c8"
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
