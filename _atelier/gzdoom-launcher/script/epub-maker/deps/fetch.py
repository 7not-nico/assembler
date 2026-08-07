"""IO operations — network, filesystem, subprocess. The impurity ring."""

import asyncio
import subprocess
import urllib.request
import zipfile

from deps.prepare import slug
from schema import const

HEAD = {"User-Agent": "epub-maker/0.1 (+https://github.com/7not-nico/assembler)"}


def grab(page, base, dest, timeout, tries):
    """Download one page into dest; return True on success."""
    url = f"{base}/{page}"
    for _ in range(tries):
        try:
            req = urllib.request.Request(url, headers=HEAD)
            with urllib.request.urlopen(req, timeout=timeout) as resp:
                data = resp.read()
            (dest / f"{slug(page)}.html").write_bytes(data)
            return True
        except OSError:
            continue
    return False


class Fetch:
    """Awaitable download unit — runs grab off-loop, resolves to bool."""

    def __init__(self, page, base, dest, timeout, tries):
        self.page = page
        self.base = base
        self.dest = dest
        self.timeout = timeout
        self.tries = tries

    def __await__(self):
        return asyncio.to_thread(
            grab, self.page, self.base, self.dest, self.timeout, self.tries
        ).__await__()


async def collect(pages, base, dest, workers):
    """Await all page fetches concurrently; return the count of successes."""
    sem = asyncio.Semaphore(workers)

    async def one(fetch):
        async with sem:
            return await fetch

    results = await asyncio.gather(
        *(one(Fetch(page, base, dest, const.Timeout, const.Tries)) for page in pages)
    )
    return sum(results)


def parallel(pages, base, dest, workers):
    """Fetch pages concurrently via the async collect; sync bridge."""
    return asyncio.run(collect(pages, base, dest, workers))


def convert(src, out, flags):
    """Run pandoc over the book html into the epub."""
    argv = [
        "pandoc",
        str(src),
        "-f",
        "html",
        "-t",
        "epub3",
        "-o",
        str(out),
        *flags,
    ]
    subprocess.run(argv, check=False)


def verify(path):
    """Return True when the epub archive is intact."""
    try:
        with zipfile.ZipFile(path) as z:
            intact = z.testzip() is None
            mime = z.read("mimetype") == b"application/epub+zip"
        return intact and mime
    except OSError, KeyError:
        return False
