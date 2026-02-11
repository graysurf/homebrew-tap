class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.2/nils-cli-v0.3.2-aarch64-apple-darwin.tar.gz"
      sha256 "70d8edb5cfdc32956786e0de6c2f45451611061240c9b4042e21033d1c9812dd"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.2/nils-cli-v0.3.2-x86_64-apple-darwin.tar.gz"
      sha256 "b7746d7fe39ab35eccf15ba1d4c69564a8ac738a7f9f8e707465273f1ff9348c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.2/nils-cli-v0.3.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8a27fa4402326237644c9457959e6c183a809b095bb4329bf313045fef057320"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.2/nils-cli-v0.3.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "efb31454a8d78ca625edbdd309b417a15bc81d52781abc53ed78713a785fd887"
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
