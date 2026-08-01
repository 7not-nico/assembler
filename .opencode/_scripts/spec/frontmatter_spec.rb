# ring: 1 (PURE)
# depends-on: _rb/frontmatter
# tests: ParseFrontmatter, ParseBackmatter, ParseAll, NormalizeTags

require_relative "../_rb/loader"
require_relative "../_rb/frontmatter"

failures = 0

# ParseFrontmatter
text = "---\nid: MAX.TEST\ntags: [test]\n---\nbody"
fm = ParseFrontmatter.call(text)
if fm && fm[:id] == "MAX.TEST" && fm[:tags] == ["test"]
  puts "  ✓ ParseFrontmatter extracts frontmatter"
else
  puts "  ✗ ParseFrontmatter: expected id=MAX.TEST tags=[test], got #{fm.inspect}"
  failures += 1
end

# ParseFrontmatter returns nil for no frontmatter
fm = ParseFrontmatter.call("no frontmatter here")
if fm.nil?
  puts "  ✓ ParseFrontmatter returns nil for plain text"
else
  puts "  ✗ ParseFrontmatter: expected nil, got #{fm.inspect}"
  failures += 1
end

# NormalizeTags from comma string
fm = { tags: "a,b,c" }
NormalizeTags.call(fm)
if fm[:tags] == ["a", "b", "c"]
  puts "  ✓ NormalizeTags splits comma string"
else
  puts "  ✗ NormalizeTags: expected [a,b,c], got #{fm[:tags].inspect}"
  failures += 1
end

# NormalizeTags leaves array intact
fm = { tags: ["x"] }
NormalizeTags.call(fm)
if fm[:tags] == ["x"]
  puts "  ✓ NormalizeTags leaves array intact"
else
  puts "  ✗ NormalizeTags: expected [x], got #{fm[:tags].inspect}"
  failures += 1
end

# ParseBackmatter
text = "body\n---\nid: TERM.TEST\nreference: []\n---"
bm = ParseBackmatter.call(text)
if bm && bm[:id] == "TERM.TEST"
  puts "  ✓ ParseBackmatter extracts backmatter"
else
  puts "  ✗ ParseBackmatter: expected id=TERM.TEST, got #{bm.inspect}"
  failures += 1
end

# ParseAll
texts = ["---\nid: A\n---\n", "---\nid: B\n---\n"]
names = ["a", "b"]
entries = ParseAll.call(texts, names)
if entries.size == 2 && entries.first[:id] == "A"
  puts "  ✓ ParseAll parses multiple texts"
else
  puts "  ✗ ParseAll: expected 2 entries starting with A, got #{entries.size} entries"
  failures += 1
end

puts failures == 0 ? "ok — 6/6 pass" : "FAIL — #{failures} failures"
exit(failures)
