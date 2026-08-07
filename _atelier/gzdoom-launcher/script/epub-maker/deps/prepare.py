"""Prepare — content cleaning and naming, pure."""

import re

HEADERLINK = re.compile(r'<a class="headerlink"[^>]*>.*?</a>', re.S)
H1TEXT = re.compile(r"<h1>(.*?)</h1>", re.S)


def clean(html):
    """Remove headerlink anchors (the pilcrow) from headings."""
    return HEADERLINK.sub("", html)


def title(html):
    """Return the first h1 heading text, tags stripped."""
    m = H1TEXT.search(html)
    if m is None:
        return ""
    return re.sub(r"<[^>]+>", "", m.group(1)).strip()


def slug(path):
    """Return the file-safe key for a page path."""
    return path.replace("/", "_")


def slugify(name):
    """Slug a heading text: drop the leading number, lowercase, dashes."""
    text = re.sub(r"^\d+\.\s*", "", name).strip().lower()
    return re.sub(r"[^a-z0-9]+", "-", text).strip("-")
