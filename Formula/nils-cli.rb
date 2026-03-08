class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.5/nils-cli-v0.6.5-aarch64-apple-darwin.tar.gz"
      sha256 "77ea46040aaa5f3de6bea501745c08182b1040855350e8e72c17ec2b4b19eb58"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.5/nils-cli-v0.6.5-x86_64-apple-darwin.tar.gz"
      sha256 "61aeadd9549cec0746a115d20619a43cee9445b884499fd74e745fc817de0c65"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.5/nils-cli-v0.6.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e2dbb6c8f9e7e8ece438a7ee84065ec7041078c2f717b0e5660fee6461a53bba"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.5/nils-cli-v0.6.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "183bb0f949cc1842bb4423652660cb68c46ab059c6e3145d462482354ae97f7e"
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
