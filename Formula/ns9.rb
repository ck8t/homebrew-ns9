# Homebrew formula for NS9 — installs a pre-built standalone binary.
#
# Source code: private repo (ck8t/_ns9)
# Release host: public repo (ck8t/ns9)
#
# The binary bundles Python + all ns9 commands. No Python required on the user's machine.
# Heavy deps (tree-sitter, torch, psycopg2, etc.) are installed on demand by `ns9 init`.
#
# Install:
#   brew tap ck8t/ns9
#   brew install ns9
#   ns9 init          # install runtime deps into ~/.ns9/.venv/
#
# Release workflow: see README at github.com/ck8t/ns9

class Ns9 < Formula
  desc     "NS9 — operational knowledge graph engine for engineering teams"
  homepage "https://github.com/ck8t/ns9"
  license  "MIT"
  version  "0.1.1"

  on_macos do
    on_arm do
      url    "https://github.com/ck8t/ns9/releases/download/v0.1.1/ns9-0.1.1-macos-arm64.tar.gz"
      sha256 "4ade2e4216f47fc25781710fe4b07d60b31bd51ce5cfe3ed1662194fa3bed9ea"
    end
    on_intel do
      url    "https://github.com/ck8t/ns9/releases/download/v0.1.1/ns9-0.1.1-macos-x86_64.tar.gz"
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
