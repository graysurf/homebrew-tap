class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.0/nils-cli-v0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "52c08f467baa804ce3f3f2eb0a5f332584103be40f6b4c2aca210727cab19f03"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.0/nils-cli-v0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "1420575af035de6beeee4ee6a36a73d543685398e5228dd47f0fee842766c4cf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.0/nils-cli-v0.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b05ed2e10f401dfbe13610c3cba583300b700b8e810a826d1fe9e250942a1865"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.0/nils-cli-v0.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c63a7b9735c6057074aabe7fb33747a9f47fb1d8256c6b5a5a7af3b1b61426f7"
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
