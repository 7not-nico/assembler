"""Fixture tests — pure functions and the merge rule against sample files."""

import asyncio
import inspect
import sys
from pathlib import Path

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root))

from deps import count, discover, emit, extract, fetch, prepare, split  # noqa: E402
from schema import const  # noqa: E402

sample = root / "fixture" / "sample"


def check(name, cond):
    """Assert one fixture expectation and print the outcome."""
    if not cond:
        raise AssertionError(f"FAIL: {name}")
    print(f"ok   {name}")


def run():
    """Exercise links, slug, mains, probe, chapters, and the merge rule."""
    toc = (sample / "toc.html").read_text()
    pages = discover.links(toc)
    check("links sorted unique", pages == ["Actor.html", "Hidden.html", "State.html"])
    check("slug flat", prepare.slug("Api/Base/Actor.html") == "Api_Base_Actor.html")
    book = (sample / "print.html").read_text()
    check("chapters count", count.chapters(book) == 2)
    hidden = extract.mains((sample / "Hidden.html").read_text())
    mark = count.probe(hidden)
    check("probe present", mark.startswith("<h1>Hidden</h1>"))
    check("merge rule", mark not in book)
    check("no dup rule", count.probe(extract.mains(book)) is not None)
    check("schema anchors", const.Out.name == "ZScript.epub")
    check("pandoc flags", "--toc" in const.Pandoc)

    role = (sample / "role-main.html").read_text()
    body = extract.mains(role)
    check("role-main fallback", "<h1>3. Data model" in body)
    check("section balanced", "<h2>3.1 Objects" in body)
    flat = extract.flatten(body)
    check("flatten strips sections", "<section" not in flat and "</section>" not in flat)
    clean = prepare.clean(flat)
    check("clean drops pilcrow", "&#182;" not in clean and "headerlink" not in clean)
    check("title extracted", prepare.title(clean) == "3. Data model")
    check("slugify", prepare.slugify(prepare.title(clean)) == "data-model")
    check("emit ddl", "CREATE TABLE IF NOT EXISTS page_sources" in emit.emit([]))
    sql = emit.emit([("page.html", "01-page.html", "Page", 1, 10, "aa")])
    check("emit seed row", "('page.html','01-page.html','Page',1,10,'aa')" in sql)

    # three-tier skeleton — main heading, heading, sub heading; folding
    doc = ("<h1>Introduction</h1><p>a</p><h2>Notes</h2><p>b</p>"
           "<h3>WebAssembly</h3><p>c</p><h4>deep</h4><p>d</p><h2>Second</h2><p>e</p>")
    tiers = split.sections(doc)
    check("tier levels", [(t[0], t[1]) for t in tiers] ==
          [(1, "Introduction"), (2, "Notes"), (3, "WebAssembly"), (2, "Second")])
    check("h1 folds h2+h3", "<h2>Notes</h2>" in tiers[0][2] and "<h3>WebAssembly</h3>" in tiers[0][2])
    check("h2 folds h3+h4", "<h3>WebAssembly</h3>" in tiers[1][2] and "<h4>deep</h4>" in tiers[1][2])
    check("h3 is leaf", tiers[2][2].count("<h3") == 1 and "<h4" in tiers[2][2] and "<h2>" not in tiers[2][2])
    check("h2 stops at next h2", "Second" not in tiers[1][2])
    check("sections sql", "CREATE TABLE IF NOT EXISTS section_sources" in emit.sections([]))
    check("demote bumps", split.demote("<h1>A</h1><h2>B</h2><h3>C</h3><h4>D</h4>") ==
          "<h2>A</h2><h3>B</h3><h4>C</h4><h4>D</h4>")
    check("strip h1", split.strip_h1("<h1>T</h1><p>x</p>") == "<p>x</p>")
    check("strip h1 anchor prefix",
          split.strip_h1('<span id="library-intro"></span><h1>T</h1><p>x</p>') == "<p>x</p>")

    # domains — every toctree-l1 entry is a domain (heading-format/libdomain.md)
    idx_html = (sample / "index.html").read_text()
    ent = discover.entries(idx_html)
    check("entries ordered", [t for t, _, _, _ in ent] ==
          ["Introduction", "Built-in Functions", "Built-in Constants",
           "Text Processing Services"])
    check("builtin separate", ent[1] == ("Built-in Functions", "functions.html", [], False))
    check("builtin constants separate", ent[2] == ("Built-in Constants", "constants.html", [], False))
    check("anchor child dropped", ent[0] == ("Introduction", "intro.html", [], False))
    check("category children", ent[3] ==
          ("Text Processing Services", "text.html",
           [("string.html", "string — Common string operations"),
            ("re.html", "re — Regular expression operations")], True))
    check("all entries domains", [t for t, _, _ in discover.domains(idx_html)] ==
          ["Introduction", "Built-in Functions", "Built-in Constants",
           "Text Processing Services"])

    # awaitable objects — fetch ring (grab stubbed, no network)
    probe = fetch.Fetch("p.html", "https://stub.invalid", sample, const.Timeout, const.Tries)
    check("fetch is awaitable", inspect.isawaitable(probe))
    check("collect is coroutine fn", inspect.iscoroutinefunction(fetch.collect))
    it = probe.__await__()
    check("await yields iterator", iter(it) is it)
    it.close()
    sig = inspect.signature(fetch.grab)
    check("grab no default tries", sig.parameters["tries"].default is inspect.Parameter.empty)

    def stub(page, base, dest, timeout, tries):
        return True

    real = fetch.grab
    fetch.grab = stub
    try:
        check("await fetch resolves", asyncio.run(probe) is True)
        done = asyncio.run(
            fetch.collect(["a.html", "b.html"], "https://stub.invalid", sample, const.Parallel)
        )
        check("collect counts", done == 2)
        check(
            "parallel bridges",
            fetch.parallel(["a.html"], "https://stub.invalid", sample, const.Parallel) == 1,
        )
    finally:
        fetch.grab = real


if __name__ == "__main__":
    run()
