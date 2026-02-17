class AgentWorkspaceLauncher < Formula
  desc "Host-native workspace lifecycle CLI"
  homepage "https://github.com/graysurf/agent-workspace-launcher"
  version "1.1.2"
  license "MIT"
  on_macos do
    on_arm do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.2/agent-workspace-launcher-v1.1.2-aarch64-apple-darwin.tar.gz"
      sha256 "80cb671b2a481adcfec6126952ad991d936f94fd6b04bd348ba3d397ec4ec377"
    end
    on_intel do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.2/agent-workspace-launcher-v1.1.2-x86_64-apple-darwin.tar.gz"
      sha256 "fc32c4ac0f4d494a93e2c9725c09c0009fa9faf4a8a435a083187f3841583f81"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.2/agent-workspace-launcher-v1.1.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "21191ebc4321a440792d4409385095649bd182c3b5924207d118e23b75bc3ebc"
    end
    on_intel do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.2/agent-workspace-launcher-v1.1.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d903fc74f6335f4d450f3bcbfd437d6d1f480033d958c079b5a2b5ea96b2faae"
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
