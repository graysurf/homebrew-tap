class AgentWorkspaceLauncher < Formula
  desc "Docker wrapper for launching agent-ready workspaces"
  homepage "https://github.com/graysurf/agent-workspace-launcher"
  version "1.1.1"
  license "MIT"
  on_macos do
    on_arm do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.1/agent-workspace-launcher-v1.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "b1873416fda66cb7855ceb3b30e19e9fbfbef38b1426a610d5ec597fd66f51eb"
    end
    on_intel do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.1/agent-workspace-launcher-v1.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "2b5c3f35caeeb6a08619b3fc6b876e375c44ed4594aa6353623bf260c3d74f66"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.1/agent-workspace-launcher-v1.1.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "88330bc0485376755db8e89411a85ba99e4d1d38ccfc20535168a64817bf659e"
    end
    on_intel do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.1/agent-workspace-launcher-v1.1.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c0efaa1daa59cfe0a13a12ae2d4c78ea0cb46d36fd64f9b7cc2cba291c482475"
    end
  end
  def install
    bin.install "scripts/aws.bash" => "aws"
    (bin/"aws").chmod 0755
    pkgshare.install "scripts/aws.zsh"
  end

  def caveats
    <<~EOS
      Optional zsh wrapper source:
        source "#{opt_pkgshare}/aws.zsh"
    EOS
  end

  test do
    (testpath/"docker").write <<~SH
      #!/usr/bin/env bash
      exit 0
    SH
    chmod 0755, testpath/"docker"
    ENV.prepend_path "PATH", testpath

    system "#{bin}/aws", "--help"
  end
end
