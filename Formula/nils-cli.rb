class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.8/nils-cli-v0.3.8-aarch64-apple-darwin.tar.gz"
      sha256 "b76c9766b8b1ca1486816612c68645a0e439387af0da1d4f60ecd9644140e9e8"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.8/nils-cli-v0.3.8-x86_64-apple-darwin.tar.gz"
      sha256 "e32bab9c5c3d51d3945bcdf86eb16d78a43b971257a7db233f3d30b1040cb248"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.8/nils-cli-v0.3.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fc3d6254fd575c28bd1885f66f90ca4b2514203b4b7d33a9c0a2e914dc04f5cb"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.8/nils-cli-v0.3.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1ab44be6e44d915f4b21832281f87c05488e8091b4e24fe97f12ac5890253d9e"
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
