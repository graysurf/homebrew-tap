class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.1/nils-cli-v0.3.1-aarch64-apple-darwin.tar.gz"
      sha256 "71d84fb39ffb9718f46da1d64363ae6c255b5d6850853a888c9bda0b10da9722"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.1/nils-cli-v0.3.1-x86_64-apple-darwin.tar.gz"
      sha256 "13a108fb9932d5c20f1012b3cd6e634c7edf6bcab95c78a0ba19fbc54e76220b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.1/nils-cli-v0.3.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3c2e576612526f442cfedd2ccc741ba16e01e6c3027ad1dbba5ab77b83aa6485"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.1/nils-cli-v0.3.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "94e98b181b2d67d7be6b94cdfdfd070df92f455c7494b0876c846f4e2c92f81b"
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
