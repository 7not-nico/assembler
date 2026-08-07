"""Epub-maker — orchestrates fetch, merge, convert, verify for ZDoom docs."""

import sys
import tempfile
from pathlib import Path

from deps import count, discover, extract, fetch, prepare
from schema import const


def main(argv):
    """Run the epub build pipeline; return the process status."""
    base = argv[1] if len(argv) > 1 else const.Base
    with tempfile.TemporaryDirectory() as tmp:
        work = Path(tmp)
        print("== fetch print.html ==")
        book = work / f"{prepare.slug(const.PrintPath)}.html"
        toc = work / f"{prepare.slug(const.TocPath)}.html"
        fetch.grab(
            const.PrintPath, base, work, timeout=const.PrintTimeout, tries=const.Tries
        )
        fetch.grab(
            const.TocPath, base, work, timeout=const.PrintTimeout, tries=const.Tries
        )
        if not book.is_file() or not toc.is_file():
            print("fetch failed — site unreachable", file=sys.stderr)
            return 1
        print("== enumerate book pages ==")
        pages = discover.links(toc.read_text())
        print(f"book pages: {len(pages)}")
        print("== fetch all pages in parallel ==")
        page_dir = work / "page"
        page_dir.mkdir()
        fetched = fetch.parallel(pages, base, page_dir, workers=const.Parallel)
        print("== merge pages not in print.html ==")
        content = book.read_text()
        merged = 0
        body = []
        for page in pages:
            path = page_dir / f"{prepare.slug(page)}.html"
            if not path.is_file():
                continue
            main = extract.mains(path.read_text())
            mark = count.probe(main)
            if mark and mark not in content:
                body.append(main)
                merged += 1
        if body:
            content = content.replace("</body>", "".join(body) + "\n</body>")
        final = work / "final.html"
        final.write_text(content)
        print("== convert with pandoc ==")
        fetch.convert(final, const.Out, flags=const.Pandoc)
        print("== verify epub ==")
        ok = fetch.verify(const.Out)
        size = const.Out.stat().st_size if const.Out.exists() else 0
        print(f"EPUB={const.Out}")
        print(f"PAGES={len(pages)}")
        print(f"CHAPTERS={count.chapters(content)}")
        print(f"FETCHED={fetched}")
        print(f"FAILED={len(pages) - fetched}")
        print(f"MERGED={merged}")
        print(f"BYTES={size}")
        return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
