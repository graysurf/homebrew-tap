class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v2.2.11/nils-cli-v2.2.11-aarch64-apple-darwin.tar.gz"
      sha256 "a08b13798fbcb44919163196ddb72f710caa75190843ca88ab876f89040aa03a"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v2.2.11/nils-cli-v2.2.11-x86_64-apple-darwin.tar.gz"
      sha256 "83b542cccba39cb58ededf2803a8feb3110460951400b5f67cb94f2a2b1ef657"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v2.2.11/nils-cli-v2.2.11-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b727beba425c98137425f466b69a59f62d7edf20107ececd7e44498fc9c7f292"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v2.2.11/nils-cli-v2.2.11-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2dc6ed888baef4e1bf25a35cd7e9f5c6061a96f4a9c0385c477cd532061faa1e"
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
