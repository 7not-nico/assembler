---
description: Test burst-alert — seed file-change burst for MCP watcher to detect
subtask: true
---

Seed a file-change burst for `mcp-burst-alert` to detect.

1. Create 6 test files in `stud/`:
   ```
   for i in 1 2 3 4 5 6; do echo "test $i" > stud/zmeda-$i.txt; done
   ```

2. `mcp-burst-alert` background watcher detects ≥5 unique files modified within 2s and plays `objects/medabots-opening.mp3`.

3. Cleanup: `rm stud/zmeda-*.txt`
