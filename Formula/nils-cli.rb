class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.7/nils-cli-v0.5.7-aarch64-apple-darwin.tar.gz"
      sha256 "260ee17e64a71c1ca28fbecd99028536ed01eec7bd0e13214afd413d6c25dcbc"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.7/nils-cli-v0.5.7-x86_64-apple-darwin.tar.gz"
      sha256 "ffd381cdb6f8bda75819201ecb3f92ec442e212859a06af7b0bfc4570f27477a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.7/nils-cli-v0.5.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e77cb4c896050ae547c41f65ec5ee7cf81658ab0cc3a7463fcce9fc977863b13"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.7/nils-cli-v0.5.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "076debe98d4e590ac12aa168008c6ff6f3b70e0d9d426550b06866df005f0160"
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
