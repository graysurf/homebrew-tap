class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.0/nils-cli-v0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "0f836806b334f12a5c446d57f15d7bcd19caf670d20a0dda7e921707e3ecfe8c"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.0/nils-cli-v0.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "f6ca086d36faf479b5e937629efecd5cc6b2d279373e16820548b3f2d980aac2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.0/nils-cli-v0.5.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d3947d5e3b104c6b3d82d32842e3ea997c77b1499be5ae19a56e7945ed1b094b"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.0/nils-cli-v0.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "baa5d413b27ad3db65ecfc7c012b56c29f72d3ff08034dc99348aeb9a279f7e0"
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
