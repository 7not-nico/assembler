"""IO operations — network, filesystem, subprocess. The impurity ring."""

import subprocess
import urllib.request
import zipfile
from concurrent.futures import ThreadPoolExecutor, as_completed

from deps.extract import slug
from schema import const

HEAD = {"User-Agent": "epub-maker/0.1 (+https://github.com/7not-nico/assembler)"}


def grab(page, base, dest, timeout=const.Timeout, tries=2):
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


def parallel(pages, base, dest, workers=const.Parallel):
    """Fetch pages concurrently; return the count of successes."""
    with ThreadPoolExecutor(max_workers=workers) as pool:
        futures = [pool.submit(grab, page, base, dest) for page in pages]
        return sum(1 for future in as_completed(futures) if future.result())


def convert(src, out, flags=None):
    """Run pandoc over the book html into the epub."""
    if flags is None:
        flags = const.Pandoc
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
