class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/graysurf/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.5/nils-cli-v0.1.5-aarch64-apple-darwin.tar.gz"
      sha256 "baf45362b3659fdce241de34476d50c9c5ec3ac2fa46038b8fd9db1f8cebc9c7"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.5/nils-cli-v0.1.5-x86_64-apple-darwin.tar.gz"
      sha256 "f963e5cb619c7966e6b64fb6c87da40aef54c5a19de63fa73877f38cb1ebf136"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.5/nils-cli-v0.1.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cc72584607bca5fb54a78a48a7f5308cf2484efabfb73f860f3d8893710db227"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.1.5/nils-cli-v0.1.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f3b532b20b58689ba8839234ceef76d460c4f868b17ba98caee46a83ac72534f"
    end
  end

  def install
    bin.install Dir["bin/*"]
    zsh_completion.install Dir["completions/zsh/*"]
  end

  test do
    system "git", "init", testpath
    cd testpath do
      system "#{bin}/git-scope", "--help"
    end
  end
end
