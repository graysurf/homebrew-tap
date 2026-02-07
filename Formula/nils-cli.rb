class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.9/nils-cli-v0.2.9-aarch64-apple-darwin.tar.gz"
      sha256 "34e55ff3608b6dbe60ac773f2104710f636f2f226cfdc5b8a5e2d061b850b3c7"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.9/nils-cli-v0.2.9-x86_64-apple-darwin.tar.gz"
      sha256 "53261cbcdf98b5dd03c8681a709563fa3e468ce936631b7f558b8c7ba800b9c5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.9/nils-cli-v0.2.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b24b86536067160caa5e985ee6d7d6249a4d6aa3536c3a9b70daa8839956a04e"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.9/nils-cli-v0.2.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "59fe0c05986411ea0325a183a52daa2f1f76882154350d7d1bd0b021bba8eb97"
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
