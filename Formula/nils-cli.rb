class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.2/nils-cli-v0.2.2-aarch64-apple-darwin.tar.gz"
      sha256 "445c170ae1f96f23a23e12905d01dc98cd8bdc5d091575c5706c6f4169085f23"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.2/nils-cli-v0.2.2-x86_64-apple-darwin.tar.gz"
      sha256 "1787bbcfc8720ac5639496e6c41759f4aded773cf77e8e471f21f2064f280b69"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.2/nils-cli-v0.2.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "74fa34b26f174cd7ece5c7de6c95064670b5936e6177c87586170d33a9ac9e17"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.2/nils-cli-v0.2.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b0531a9529088d45f40dfc99c4fc22a2f03c93dfbae7a67fe23ff94edfee5320"
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
