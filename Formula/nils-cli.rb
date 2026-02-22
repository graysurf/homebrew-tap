class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.6/nils-cli-v0.4.6-aarch64-apple-darwin.tar.gz"
      sha256 "42a529ccbfda6b4270ec0c43757bcbdeff1e52cbdba0d71539a7bd8328e301aa"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.6/nils-cli-v0.4.6-x86_64-apple-darwin.tar.gz"
      sha256 "39c0bb6185ea5200e82f2247b4907d548b9295db6bff7b58da341adca442cc5a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.6/nils-cli-v0.4.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2fa931b57c4d59d09074c05256527052baa40ec6f4968f37965e0dfa785d5c58"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.6/nils-cli-v0.4.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "73aeb6d882b6452ceeff99a54abbb47de53485835d156420f1c36efc5e93b537"
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
