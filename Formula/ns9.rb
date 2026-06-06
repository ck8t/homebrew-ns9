# Homebrew formula for the full NS9 CLI.
#
# This formula installs ns9 with ALL capabilities:
#   ns9 generate graph   — no Postgres, no LLMs, builds graph.html from any folder
#   ns9 ingest           — full ingestion pipeline (needs Postgres + .env)
#   ns9 start api / mcp  — REST API + MCP server
#
# Install:
#   brew tap ck8t/ns9
#   brew install ns9
#
# brew tap ck8t/ns9  →  clones github.com/ck8t/homebrew-ns9 into Homebrew's taps
# brew install ns9   →  finds Formula/ns9.rb in that repo and installs it
#
# After tapping once, brew upgrade ns9 / brew uninstall ns9 all work normally.
#
# How it works:
#   Homebrew manages a Python 3.11 virtualenv per formula (same as AWS CLI, Black, Poetry).
#   No Python setup required. No activation. Just `ns9` on your PATH.
#
# Note on sentence-transformers / torch:
#   torch (~400MB) is installed into the formula's private virtualenv.
#   The first time you use embeddings, ns9 downloads model weights (~400MB) to
#   ~/.cache/huggingface — this is a one-time download per machine.
#
# To publish this formula:
#   1. Create a GitHub repo: github.com/ck8t/homebrew-ns9
#   2. Put this file at Formula/ns9.rb in that repo
#   3. Push. Then users can: brew tap ck8t/ns9 && brew install ns9

class Ns9 < Formula
  include Language::Python::Virtualenv

  desc     "NS9 — operational knowledge graph engine for engineering teams"
  homepage "https://github.com/ck8t/ns9"
  url      "https://github.com/ck8t/ns9/archive/refs/tags/v0.1.0.tar.gz"
  sha256   "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
  license  "MIT"
  version  "0.1.0"

  depends_on "python@3.11"

  def install
    # Create an isolated virtualenv managed by Homebrew.
    # All ns9 deps go here — nothing pollutes the user's Python.
    venv = virtualenv_create(libexec, "python3.11")

    # Install ns9 with all extras via pip into the private virtualenv.
    # [full] = parsers + community + server + ai + connectors
    venv.pip_install_and_link buildpath, extras: ["full"]

    # Link the ns9 binary into Homebrew's bin/ so it's on PATH.
    bin.install_symlink libexec/"bin/ns9"
    bin.install_symlink libexec/"bin/ns9-mcp"
  end

  def post_install
    ohai "NS9 installed successfully!"
    ohai "Run: ns9 generate graph . --out ~/ns9-out"
    ohai "First embedding use downloads model weights (~400MB) to ~/.cache/huggingface"
  end

  test do
    assert_match "NS9 Knowledge Engine",        shell_output("#{bin}/ns9 --help")
    assert_match "generate",                    shell_output("#{bin}/ns9 --help")
    assert_match "graph",                       shell_output("#{bin}/ns9 generate --help")

    # Smoke test: generate graph on the formula's own source
    (testpath/"hello.py").write("def greet(): return 'hello'")
    system bin/"ns9", "generate", "graph", testpath.to_s, "--out", testpath/"out", "--languages", "python"
    assert_predicate testpath/"out/graph.html", :exist?
    assert_predicate testpath/"out/graph.json", :exist?
  end
end
