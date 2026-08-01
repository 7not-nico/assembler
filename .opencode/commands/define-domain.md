---
description: Define purpose, audience, goal, and scope of a new DB workflow project
subtask: true
---

Define domain for `$ARGUMENTS`

1. Use question tool to identify domain: what real-world subject does this database capture?
2. Use question tool to define audience: who will query this DB? Offer self, team, public as options
3. Use question tool to state goal: reference, learning, tracking, research, or mix?
4. Use question tool to define scope boundaries: what is explicitly excluded?
5. Output manifest to `{project}/.opencode/manifests/domain.md`

**Output**

```yaml
project: $PROJECT_NAME
domain: $DOMAIN_DESCRIPTION
audience: $AUDIENCE
goal: $GOAL
out-of-scope:
  - $EXCLUSION
```
