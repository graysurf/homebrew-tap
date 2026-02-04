class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.7/nils-cli-v0.1.7-aarch64-apple-darwin.tar.gz"
      sha256 "4181e5dff4d683b9b472e7fe111f57054a4cbcd34139f689bacb8b5b0b5e48bd"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.7/nils-cli-v0.1.7-x86_64-apple-darwin.tar.gz"
      sha256 "9af0e44ee4daff14e49950a7c4272399b02901bf379612423028ac8e51af4778"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.7/nils-cli-v0.1.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6bca7b2417cacf4cbf9828d9ffdc39c4bded436121257b30f65c8702ff1f24cf"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.7/nils-cli-v0.1.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "da983e2ec45b21c634bfdb880c6cd3ababd81c5980fbbaf0de9125066cadf6de"
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
