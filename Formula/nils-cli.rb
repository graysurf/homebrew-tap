class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.0/nils-cli-v0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "2bca9530a2453f30ba39f07a129e4b2ed8519c355a12ed3fa882111befe85fde"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.0/nils-cli-v0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "324bc4b3619b069d8aab5cc4424e149e995325f02013ae965801cd0bc57d22be"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.0/nils-cli-v0.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d976ea5a4ddd8f7c6afee22d6cb022a5aad102ec3fa4ddf1973f1c2b691e0f66"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.3.0/nils-cli-v0.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "de52da594bff64d521cbc8152f363d36fc73eb7da89dac205ee412002de638ae"
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
