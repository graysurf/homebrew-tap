class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.0/nils-cli-v0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "9a4b88a2f7f36c63034ac46919439adddc5102603def63d33a12a32976184fba"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.0/nils-cli-v0.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "f4374e67eaad84356a3496119740284d35d5e10594cfcd7faa43af11314ea752"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.0/nils-cli-v0.6.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f6d73996bd7506dffd699cf84156210f5c115a53d4838afd1d3f536ac2a8dc4b"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.0/nils-cli-v0.6.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5846aec79055fe30ae4066bc3e2730a28b6d3d91d563fede7486e8ba867c286b"
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
