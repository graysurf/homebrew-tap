class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.7/nils-cli-v0.4.7-aarch64-apple-darwin.tar.gz"
      sha256 "72abe65bc1522e58958bbe9725c28ad85c4cf136c003b1ec275ef3cd038df2af"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.7/nils-cli-v0.4.7-x86_64-apple-darwin.tar.gz"
      sha256 "ac6720d64daabdd181c05b743a8898976882cd5645d83574affabc8271eefc8c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.7/nils-cli-v0.4.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0dce9c3b8a7788a9843f442053b46c458549455fb5e599d95f98caadeb1b3a95"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.7/nils-cli-v0.4.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9679ba6a86e9a5db9ce87a71ce2fb0db89987e7527e81ab0cfcf852623f8a44f"
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
