#!/usr/bin/env python3
"""Bump a tap formula's url + sha256 to the latest PyPI sdist.

    python3 scripts/bump.py Formula/<name>.rb <pypi-project>

Rewrites the single `url` and `sha256` lines in place to point at the latest
sdist on PyPI. No-op (file untouched) when already current. Emits
`changed`/`version` to GITHUB_OUTPUT when run under Actions. Always exits 0
unless PyPI is unreachable or has no sdist.
"""
from __future__ import annotations

import json
import os
import re
import sys
import urllib.request


def main() -> None:
    formula, project = sys.argv[1], sys.argv[2]
    with urllib.request.urlopen(f"https://pypi.org/pypi/{project}/json") as r:
        data = json.load(r)
    version = data["info"]["version"]
    sdist = next(u for u in data["urls"] if u["packagetype"] == "sdist")
    url, sha = sdist["url"], sdist["digests"]["sha256"]

    src = open(formula).read()
    # Function replacements (not string) so url/sha are inserted literally,
    # never reinterpreted as regex backreferences.
    out = re.sub(r'^(\s*url\s+)"[^"]*"', lambda m: m.group(1) + f'"{url}"', src, count=1, flags=re.M)
    out = re.sub(r'^(\s*sha256\s+)"[^"]*"', lambda m: m.group(1) + f'"{sha}"', out, count=1, flags=re.M)
    changed = out != src
    if changed:
        open(formula, "w").write(out)

    print(f"{project}: PyPI={version} changed={changed}")
    gh_out = os.environ.get("GITHUB_OUTPUT")
    if gh_out:
        with open(gh_out, "a") as f:
            f.write(f"changed={'true' if changed else 'false'}\nversion={version}\n")


if __name__ == "__main__":
    main()
