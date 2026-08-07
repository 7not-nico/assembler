"""Count — document structure measurement, pure."""

import re

H1 = re.compile(r"<h1")
SPACE = re.compile(r"\s+")


def probe(text):
    """Return a compact content fingerprint for dedupe."""
    return SPACE.sub(" ", text).strip()[:200]


def chapters(html):
    """Count the h1 headings in the book document."""
    return len(H1.findall(html))
