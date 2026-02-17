class AgentWorkspaceLauncher < Formula
  desc "Host-native workspace lifecycle CLI"
  homepage "https://github.com/graysurf/agent-workspace-launcher"
  version "1.1.3"
  license "MIT"
  on_macos do
    on_arm do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.3/agent-workspace-launcher-v1.1.3-aarch64-apple-darwin.tar.gz"
      sha256 "ae8dfaf4d7043a7c9862750e05732d82badadf1d294d0e14768d411487c92ea1"
    end
    on_intel do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.3/agent-workspace-launcher-v1.1.3-x86_64-apple-darwin.tar.gz"
      sha256 "52ff75f5ef8e1d745290c0f869832bdba49c6e096d132dce2208ebf942c73226"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.3/agent-workspace-launcher-v1.1.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b142a61107b4babb2ff29362c7133fe4a388885b512143f3743c558ad67bd84e"
    end
    on_intel do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.3/agent-workspace-launcher-v1.1.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8fb5421396de7affd74e7e8f483ec4f8843985f5539264f0b5592938d9a02b92"
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
