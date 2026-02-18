class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.4/nils-cli-v0.4.4-aarch64-apple-darwin.tar.gz"
      sha256 "f1b6608dbd65ec031befaaeb2d49eb8515dfb1ae3134543f1133b08de0989871"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.4/nils-cli-v0.4.4-x86_64-apple-darwin.tar.gz"
      sha256 "a8463daa42adb48d9347ea673c46b375afdfbb6450a9d295d469cea5142d5623"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.4/nils-cli-v0.4.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "db4eca43dc7392dc74fb5639911d02b7b5f70792ed9e88e082f0ebe987153f14"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.4/nils-cli-v0.4.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9f48283506f8da6b08db3acbb175add8d2c111c1a8ea3ed6152e30fcefbf9687"
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
