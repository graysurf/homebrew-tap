class AgentWorkspaceLauncher < Formula
  desc "Host-native workspace lifecycle CLI"
  homepage "https://github.com/graysurf/agent-workspace-launcher"
  version "1.1.5"
  license "MIT"
  on_macos do
    on_arm do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.5/agent-workspace-launcher-v1.1.5-aarch64-apple-darwin.tar.gz"
      sha256 "b86088a45ff2abbebb4ad56fa9449ae83bddeb47fd2f3e3217286030b25f7166"
    end
    on_intel do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.5/agent-workspace-launcher-v1.1.5-x86_64-apple-darwin.tar.gz"
      sha256 "d5d2489aea01dcd403c3bb3fa7339729fa0ed6b58eab8be4fe87542cbe4c6d0b"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.5/agent-workspace-launcher-v1.1.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cedbf17f77eced36aabe2789bf47476020bb6adbe3e6183b70b5e240afa9d785"
    end
    on_intel do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.5/agent-workspace-launcher-v1.1.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "82e953bfa09b4fb33eecb409d4a1d03d2a93829a9c097a17f4e907264e3b49a5"
    end
  end
  def install
    bin.install "bin/agent-workspace-launcher"
    bin.install "bin/awl"
    pkgshare.install "scripts/awl.bash"
    pkgshare.install "scripts/awl.zsh"

    bash_completion.install "completions/agent-workspace-launcher.bash" => "agent-workspace-launcher"
    zsh_completion.install "completions/_agent-workspace-launcher"
  end

  def caveats
    <<~EOS
      Optional zsh wrapper source:
        source "#{opt_pkgshare}/awl.zsh"
    EOS
  end

  test do
    system "#{bin}/agent-workspace-launcher", "--help"
    system "#{bin}/awl", "--help"
  end
end
