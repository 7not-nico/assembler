"""Ref — Python reference epub: stage chapters, schema, unify, convert, verify."""

import hashlib
import shutil
import sys

from deps import count, discover, emit, extract, fetch, prepare
from schema import const


def main(argv):
    """Run the reference epub build; return the process status."""
    base = argv[1] if len(argv) > 1 else const.RefBase
    tmp = const.RefTmp
    if tmp.exists():
        shutil.rmtree(tmp)
    tmp.mkdir()
    print("== fetch index ==")
    fetch.grab(const.RefIndex, base, tmp, timeout=const.PrintTimeout, tries=const.Tries)
    idx = tmp / f"{prepare.slug(const.RefIndex)}.html"
    if not idx.is_file():
        print("fetch failed — reference unreachable", file=sys.stderr)
        return 1
    print("== enumerate chapters ==")
    pages = discover.ordered_links(idx.read_text())
    print(f"chapters: {len(pages)}")
    print("== fetch + stage each chapter ==")
    staged = []
    for n, page in enumerate(pages, start=1):
        if not fetch.grab(
            page, base, tmp, timeout=const.PrintTimeout, tries=const.Tries
        ):
            continue
        raw = tmp / f"{prepare.slug(page)}.html"
        body = prepare.clean(extract.flatten(extract.mains(raw.read_text())))
        name = f"{n:02d}-{prepare.slugify(prepare.title(body))}.html"
        target = tmp / name
        target.write_text(body)
        staged.append((page, target))
        print(f"staged {name}")
    if not staged:
        print("fetch failed — no chapters staged", file=sys.stderr)
        return 1
    print("== schema: pages.sql ==")
    rows = [
        (
            page,
            target.name,
            prepare.title(target.read_text()),
            n,
            target.stat().st_size,
            hashlib.sha256(target.read_bytes()).hexdigest(),
        )
        for n, (page, target) in enumerate(staged, start=1)
    ]
    const.RefSchema.write_text(emit.emit(rows))
    print(f"wrote {const.RefSchema} ({len(rows)} rows)")
    chapter_files = [target for _, target in staged]
    print("== unify chapters ==")
    unified = tmp / "unified.html"
    unified.write_text("".join(p.read_text() for p in sorted(chapter_files)))
    print("== convert with pandoc ==")
    fetch.convert(unified, const.RefOut, flags=const.RefPandoc)
    print("== verify epub ==")
    ok = fetch.verify(const.RefOut)
    size = const.RefOut.stat().st_size if const.RefOut.exists() else 0
    print(f"EPUB={const.RefOut}")
    print(f"CHAPTERS={len(chapter_files)}")
    print(f"H1={count.chapters(unified.read_text())}")
    print(f"FAILED={len(pages) - len(chapter_files)}")
    print(f"BYTES={size}")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
