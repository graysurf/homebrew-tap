class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.5/nils-cli-v0.2.5-aarch64-apple-darwin.tar.gz"
      sha256 "fea0b7c2d339d0fd6b4964440a9576d076f09c362e6662dbc5e1c50f18398a46"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.5/nils-cli-v0.2.5-x86_64-apple-darwin.tar.gz"
      sha256 "13da7263cd1d241e3571e64cbdbbf861230fe28a56f20ce1c5b1804860ff7bca"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.5/nils-cli-v0.2.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e38776f48eaf460b2509f628f7a73299f692000c618935791b78a9e4355bad1f"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.5/nils-cli-v0.2.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1cd65077efa70198436d0e4915dd7fa2e371ec05ce2fc31a6b89889f9530162d"
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
