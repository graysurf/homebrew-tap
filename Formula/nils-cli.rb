class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.1/nils-cli-v0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "ecf27073789903c41815b51835f481352863473c2052f4d883944b0b36ba5ca9"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.1/nils-cli-v0.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "84307ebe9c1936ae8fc1c2f40cc40417ae36b4fa07cafa3511feee96948f283f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.1/nils-cli-v0.1.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dae0657a72df620ed1b940a6e8d9b2f56d5fc5804883fdb4a7c673856f6b77cf"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.1/nils-cli-v0.1.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4bc84dc47c894229ea23fcd8b1db56b633b986626636bdcbcb4255c2868be218"
    end
  end

  def install
    bin.install Dir["bin/*"]
    zsh_completion.install Dir["completions/zsh/*"]
  end

  test do
    system "git", "init", testpath
    system "#{bin}/git-scope", "--help", chdir: testpath
  end
end
