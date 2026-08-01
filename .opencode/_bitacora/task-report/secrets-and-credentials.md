# Secrets & Credentials Audit

API keys, tokens, and credentials found in config files and system services.

## Plaintext Secrets (HIGH Severity)

| File | Line | Secret | Type | Risk |
|------|------|--------|------|------|
| `opencode.json` | 14 | `ctx7sk-37529d26-f970-4cac-bb42-ee41f4f92027` | Context7 MCP API key | Hardcoded in config file committed to repo (even though not a git repo, file is on disk) |
| `~/.config/systemd/user/clawdbot-gateway.service` | ~14 | `452338920bc11e016329d93d5d5a9b15624fea9a0060a69c` | Clawdbot Gateway auth token | Plaintext in systemd unit file, readable by any process |

## Environment Variable References (Low Severity)

| File | Variable | Service |
|------|----------|---------|
| `one-timers/medcodes/opencode.json` | `${env:BRAVE_API_KEY}` | Brave Search API |
| `one-timers/ludoteca/opencode.json` | `${env:BRAVE_API_KEY}` | Brave Search API |
| `study-sessions/thoughtlog/opencode.json` | `${env:BRAVE_API_KEY}` | Brave Search API |
| `common/bitacora/opencode.json` | `${env:BRAVE_API_KEY}` | Brave Search API |

These reference environment variables — no value exposed. Good practice.

## Unchecked Files

The following `opencode.json` files had no secrets:
- `homophones/opencode.json`
- `one-timers/comparisons-specs/gear-specs/opencode.json`
- `one-timers/comparisons-specs/camera-comparison/opencode.json`
- `one-timers/mcp-search-docs/opencode.json`
- `one-timers/CR-news-outlets/opencode.json`
- `study-sessions/linguistic/opencode.json`
- `findings/opencode.json`
- `common/nerdfont/opencode.json`
- `code-dives/darkestdungeon-code/opencode.json`

## Recommendations

1. **Move `CONTEXT7_API_KEY` to environment variable**: Replace the hardcoded value with `${env:CONTEXT7_API_KEY}` and set the env var in shell profile or systemd user service.
2. **Move `clawdbot-gateway` token to env**: Systemd unit files support `EnvironmentFile=` directive — load from a restricted-permission file instead of inline.
3. **Audit git history**: If this project was ever git-tracked, secrets may be in history. Run `git log --all -p` search for the key patterns.
4. **Rotate exposed secrets**: Both the Context7 API key and Clawdbot token are exposed on disk. Consider rotating them.
