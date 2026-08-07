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
