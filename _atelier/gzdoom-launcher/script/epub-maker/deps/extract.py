"""Extract — content container extraction, pure."""

import re

MAIN = re.compile(r"<main>(.*?)</main>", re.S)
DIV = re.compile(r"<(/?)div\b", re.I)
SECTION = re.compile(r"<section\b", re.I)
CLOSE = re.compile(r"</section>", re.I)


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


def flatten(html):
    """Strip every <section> wrapper so headings sit flat for pandoc's TOC."""
    return re.sub(r"</?section[^>]*>", "", html, flags=re.I)
