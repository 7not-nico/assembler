# verify: regex-named-captures.md
require_relative "_helper"

PATLIB_ID = /\A([A-Z]{2,})((?:\.[A-Z][A-Z0-9.\/-]*)+)/

# --- match + branch ---
id = "TERM.CRYPTO.ZEROKNOWLEDGEPROOF"
m = id.match(PATLIB_ID)
assert(m ? m[1] : nil, "TERM", "match prefix TERM")

id2 = "CON.MATH.FORMALPROOF"
m2 = id2.match(PATLIB_ID)
assert(m2 ? m2[1] : nil, "CON", "match prefix CON")

id3 = "invalid"
m3 = id3.match(PATLIB_ID)
assert(m3 ? true : false, false, "no match on lowercase")

# --- \A / \z anchors ---
ANCHORED = /\A[A-Z]+\z/
assert("ABC".match?(ANCHORED), true, "\\A...\\z matches ABC")
assert("AB\nC".match?(ANCHORED), false, "\\A...\\z fails multiline")

# --- frontmatter extraction ---
text = "---\nid: TEST\n---\nbody"
fm_re = /\A---\s*\n(.*?)\n---\s*\n/m
m4 = text.match(fm_re)
assert(m4 ? true : false, true, "frontmatter match")
assert(m4 ? m4[1].strip : nil, "id: TEST", "frontmatter capture")

# --- backmatter extraction ---
text2 = "body\n---\nid: TEST2\n---"
bm_re = /---\s*\n(.*?)\n---\s*\z/m
m5 = text2.match(bm_re)
assert(m5 ? true : false, true, "backmatter match")
assert(m5 ? m5[1].strip : nil, "id: TEST2", "backmatter capture")

# --- safe_load symbolize_names ---
require "yaml"
yaml_str = "id: FOO\ntitle: Bar\n"
parsed = YAML.safe_load(yaml_str, permitted_classes: [Date], symbolize_names: true)
assert(parsed[:id], "FOO", "symbolize_names id")

report "ruby-regex"
