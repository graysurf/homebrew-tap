class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.3/nils-cli-v0.4.3-aarch64-apple-darwin.tar.gz"
      sha256 "c58cbcf992d557747b151abfd4fc6adf86b387f2d8d907595023e4ede87db8c2"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.3/nils-cli-v0.4.3-x86_64-apple-darwin.tar.gz"
      sha256 "b2f015ae9bdeed48e13db1bad653b522b7f7f9af670dd5a6ce70de5cdb2d4e70"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.3/nils-cli-v0.4.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6d502e4b47973ac019141dfd638dcb399cef3ba64ff1f675c8cee168e78be4b5"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.3/nils-cli-v0.4.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cbad5bfcc56818650b71c4c47a261cbebae13a371b76adc343d8b5261ac9f64c"
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
