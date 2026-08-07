"""Enumerate — page link extraction, pure."""

import re

LINK = re.compile(r'href="([^"]+\.html)"')


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
