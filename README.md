# homebrew-ns9

Homebrew tap for NS9 — the operational knowledge graph engine.

## Install

```bash
brew tap ck8t/ns9
brew install ns9
```

Then install runtime dependencies:

```bash
ns9 init
```

## What is NS9?

NS9 parses your codebase, database schema, logs, and runbooks into an interactive knowledge graph.
Open `ns9-out/graph.html` in any browser — no Postgres, no LLMs required for the graph command.

```bash
ns9 init graph
ns9 generate graph /path/to/your/project
open ns9-out/graph.html
```

## Dependency groups

NS9 ships as a thin binary. Heavy dependencies are installed on demand by `ns9 init`.

| Group | Size | What it enables |
|---|---|---|
| `graph` | ~50 MB | `ns9 generate graph` — AST parsing, community detection |
| `server` | ~15 MB | `ns9 ingest`, `ns9 start api` — Postgres, pydantic, httpx |
| `ai` | ~420 MB | `ns9 start mcp`, semantic search — openai, anthropic, torch |
| `connectors` | ~25 MB | `ns9 ingest logs/ops` — kubernetes, azure, jira, confluence |

```bash
ns9 init                              # install everything
ns9 init graph                        # graph only
ns9 init graph server                 # graph + server
ns9 init graph server ai connectors   # everything
```

## Upgrade

```bash
brew update
brew upgrade ns9
ns9 init --upgrade
```

## Uninstall

```bash
brew uninstall ns9
brew untap ck8t/ns9
rm -rf ~/.ns9   # removes the dependency venv
```

---

## Release workflow (maintainers)

Binaries are built from the private dev repo and uploaded to [github.com/ck8t/ns9](https://github.com/ck8t/ns9) releases.
The ns9 repo is public and used exclusively as a release host for Homebrew.

### 1. Build binaries (from your private dev repo)

```bash
# arm64 (Apple Silicon)
bash packaging/build_mac.sh --graph

# Cross-compile for Intel if needed, or build on an Intel machine:
# bash packaging/build_mac.sh --graph
```

This produces:
- `dist/ns9-<version>-macos-arm64.tar.gz`
- `dist/ns9-<version>-macos-x86_64.tar.gz`

### 2. Publish the release to ck8t/ns9

```bash
VERSION=0.1.0

gh release create "v${VERSION}" \
  "dist/ns9-${VERSION}-macos-arm64.tar.gz" \
  "dist/ns9-${VERSION}-macos-x86_64.tar.gz" \
  --repo ck8t/ns9 \
  --title "v${VERSION}" \
  --notes "Release v${VERSION}"
```

### 3. Get the sha256 of each binary

```bash
shasum -a 256 dist/ns9-${VERSION}-macos-arm64.tar.gz
shasum -a 256 dist/ns9-${VERSION}-macos-x86_64.tar.gz
```

### 4. Update the formula

Edit `Formula/ns9.rb` — update `version`, the two `url` lines, and the two `sha256` values.

### 5. Commit and push

```bash
git add Formula/ns9.rb
git commit -m "Bump formula to v${VERSION}"
git push
```

Users will get the new version on their next `brew update && brew upgrade ns9`.

---

## Moving your dev source to a private repo

If your active development is in a private repo separate from `ck8t/ns9`, set it up once:

```bash
# From your local ns9 checkout:
git remote rename origin private

# Create a new private repo and push
gh repo create ck8t/ns9-dev --private --source=. --push

# ck8t/ns9 (public) is now only for releases — no code pushes needed there
```

---

## Requirements

- macOS 12 (Monterey) or later
- arm64 (Apple Silicon) or x86_64 (Intel)
- No Python installation required — NS9 bundles its own runtime

## Links

- [Documentation](https://github.com/ck8t/ns9)
- [Release notes](https://github.com/ck8t/ns9/releases)
- [Report an issue](https://github.com/ck8t/ns9/issues)
