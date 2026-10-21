#!/usr/bin/env python3
"""Generate manifest.json from files tracked by Git."""

from __future__ import annotations

import json
import subprocess
from datetime import datetime, timezone
from pathlib import Path


REPOSITORY_ROOT = Path(__file__).resolve().parents[2]
MANIFEST_PATH = REPOSITORY_ROOT / "manifest.json"


def tracked_files() -> list[str]:
    result = subprocess.run(
        ["git", "-C", str(REPOSITORY_ROOT), "ls-files", "-z"],
        check=True,
        capture_output=True,
    )
    files = [
        path.decode("utf-8")
        for path in result.stdout.split(b"\0")
        if path
    ]
    return sorted(set(files) | {MANIFEST_PATH.name})


def main() -> None:
    manifest = {
        "schemaVersion": 1,
        "generatedAt": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "files": tracked_files(),
    }
    MANIFEST_PATH.write_text(
        json.dumps(manifest, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )


if __name__ == "__main__":
    main()
