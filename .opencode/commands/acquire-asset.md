---
description: Download images from JSTOR into assets/ catalog and register in assets.db via Playwright + curl + Ruby scripts
subtask: true
---

Acquire image `$ARGUMENTS` from JSTOR into `assets/{domain}/` and register in `assets.db`

1. Navigate Playwright to `https://jstor.uned.elogim.com/stable/community.$ARGUMENTS`
2. Extract IIIF UUID from network requests (`/iiif/{date_path}/{uuid}_deflate.tif/info.json`)
3. Extract metadata via browser_find for Local Identifier, Creator, Work Type
4. Download via curl:
   ```
   curl -sL -o assets/{domain}/{slug}-community.$ARGUMENTS.jpg \
     "https://www.jstor.org/iiif/{date_path}/{uuid}_deflate.tif/full/full/0/default.jpg" \
     -A "Mozilla/5.0"
   ```
5. Register via Ruby: `ruby assets/scripts/r0-acquire.rb` with JSON metadata
6. Rebuild FTS: `sqlite3 assets/assets.db "DELETE FROM images_fts; INSERT INTO images_fts (id, title, source, identifier, domain) SELECT id, title, source, identifier, domain FROM images;"`

**Edge cases**: CAPTCHA blocks → follow `RUL.CAPTCHA.GATE`; maxArea limits → use `full/{maxWidth},/0/default.jpg`
