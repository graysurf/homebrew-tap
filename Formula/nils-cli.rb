class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.3/nils-cli-v0.5.3-aarch64-apple-darwin.tar.gz"
      sha256 "a491c7580ac451416f70fb6da02785af87b3bad57e3cb622bd7687e9a7c72d07"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.3/nils-cli-v0.5.3-x86_64-apple-darwin.tar.gz"
      sha256 "ed438d3a6a0fbe9104939fab154ba19a12e90938516ed393cd44ba9269f223ad"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.3/nils-cli-v0.5.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0cfb08374e2448221e9948126c9505cdb3eb7d5321f0081955fc917f32fb00f7"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.3/nils-cli-v0.5.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f5e127f36df4f0bbecab97b30f3ac0daa28330138b156ac4306859f8b7d2eb6b"
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
