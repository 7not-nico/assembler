"""Pure extraction functions — deterministic, no side effects."""

import re

LINK = re.compile(r'href="([^"]+\.html)"')
MAIN = re.compile(r"<main>(.*?)</main>", re.S)
H1 = re.compile(r"<h1")
SPACE = re.compile(r"\s+")


def links(html):
    """Return the sorted unique page hrefs from sidebar markup."""
    found = [match.removeprefix("./") for match in LINK.findall(html)]
    keep = [
        page
        for page in found
        if not page.startswith(("http", "#", "../", "print")) and page != "index.html"
    ]
    return sorted(set(keep))


def slug(path):
    """Return the file-safe key for a page path."""
    return path.replace("/", "_")


def mains(html):
    """Return the concatenated main sections of a page."""
    return "".join(MAIN.findall(html))


def probe(text):
    """Return a compact content fingerprint for dedupe."""
    return SPACE.sub(" ", text).strip()[:200]


def chapters(html):
    """Count the h1 headings in the book document."""
    return len(H1.findall(html))
