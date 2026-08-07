"""LibRef — Python library reference epub: stage pages, skeleton, schema, epub."""

import hashlib
import shutil
import sys

from deps import discover, emit, extract, fetch, prepare, split
from schema import const


def main(argv):
    """Run the library reference build; return the process status."""
    args = [a for a in argv[1:] if a != "--skeleton"]
    base = args[0] if args else const.LibBase
    skeleton_only = "--skeleton" in argv
    tmp = const.LibTmp
    if tmp.exists():
        shutil.rmtree(tmp)
    tmp.mkdir()
    print("== fetch index ==")
    fetch.grab(const.LibIndex, base, tmp, timeout=const.PrintTimeout, tries=const.Tries)
    idx = tmp / f"{prepare.slug(const.LibIndex)}.html"
    if not idx.is_file():
        print("fetch failed — library unreachable", file=sys.stderr)
        return 1
    print("== enumerate pages ==")
    pages = discover.ordered_links(idx.read_text())
    print(f"pages: {len(pages)}")
    print("== fetch pages in parallel ==")
    fetched = fetch.parallel(pages, base, tmp, workers=const.Parallel)
    print(f"fetched {fetched} of {len(pages)}")
    print("== stage each page ==")
    staged = []
    for n, page in enumerate(pages, start=1):
        raw = tmp / f"{prepare.slug(page)}.html"
        if not raw.is_file():
            continue
        body = prepare.clean(extract.flatten(extract.mains(raw.read_text())))
        name = f"{n:02d}-{prepare.slugify(prepare.title(body))}.html"
        target = tmp / name
        target.write_text(body)
        staged.append((page, target))
        print(f"staged {name}")
    if not staged:
        print("fetch failed — no pages staged", file=sys.stderr)
        return 1
    print(f"staged {len(staged)} of {len(pages)}")
    staged_by_href = dict(staged)
    print("== derive domains from index toctree ==")
    catalog = discover.entries(idx.read_text())
    bucket = {}
    assigned = set()
    for i, (_, page, kids, _) in enumerate(catalog):
        hrefs = []
        for href, _ in kids:
            if href in staged_by_href and href not in assigned:
                hrefs.append(href)
                assigned.add(href)
        if page and page in staged_by_href:
            assigned.add(page)
        bucket[i] = hrefs
    members = [(catalog[i][0], catalog[i][1], bucket[i]) for i in range(len(catalog))]
    unmapped = [p for p in staged_by_href if p not in assigned]
    if unmapped:
        members.append(("Uncategorized", None, unmapped))
    print(f"domains: {len(members)}  unmapped: {len(unmapped)}")
    print("== split domains + headings into atomic files ==")
    skel = const.LibSkeleton
    skel.mkdir()
    rows = []
    order = 0
    for title, page, hrefs in members:
        order += 1
        parts = [f"<h1>{title}</h1>"]
        if page and page in staged_by_href:
            parts.append(split.strip_h1(staged_by_href[page].read_text()))
        for href in hrefs:
            parts.append(split.demote(staged_by_href[href].read_text()))
        body = "\n".join(parts)
        name = f"{order:04d}-d0-{prepare.slugify(title)}.html"
        (skel / name).write_text(body)
        rows.append(
            (
                order,
                page or hrefs[0] if hrefs else "",
                name,
                0,
                title,
                len(body.encode()),
                hashlib.sha256(body.encode()).hexdigest(),
            )
        )
        print(f"split {name}")
        for href in ([page] if page else []) + hrefs:
            for level, stitle, sbody in split.sections(
                staged_by_href[href].read_text()
            ):
                order += 1
                sname = f"{order:04d}-h{level}-{prepare.slugify(stitle)}.html"
                (skel / sname).write_text(sbody)
                rows.append(
                    (
                        order,
                        href,
                        sname,
                        level,
                        stitle,
                        len(sbody.encode()),
                        hashlib.sha256(sbody.encode()).hexdigest(),
                    )
                )
                print(f"split {sname}")
    const.LibSections.write_text(emit.sections(rows))
    print(f"wrote {const.LibSections} ({len(rows)} rows)")
    print("== schema: lib-pages.sql ==")
    page_rows = [
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
    const.LibSchema.write_text(emit.emit(page_rows))
    print(f"wrote {const.LibSchema} ({len(page_rows)} rows)")
    if skeleton_only:
        print("== skeleton done — epub deferred ==")
        print(f"PAGES={len(staged)}")
        print(f"DOMAINS={sum(1 for r in rows if r[3] == 0)}")
        print(f"SECTIONS={sum(1 for r in rows if r[3] > 0)}")
        print(f"H1={sum(1 for r in rows if r[3] == 1)}")
        return 0
    print("== unify domain files ==")
    unified = tmp / "unified.html"
    unified.write_text(
        "".join(
            (skel / name).read_text()
            for _, _, name, level, _, _, _ in rows
            if level == 0
        )
    )
    print("== convert with pandoc ==")
    fetch.convert(unified, const.LibOut, flags=const.LibPandoc)
    print("== verify epub ==")
    ok = fetch.verify(const.LibOut)
    size = const.LibOut.stat().st_size if const.LibOut.exists() else 0
    print(f"EPUB={const.LibOut}")
    print(f"PAGES={len(staged)}")
    print(f"DOMAINS={sum(1 for r in rows if r[3] == 0)}")
    print(f"SECTIONS={sum(1 for r in rows if r[3] > 0)}")
    print(f"H1={sum(1 for r in rows if r[3] == 1)}")
    print(f"FAILED={len(pages) - len(staged)}")
    print(f"BYTES={size}")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
