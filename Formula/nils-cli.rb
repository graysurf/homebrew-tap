class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.5/nils-cli-v0.5.5-aarch64-apple-darwin.tar.gz"
      sha256 "21e44020ef7e158966bf08894a665409db541c66cd041a0ae5ae4a1a331f3654"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.5/nils-cli-v0.5.5-x86_64-apple-darwin.tar.gz"
      sha256 "2e9f658066a73a14d9c37a4f87e544cecdc14c32e6d81a53eb9689d05d01cc51"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.5/nils-cli-v0.5.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3654cd46bc7b6a42961ab0e58280166f9afdc8c185293f2452b86f7ced64c818"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.5/nils-cli-v0.5.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0f781be105ec14567bde0569e604af8539c8b67a2549b5e3bf6997bad0e55d55"
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
