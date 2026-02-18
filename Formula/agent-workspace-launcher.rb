class AgentWorkspaceLauncher < Formula
  desc "Host-native workspace lifecycle CLI"
  homepage "https://github.com/graysurf/agent-workspace-launcher"
  version "1.1.4"
  license "MIT"
  on_macos do
    on_arm do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.4/agent-workspace-launcher-v1.1.4-aarch64-apple-darwin.tar.gz"
      sha256 "6bf446fb756c8c4c6f6fe19c0d91121421c3a42fad7270cb533b53e363ddb575"
    end
    on_intel do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.4/agent-workspace-launcher-v1.1.4-x86_64-apple-darwin.tar.gz"
      sha256 "b994c291bf7e072d5c8881147f1be7682bd7f2f50dffaa0cbc98c21c076e6a87"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.4/agent-workspace-launcher-v1.1.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "562632dc814b679e03847c1e32c67683d76fc0dd74095d83fbad3cffd07455b9"
    end
    on_intel do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.4/agent-workspace-launcher-v1.1.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fa5b38a5643b5e92af86c93f1981436afa21d20580585cc1dfa8bcb76a979dbf"
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
