"""Enumerate — page link and domain extraction, pure."""

import re

LINK = re.compile(r'href="([^"]+\.html)"')
TITLE = re.compile(r"<[^>]+>")
# lib pattern: lowercase module name, em dash, definition
LIB = re.compile(r"^[a-z][a-z0-9_.]*\s+[—\-]\s+")


def links(html):
    """Return the sorted unique page hrefs from sidebar markup."""
    found = [match.removeprefix("./") for match in LINK.findall(html)]
    keep = [
        page
        for page in found
        if not page.startswith(("http", "#", "../", "/", "print"))
        and page != "index.html"
    ]
    return sorted(set(keep))


def ordered_links(html):
    """Return the unique page hrefs in first-appearance order from index markup."""
    seen = []
    for match in LINK.findall(html):
        page = match.removeprefix("./")
        if page.startswith(("http", "#", "../", "/", "print")):
            continue
        if page == "index.html" or page in seen:
            continue
        seen.append(page)
    return seen


def _blocks(src, cls):
    """Yield balanced <li class=cls> blocks from the toctree markup."""
    out, i = [], 0
    pat = re.compile(rf'<li class="{cls}"')
    while True:
        m = pat.search(src, i)
        if not m:
            return out
        start = m.start()
        depth, j = 0, start
        while True:
            o = src.find("<li", j)
            c = src.find("</li>", j)
            if c == -1 or (o != -1 and o < c):
                depth += 1
                j = o + 3 if o != -1 else c + 5
            else:
                depth -= 1
                j = c + 5
                if depth == 0:
                    break
        out.append(src[start:j])
        i = j


def entries(html):
    """Return ordered (title, page, kids, lib) per toctree entry.

    Every toctree-l1 entry begins a domain per heading-format/libdomain.md;
    nothing merges or filters. kids hold (href, title) pairs for .html
    child pages only; anchor sections live inside the entry's own page
    body and drop from kids. lib is True when a member follows the lib
    pattern (lowercase name — definition).
    """
    out = []
    for li in _blocks(html, "toctree-l1"):
        a = re.search(r'href="([^"]+)"[^>]*>(.*?)</a>', li, re.S)
        href, title = a.group(1), TITLE.sub("", a.group(2)).strip()
        kids = []
        for k in _blocks(li, "toctree-l2"):
            ka = re.search(r'href="([^"]+)"[^>]*>(.*?)</a>', k, re.S)
            kh = ka.group(1) if ka else ""
            if kh.endswith(".html") and not kh.startswith("#"):
                kids.append((kh.removeprefix("./"), TITLE.sub("", ka.group(2)).strip()))
        out.append((title, href, kids, any(LIB.match(x) for _, x in kids)))
    return out


def domains(html):
    """Return ordered (title, page, kids) per toctree entry.

    Every toctree-l1 entry is a domain; each domain file begins with a #
    heading (heading-format/libdomain.md). Anchor sections fold inside the
    entry's own page body; .html children demote one level beneath it.
    """
    return [(t, h, k) for t, h, k, _ in entries(html)]
