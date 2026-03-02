class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.2/nils-cli-v0.6.2-aarch64-apple-darwin.tar.gz"
      sha256 "b716ddc905083094e0cb3af836f154c3e99ad4d98ebb2f2b50c0d70c6d52ce29"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.2/nils-cli-v0.6.2-x86_64-apple-darwin.tar.gz"
      sha256 "9d5495270f63c9f9a73a9417f17f450e9c7c903b2d78c1e25f3a5c6d491ef01f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.2/nils-cli-v0.6.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5d5dd9ab79569e0a8b13da90c7a063dc87dd2ba3acbbeba30feb0e7f2226f842"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.2/nils-cli-v0.6.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8cefcaf63bcc945b4f7521c41024ba1f99558c25f124b455cf0b426b5822f9dd"
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
