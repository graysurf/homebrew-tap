class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.9/nils-cli-v0.3.9-aarch64-apple-darwin.tar.gz"
      sha256 "b975a7f8ddd3efd869172d55d246e846aca0b6689e652cba66a51a96ae66da3f"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.9/nils-cli-v0.3.9-x86_64-apple-darwin.tar.gz"
      sha256 "2608f5ea77ec75f226f4e504401f21d67d6b7aece805c10e3ef1e4c86d6fd287"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.9/nils-cli-v0.3.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "48ff6a732c5aa6ac7d4fb2e9f71ab906d16ed43fefbb5e0503a2bcc9c6b7e434"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.9/nils-cli-v0.3.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "321fb55fab88f78ebee8221e04071a12b668eb476389d84568cad75db02f3406"
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
