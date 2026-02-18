class AgentWorkspaceLauncher < Formula
  desc "Host-native workspace lifecycle CLI"
  homepage "https://github.com/graysurf/agent-workspace-launcher"
  version "1.1.6"
  license "MIT"
  on_macos do
    on_arm do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.6/agent-workspace-launcher-v1.1.6-aarch64-apple-darwin.tar.gz"
      sha256 "671933c143dce0edb1c1f4a81f9f4c816003639cd43446965fb645cd1f71ba20"
    end
    on_intel do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.6/agent-workspace-launcher-v1.1.6-x86_64-apple-darwin.tar.gz"
      sha256 "49ca8c6de80ce40e2ce2d1efb30d9f0c98e4c6bce5fbed8163c2c2a70384350f"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.6/agent-workspace-launcher-v1.1.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ceea47de089f95390767a427f30f15ed5cb513ff47b7bab2a4fd8b46972019bc"
    end
    on_intel do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.6/agent-workspace-launcher-v1.1.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fd75d1dc1fc5807a9e50d625db46d61467aa489945de1653ebcb067d66e5f621"
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
