class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.11/nils-cli-v0.2.11-aarch64-apple-darwin.tar.gz"
      sha256 "5135eedde06d8a938c5f8cbe341ae9084893895675a241a28bdd84fe9f011744"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.11/nils-cli-v0.2.11-x86_64-apple-darwin.tar.gz"
      sha256 "0ffe1ae7c46239386a9d43a491d258f51db13f502ea374406ef338db507537db"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.11/nils-cli-v0.2.11-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4f80c7ac6b8b54a7b903029cd5179b3dfc8425bfb73a3f696fe963ddb2322ab7"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.11/nils-cli-v0.2.11-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c3bd5e8eea93cc5919874da2447b1e29e9892c2146ea4f862b47c6307937b3b0"
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
