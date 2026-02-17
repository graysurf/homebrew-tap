class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.1/nils-cli-v0.4.1-aarch64-apple-darwin.tar.gz"
      sha256 "88d013b6ba403c08545bb0a261a991b42e968c61e4ed1f7063f9165a5cdae51c"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.1/nils-cli-v0.4.1-x86_64-apple-darwin.tar.gz"
      sha256 "5c828d403e002f17f14344f94b0c8ab4a12e8e064b005ab6d34c0a767e4629ab"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.1/nils-cli-v0.4.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "19dbdaff3b89921fe330a32f1827d1f2dbcea4c2754bc3343a82c8b7e93dc1cc"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.1/nils-cli-v0.4.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dee7941f7660b8149d661ac551f0297edce7ac5474420cc52746a470571be024"
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
