"""Pure extraction functions — deterministic, no side effects."""

import re

LINK = re.compile(r'href="([^"]+\.html)"')
MAIN = re.compile(r"<main>(.*?)</main>", re.S)
H1 = re.compile(r"<h1")
H1TEXT = re.compile(r"<h1>(.*?)</h1>", re.S)
SPACE = re.compile(r"\s+")
DIV = re.compile(r"<(/?)div\b", re.I)
SECTION = re.compile(r"<section\b", re.I)
CLOSE = re.compile(r"</section>", re.I)
HEADERLINK = re.compile(r'<a class="headerlink"[^>]*>.*?</a>', re.S)


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


def slug(path):
    """Return the file-safe key for a page path."""
    return path.replace("/", "_")


def section(html):
    """Return the inner content of the role='main' container (balanced divs)."""
    start = html.find('role="main"')
    if start == -1:
        return ""
    gt = html.find(">", start)
    if gt == -1:
        return ""
    depth = 1
    i = gt + 1
    while True:
        tag = DIV.search(html, i)
        if tag is None:
            return ""
        if tag.group(1) == "/":
            depth -= 1
            if depth == 0:
                return html[gt + 1 : tag.start()]
        else:
            depth += 1
        i = tag.end()


def mains(html):
    """Return the content of the main container — <main> or role='main' div."""
    found = MAIN.findall(html)
    if found:
        return "".join(found)
    return section(html)


def unwrap(html):
    """Remove one outer <section> wrapper so the h1 sits at document top level."""
    open_at = SECTION.search(html)
    if open_at is None:
        return html
    gt = html.find(">", open_at.start())
    if gt == -1:
        return html
    depth = 1
    i = gt + 1
    while depth:
        o = SECTION.search(html, i)
        c = CLOSE.search(html, i)
        if c is None:
            return html
        if o is not None and o.start() < c.start():
            depth += 1
            i = o.end()
        else:
            depth -= 1
            i = c.end()
    return html[gt + 1 : i - len("</section>")]


def clean(html):
    """Remove headerlink anchors (the pilcrow) from headings."""
    return HEADERLINK.sub("", html)


def title(html):
    """Return the first h1 heading text, tags stripped."""
    m = H1TEXT.search(html)
    if m is None:
        return ""
    return re.sub(r"<[^>]+>", "", m.group(1)).strip()


def slugify(name):
    """Slug a heading text: drop the leading number, lowercase, dashes."""
    text = re.sub(r"^\d+\.\s*", "", name).strip().lower()
    return re.sub(r"[^a-z0-9]+", "-", text).strip("-")


def probe(text):
    """Return a compact content fingerprint for dedupe."""
    return SPACE.sub(" ", text).strip()[:200]


def chapters(html):
    """Count the h1 headings in the book document."""
    return len(H1.findall(html))
