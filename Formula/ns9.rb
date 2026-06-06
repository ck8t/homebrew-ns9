# Homebrew formula for NS9 — installs a pre-built binary.
#
# Source code lives in a private repo.
# Pre-built binaries are published as release assets on github.com/ck8t/ns9 (public).
#
# Install:
#   brew tap ck8t/ns9
#   brew install ns9
#   ns9 init          # install runtime deps into ~/.ns9/.venv/
#
# Release workflow: see README.md in this repo.

class Ns9 < Formula
  desc     "NS9 — operational knowledge graph engine for engineering teams"
  homepage "https://github.com/ck8t/ns9"
  license  "MIT"
  version  "0.1.0"

  on_macos do
    on_arm do
      url "https://github.com/ck8t/ns9/releases/download/v0.1.0/ns9-0.1.0-macos-arm64.tar.gz"
      sha256 "REPLACE_WITH_ARM64_SHA256"
    end
    on_intel do
      url "https://github.com/ck8t/ns9/releases/download/v0.1.0/ns9-0.1.0-macos-x86_64.tar.gz"
      sha256 "REPLACE_WITH_X86_64_SHA256"
    end
  end

  def install
    bin.install "ns9"
  end

  def post_install
    ohai "NS9 #{version} installed."
    ohai "Run `ns9 init` to install runtime dependencies into ~/.ns9/.venv/"
    ohai "Then: ns9 generate graph /path/to/your/project"
  end

  test do
    assert_match "ns9",      shell_output("#{bin}/ns9 --help")
    assert_match "generate", shell_output("#{bin}/ns9 --help")
  end
end
