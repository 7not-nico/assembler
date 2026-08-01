# acquire-assets — JSTOR Image Acquisition

**Purpose** — download open-access images from JSTOR, register in `assets/assets.db`.

## Procedure

1. Navigate to `jstor.uned.elogim.com` proxy
2. Extract `/stable/community.{N}` links with Download button
3. Batch-extract IIIF UUIDs — `playwright_browser_run_code_unsafe` to iterate community IDs
4. `curl` from `www.jstor.org` (proxy blocks direct curl)
5. Pipe JSON to `ruby assets/scripts/r0-acquire.rb` for DB registration
6. Rebuild FTS — `sqlite3 assets/assets.db`

## Image Size Handling

```text
Resolution       URL suffix                    Safe?
Full             full/full/0/default.jpg       403 if >10M px
Half (≤10M px)   full/1684,/0/default.jpg      Always safe
```

## CAPTCHA Handling

- UNED proxy reduces CAPTCHA frequency vs direct JSTOR
- CAPTCHA triggers after 5-15 navigations — batch extraction minimizes navigations
- When blocked: pause, report URL, prompt user per `RUL.CAPTCHA.GATE`

## Constraints

- Only open-access collections (Wellcome Collection, etc.)
- Never use Wellcome IIIF directly — only JSTOR IIIF endpoints
- `sqlite3` CLI only — `ruby assets/scripts/r0-acquire.rb` for registration
- `schema/urls.sql` holds INSERT-only backup
