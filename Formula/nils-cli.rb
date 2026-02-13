class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.7/nils-cli-v0.3.7-aarch64-apple-darwin.tar.gz"
      sha256 "c0180733aebf8a96e94ee30cc7bd577dedd761583953a74d01c099f012b8407a"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.7/nils-cli-v0.3.7-x86_64-apple-darwin.tar.gz"
      sha256 "3c01d278bdef5ae574b26602ef09cee94f95f0d7fe352ac6066ca6a0c769f0bf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.7/nils-cli-v0.3.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "68299ab744bb07fe97c21c7380801629881d60461ff10fcc8fbcf21ade1826aa"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.7/nils-cli-v0.3.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "278dea96482ed7407b40b7cd2e3e0b229f5de20510d1817469ef37749e3a6458"
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
