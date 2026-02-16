class AgentWorkspaceLauncher < Formula
  desc "Docker wrapper for launching agent-ready workspaces"
  homepage "https://github.com/graysurf/agent-workspace-launcher"
  version "1.1.0"
  license "MIT"
  on_macos do
    on_arm do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.0/agent-workspace-launcher-v1.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "95c024e7dd8981dc9493270ae6d397d66dedd2c109edd274da1d77ba47038396"
    end
    on_intel do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.0/agent-workspace-launcher-v1.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "6cf2f5aea7a4b807326cdcff29bc8ad4eefbd45ac79b1b3eaf7536dc8f0bcfea"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.0/agent-workspace-launcher-v1.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4d8a2a370138235d9819c2d925f7811847f2fff8178e7090ed7beb910b3464de"
    end
    on_intel do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.0/agent-workspace-launcher-v1.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "09436f0e5e0f16f2e67a3173f8cc48883f04ad1d67233fbceffff000d93660de"
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
