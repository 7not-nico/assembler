"""Split — heading-anchored section extraction, pure.

Four-tier skeleton: domain (page), main headings (h1), heading (h2),
sub headings (h3). Each tier folds on the previous one: a section body
spans to the next heading of the same or higher tier, so it contains
every deeper heading. Deeper levels (h4+) fold into the h3 body.

Domain files follow the heading-format pattern: the domain title is an h1
and each member page demotes one level (h1 -> h2, h2 -> h3, h3 -> h4),
so a domain file reads `# Domain` then `## lib — definition`.
"""

import re

# Tier heading tags only; the domain (page) is the container that folds them.
HEADING = re.compile(r"<h([1-3])([^>]*)>(.*?)</h\1>", re.S)
TAGS = re.compile(r"<[^>]+>")


def sections(html):
    """Return (level, title, body) per tier heading; bodies fold deeper tiers."""
    matches = list(HEADING.finditer(html))
    out = []
    for i, m in enumerate(matches):
        level = int(m.group(1))
        title = TAGS.sub("", m.group(3)).strip()
        end = len(html)
        for nxt in matches[i + 1 :]:
            if int(nxt.group(1)) <= level:
                end = nxt.start()
                break
        body = html[m.start() : end]
        out.append((level, title, body))
    return out


def demote(html):
    """Bump tier headings one level deeper; h4+ pass through unchanged."""

    def bump(m):
        level = int(m.group(1)) + 1
        return f"<h{level}{m.group(2)}>{m.group(3)}</h{level}>"

    return HEADING.sub(bump, html)


LEAD = re.compile(r"^(?:\s|<[^/][^>]*></[^>]+>)*<h1[^>]*>.*?</h1>", re.S)


def strip_h1(html):
    """Return the body without its leading h1 heading."""
    head = LEAD.match(html)
    return html[head.end() :] if head else html
