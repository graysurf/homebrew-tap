class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.9/nils-cli-v0.1.9-aarch64-apple-darwin.tar.gz"
      sha256 "cdfb8788bfde597b22c2e484391d115d7a9443fa586fd393c67ee0f0357e9e8d"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.9/nils-cli-v0.1.9-x86_64-apple-darwin.tar.gz"
      sha256 "5881419c4b2bc7ab9af21ceb54843d79b397dec9ce0945414d7804d3a456e02f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.9/nils-cli-v0.1.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0e6331b6bd138b7626fdbb4a2ee458c4b502b29b2c9f78efaba7c008cfdad370"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.9/nils-cli-v0.1.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5fd8bb137728451e401f24139b1d8be64fc23f923ddc8cd312fbf55fcc548fda"
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
