# homebrew-ns9

Homebrew tap for [NS9](https://github.com/ck8t/ns9) — the operational knowledge graph engine.

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
# Build a graph from any folder — no setup needed beyond ns9 init graph
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

## Requirements

- macOS 12 (Monterey) or later
- arm64 (Apple Silicon) or x86_64 (Intel)
- No Python installation required — NS9 bundles its own runtime

## Links

- [NS9 repository](https://github.com/ck8t/ns9)
- [Documentation](https://github.com/ck8t/ns9/wiki)
- [Release notes](https://github.com/ck8t/ns9/releases)
- [Report an issue](https://github.com/ck8t/ns9/issues)
