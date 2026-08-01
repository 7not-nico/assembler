---
name: use-playwright-network-storage
description: Reference for Playwright MCP network mocking and storage/auth tools
state-profile: stateless
---

**Trigger** — network request inspection, API mocking, cookie management, or auth state persistence

**Procedure**

- 1. Set up routes with `browser_route` before navigation for API mocking
- 2. Navigate and interact — mocked responses serve automatically
- 3. `browser_storage_state` to save auth state after login
- 4. `browser_set_storage_state` to restore in subsequent sessions

**Rules**

- `browser_network_requests` is core (always available); route/cookie/storage tools require capability flags
- `browser_route` takes glob patterns (`**/api/*`) for URL matching
- `browser_storage_state` saves cookies + localStorage to a JSON file
- `browser_cookie_clear` + `browser_reload` to test logged-out state

**Availability** — most tools require `--caps=network` or `--caps=storage` on server launch.

**Tools — network**

| Tool | Capability | Parameters | Notes |
|------|-----------|-----------|-------|
| `browser_network_requests` | core | `filter?`, `includeStatic?`, `includeHeaders?` | List network requests |
| `browser_route` | `network` | `pattern`, `status?`, `body?`, `contentType?`, `headers?`, `removeHeaders?` | Mock API responses |
| `browser_route_list` | `network` | — | List active mocked routes |
| `browser_unroute` | `network` | `pattern?` | Remove mock (omit to clear all) |
| `browser_network_state_set` | `network` | `state` (`online`/`offline`) | Test offline mode |

**Tools — storage**

| Tool | Capability | Parameters | Notes |
|------|-----------|-----------|-------|
| `browser_cookie_list` | `storage` | `domain?`, `path?` | List cookies |
| `browser_cookie_get` | `storage` | `name` | Get cookie by name |
| `browser_cookie_set` | `storage` | `name`, `value`, `domain?`, `path?`, `expires?`, `httpOnly?`, `secure?` | Set cookie |
| `browser_cookie_delete` | `storage` | `name` | Delete cookie |
| `browser_cookie_clear` | `storage` | — | Clear all cookies |
| `browser_localstorage_list` | `storage` | — | List localStorage keys |
| `browser_localstorage_get` | `storage` | `key` | Get localStorage value |
| `browser_localstorage_set` | `storage` | `key`, `value` | Set localStorage |
| `browser_localstorage_delete` | `storage` | `key` | Delete localStorage key |
| `browser_localstorage_clear` | `storage` | — | Clear all localStorage |
| `browser_sessionstorage_list` | `storage` | — | List sessionStorage keys |
| `browser_sessionstorage_get` | `storage` | `key` | Get sessionStorage |
| `browser_sessionstorage_set` | `storage` | `key`, `value` | Set sessionStorage |
| `browser_sessionstorage_delete` | `storage` | `key` | Delete sessionStorage key |
| `browser_sessionstorage_clear` | `storage` | — | Clear sessionStorage |
| `browser_storage_state` | `storage` | — | Save cookies + localStorage to JSON file |
| `browser_set_storage_state` | `storage` | `path` | Restore saved state |

**Gotchas**

- Route/network/storage tools unavailable without corresponding `--caps=` flag
- `browser_route` patterns use glob syntax (`**` for recursive match)
- `browser_storage_state` saves to MCP output directory
- localStorage/sessionStorage scoped to current origin
