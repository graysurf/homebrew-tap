class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.10/nils-cli-v0.2.10-aarch64-apple-darwin.tar.gz"
      sha256 "414b6b50bd6aa527cb7618c8552b408e0f2f707440e85ea772fee9eae5cf8a65"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.10/nils-cli-v0.2.10-x86_64-apple-darwin.tar.gz"
      sha256 "0fc98ff851142a38846f0e066ff3157b5ff3759484d466bffceb6cfa09be10c4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.10/nils-cli-v0.2.10-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "96ce6341694c7c218b9516bb09c9be338cafa0ddeec8a1a7b2ec66e99197e9e6"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.2.10/nils-cli-v0.2.10-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "880633b37b145c4ecb85993a950a5ebe134b01c664f021db0844473f71e69313"
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
