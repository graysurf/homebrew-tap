class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.9/nils-cli-v0.5.9-aarch64-apple-darwin.tar.gz"
      sha256 "a033bbe658ac39ae1a403796020da2499bb863a74f81e5f20bee3cccbf244560"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.9/nils-cli-v0.5.9-x86_64-apple-darwin.tar.gz"
      sha256 "67e78368894c4f8a0d6550702bc99ccca293376771c50d93b8df25538d5594c0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.9/nils-cli-v0.5.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6a1022fdbe435d5616f0f7370d406436729a61de1061f7dae8933979b8e8e8a9"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.5.9/nils-cli-v0.5.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a7ec898bcb2ce8c012b8713978df0bde7d08c5eba3b112348533e2056ef78c1c"
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
