class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.3/nils-cli-v0.3.3-aarch64-apple-darwin.tar.gz"
      sha256 "0b8584e464ebe3c2b269f2a34021538c6c362290fe5df2bc7d4f641169459980"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.3/nils-cli-v0.3.3-x86_64-apple-darwin.tar.gz"
      sha256 "f5f3638171d72076c628ffb713cf475f4349b3ac6920e15d5a83d2815cbaa6d5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.3/nils-cli-v0.3.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dc48adf815fa1afc4123c4bcb1b47c67aff6b28d0699c5eeaa6666fdf1eca76f"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.3/nils-cli-v0.3.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2377ae127f8e36fe0ba3f2ac1465b14604d3c3182de94d4a0255f9885eedcc10"
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
