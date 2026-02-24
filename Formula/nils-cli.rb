class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.2/nils-cli-v0.5.2-aarch64-apple-darwin.tar.gz"
      sha256 "1c6a2c6a9cb9963157317248acf836ffe02d9b9263f89b531a47fef31648a04c"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.2/nils-cli-v0.5.2-x86_64-apple-darwin.tar.gz"
      sha256 "085476b55675a55e21b177e69e636a94fca9cda2707001ff7d57b9ab16fb2102"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.2/nils-cli-v0.5.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ed6bf04c0441bc73f7d9f196241836f380f1bcb822ff4b2d45f2d103f87d65fa"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.2/nils-cli-v0.5.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "05b0d7e029fb93c7a4e5d1c07b8ab82d04e2e06fb9a01d76a4f0f7ecec2205d3"
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
