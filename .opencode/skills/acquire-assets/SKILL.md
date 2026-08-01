---
name: acquire-assets
description: Use this skill when downloading images from JSTOR for the asset catalog — it searches, navigates via Playwright, extracts IIIF UUIDs, downloads via curl, and registers in assets/assets.db via Ruby scripts
state-profile: hybrid
related: [use-playwright-core, use-playwright-network-storage, compose-web]
---

**Acquire Assets** — download images from JSTOR (jstor.uned.elogim.com proxy preferred) into `assets/{domain}/` and register in `assets/assets.db`.

Domain: `art` (oil paintings), `draw` (drawings, charcoal, watercolour, ink), `photo` (photographs)

## Procedure

1. **Search** — navigate to `https://jstor.uned.elogim.com/action/doBasicSearch?Query={term}&image_search_referrer=global&so=rel`

2. **Collect community IDs** — from search results snapshot, extract `/stable/community.{N}` links with "Download" button (open access)

3. **Batch-extract IIIF UUIDs** — using `playwright_browser_run_code_unsafe`, iterate through community IDs:
   - Listen for request to `/iiif/{date_path}/{uuid}_deflate.tif/info.json`
   - Navigate to `https://jstor.uned.elogim.com/stable/community.{N}`
   - Wait 3-4s for IIIF request
   - Extract uuid, date_path, title, Local Identifier from page

4. **Download** — via curl from `www.jstor.org` (proxy blocks direct curl):
   ```
   curl -sL -o assets/{domain}/{slug}-community.{N}.jpg \
     "https://www.jstor.org/iiif/{date_path}/{uuid}_deflate.tif/full/full/0/default.jpg" \
     -A "Mozilla/5.0"
   ```
   If 403 (maxArea exceeded — images >10M px), use half-resolution:
   ```
   curl -sL -o assets/{domain}/{slug}-community.{N}.jpg \
     "https://www.jstor.org/iiif/{date_path}/{uuid}_deflate.tif/full/1684,/0/default.jpg" \
     -A "Mozilla/5.0"
   ```
   `full/1684,/0/default.jpg` is always safe (≤10M px for any image)

5. **Register** — pipe JSON to `ruby assets/scripts/r0-acquire.rb`:
   ```json
   {"images":[{
     "id":"slug-community.N", "domain":"art",
     "filename":"slug-community.N.jpg",
     "original_url":"https://jstor.uned.elogim.com/stable/community.N",
     "source_url":"https://www.jstor.org/iiif/{date_path}/{uuid}_deflate.tif/full/full/0/default.jpg",
     "title":"Title from page",
     "source":"Wellcome Collection",
     "identifier":"V0012345",
     "license":"Creative Commons: Public Domain Mark",
     "width":N, "height":N, "file_size":N,
     "downloaded_at":"$(date -u +%Y-%m-%dT%H:%M:%SZ)",
     "creator":"Creator Name or null",
     "work_type":"Oil paintings",
     "collection":"Open: Wellcome Collection",
     "iiif_base_url":"https://www.jstor.org/iiif/{date_path}/{uuid}_deflate.tif",
     "urls":{
       "jstor":"https://jstor.uned.elogim.com/stable/community.N",
       "iiif_base":"https://www.jstor.org/iiif/{date_path}/{uuid}_deflate.tif",
       "iiif_full":"https://www.jstor.org/iiif/{date_path}/{uuid}_deflate.tif/full/full/0/default.jpg",
       "wellcome":"https://wellcomecollection.org/works/{id}"
     }}]}
   ```

6. **Rebuild FTS** — `sqlite3 assets/assets.db "DELETE FROM images_fts; INSERT INTO images_fts (id, title, source, identifier, domain) SELECT id, title, source, identifier, domain FROM images;"`

## CAPTCHA handling

When JSTOR returns "Access Check" (reCAPTCHA), follow `RUL.CAPTCHA.GATE`:
- Pause automated flow
- Report the blocked URL to the user
- Prompt user to solve the challenge in the browser session
- Resume after user confirms completion or page loads with HTTP 200

The UNED proxy (`jstor.uned.elogim.com`) reduces CAPTCHA frequency vs direct JSTOR.

## Batch IIIF extraction

Use `playwright_browser_run_code_unsafe` for efficient batch IIIF UUID extraction (5-10 IDs per batch to avoid CAPTCHA):

```js
async (page) => {
  const communityIds = [123, 456, 789, 101, 102];
  const results = [];
  for (const cid of communityIds) {
    let iiifUrl = null;
    let title = null;
    const handler = (req) => {
      const u = req.url();
      if (u.includes('/iiif/') && u.endsWith('/info.json') && !u.includes('wellcome')) {
        iiifUrl = u;
      }
    };
    page.on('request', handler);
    try {
      await page.goto('https://jstor.uned.elogim.com/stable/community.' + cid, { waitUntil: 'domcontentloaded', timeout: 20000 });
      await page.waitForTimeout(3000);
    } catch (e) {}
    page.off('request', handler);
    try { title = await page.title(); } catch(e) {}
    results.push({ community_id: cid, iiif_url: iiifUrl, title: title });
  }
  return JSON.stringify(results, null, 2);
}
```

Save output to JSON file, then pipe through `r0-batch-acquire.rb`:
```
cat iiif-batch.json | ruby assets/scripts/r0-batch-acquire.rb
```
The script handles download, dimension detection, domain classification, and DB registration.

## Metadata enrichment

After acquisition, enrich metadata fields from JSTOR community pages:

1. **Playwright extraction** — browse to each community page, extract `document.body.innerText`, pipe JSON to `r1-enrich.rb`:
   ```
   playwright_browser_evaluate → JSON → ruby assets/scripts/r1-enrich.rb
   ```
   Use `waitUntil: 'load'` + 4s delay for reliable metadata rendering (labels require full page load).

2. **Check coverage**:
   ```
   ruby assets/scripts/r1-enrich.rb --stats
   ruby assets/scripts/r1-enrich.rb --missing
   ```

## Gotchas

- CAPTCHA triggers after 5-15 page navigations — use batch scripts (`browser_run_code_unsafe`) to minimize navigations
- Wellcome Collection images are CC Public Domain Mark — always check license before downloading
- Images >10M px return 403 for `full/full` — use `full/1684,/0/default.jpg` (always safe)
- `www.jstor.org` works for curl downloads; proxy (`jstor.uned.elogim.com`) blocks direct curl
- Use `sqlite3` CLI only, never Bun — `ruby assets/scripts/r0-acquire.rb` for registration
- Only acquire from Open Access collections (Open: Wellcome Collection, etc.)
- Never use Wellcome IIIF directly — only JSTOR IIIF endpoints
- `schema/urls.sql` holds INSERT-only URL data backup — regenerate after batch: `sqlite3 assets/assets.db "SELECT 'INSERT INTO urls VALUES(''' || id || ''',''' || image_id || ''',''' || role || ''',''' || url || ''');' FROM urls ORDER BY id;" > assets/schema/urls.sql`
