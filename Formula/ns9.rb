# Homebrew formula for NS9.
#
# Source code: private repo (ck8t/_ns9)
# Release host: public repo (ck8t/ns9) — this formula downloads from there
#
# Install:
#   brew tap ck8t/ns9
#   brew install ns9
#   ns9 init          # install runtime deps into ~/.ns9/.venv/
#
# Release workflow: see README at github.com/ck8t/ns9

class Ns9 < Formula
  include Language::Python::Virtualenv

  desc     "NS9 — operational knowledge graph engine for engineering teams"
  homepage "https://github.com/ck8t/ns9"
  url      "https://github.com/ck8t/ns9/releases/download/v0.1.0/ns9-0.1.0.tar.gz"
  sha256   "67152d113ce54e4703d6544b241572beb3f9d68909df951a5194ed493369777c"
  license  "MIT"
  version  "0.1.0"

  depends_on "python@3.11"

  def install
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install_and_link buildpath
    bin.install_symlink libexec/"bin/ns9"
    bin.install_symlink libexec/"bin/ns9-mcp"
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
