class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.5/nils-cli-v0.4.5-aarch64-apple-darwin.tar.gz"
      sha256 "0559c2685a80b9561695c7e7a2e8ffef56f6300dff990599a0ecb94cfd5dab1d"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.5/nils-cli-v0.4.5-x86_64-apple-darwin.tar.gz"
      sha256 "fc40245d8f8ddccc2c6ec0dc3364b855992db29f1655e56852181d38df774c04"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.5/nils-cli-v0.4.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fafa4b17608c3159c62d24507054de50044fb969816629adb385ae7a8b00d99c"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.4.5/nils-cli-v0.4.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "231e511f23e230f123cc261d1fae6e614b96e5ac1d4e8aa75b31adc13071079f"
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
