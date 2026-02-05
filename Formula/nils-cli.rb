class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.4/nils-cli-v0.2.4-aarch64-apple-darwin.tar.gz"
      sha256 "55630b32b21988ec878d07d985e253ff7291d3a03c5fc703ad486026831944a8"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.4/nils-cli-v0.2.4-x86_64-apple-darwin.tar.gz"
      sha256 "7b877f3c4a832fa563993f9bf3ed3e5c4293e8be346e9755e66d3db9afde54fc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.4/nils-cli-v0.2.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "60bee4229878a3d1b12808c3a072a49527e41004ea7b5a812bed5bf1c258d0a4"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.4/nils-cli-v0.2.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8b05960925ff80e5e1d64660b050dd738881af4d1e250ed067e3619554c3145c"
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
