"""Epub-maker constants — one PascalCase word per value."""

from pathlib import Path

Base = "https://zdoom-docs.github.io/staging"
Project = Path(__file__).resolve().parents[1]
Launcher = Path(__file__).resolve().parents[3]
Out = Launcher / "ZScript.epub"
PrintPath = "print.html"
TocPath = "ZScript.html"
Timeout = 12
Connect = 8
PrintTimeout = 60
Parallel = 16
ProbeLen = 200
Title = "ZDoom Docs — ZScript"
Author = "ZDoom Docs"
Pandoc = [
    "--metadata",
    f"title={Title}",
    "--metadata",
    f"author={Author}",
    "--toc",
    "--toc-depth=2",
]

# Python language reference epub (ref.py)
RefBase = "https://docs.python.org/3/reference"
RefIndex = "index.html"
RefTmp = Project / "tmp"
RefSchema = Project / "schema" / "pages.sql"
RefOut = Launcher / "PythonRef.epub"
RefTitle = "The Python Language Reference"
RefAuthor = "Python Software Foundation"
RefPandoc = [
    "--metadata",
    f"title={RefTitle}",
    "--metadata",
    f"author={RefAuthor}",
    "--toc",
    "--toc-depth=2",
    "--epub-chapter-level=1",
]
