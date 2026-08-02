---
name: knowledge-ruby
description: Use this skill when answering Ruby functional programming questions — it references knowledge/ as the authoritative source for atomic Ruby programming knowledge files
state-profile: stateless
---

**Procedure**

0. Read the relevant atomic file from `knowledge/ruby/` — when asked about Ruby, match the topic to its file:

   | File | Covers |
   |------|--------|
   | `proc.md` | Creation, invocation, key methods, arity |
   | `lambda.md` | Lambda vs non-lambda — 5 differences |
   | `closure.md` | Closures, scope capture, binding, orphaned |
   | `composition.md` | Function composition — `>>`/`<<`, pipelines |
   | `curry.md` | Currying, partial application |
   | `anonymous-params.md` | `it`, `_1`..`_9` implicit params |
   | `to-proc.md` | Conversion protocol — Symbol, Method, Hash |
   | `string.md` | Creation, bang convention |
   | `string-slice.md` | `[]`, `slice`, `[]=`, `slice!` — 5 forms |
   | `string-substitution.md` | `sub`/`gsub`, patterns, back-refs, block |
   | `string-query.md` | Querying: length, include?, match, encoding |
   | `string-case.md` | Casing: upcase, downcase, capitalize, swapcase |
   | `string-modify.md` | Mutation: insert, clear, delete, replace, tr |
    | `string-encoding.md` | Encoding: valid?, encode, force_encoding, scrub |
    | `string-convert.md` | Conversion: to_i, to_f, to_sym, split, chars |
    | `symbol.md` | Symbol identity, querying, conversion, to_proc |
    | `array.md` | Creation, indexing |
    | `array-access.md` | Fetching: [], slice, fetch, take, drop, assoc |
    | `array-add.md` | Adding: push, <<, unshift, insert, concat, fill |
    | `array-remove.md` | Removing: pop, shift, delete, compact, uniq |
    | `array-query.md` | Querying: length, include?, any?, all?, empty? |
    | `array-transform.md` | Transforming: map, select, sort, reverse, flatten |
    | `array-set.md` | Set ops: |, &, -, union, intersection, difference |
    | `hash.md` | Creation, syntax, key facts |
    | `hash-access.md` | Fetching: [], fetch, dig, keys, values, assoc |
    | `hash-default.md` | Default values, default proc patterns |
    | `hash-modify.md` | Mutation: []=, merge, delete, clear, compact! |
    | `hash-query.md` | Querying: size, include?, key?, value?, empty? |
    | `hash-transform.md` | Transforming: transform_keys, select, slice, invert |
    | `hash-iterate.md` | Iterating: each, each_key, each_value |
    | `hash-key.md` | Key equivalence, custom keys, rehash, compare_by_identity |
    | `integer.md` | Creation, literals, constants |
    | `integer-arithmetic.md` | +, -, *, /, **, %, div, divmod, remainder |
    | `integer-bitwise.md` | &, \|, ^, ~, <<, >>, [], allbits?, bit_length |
    | `integer-compare.md` | <, <=, ==, >, >=, <=>, eql? |
    | `integer-convert.md` | to_s, to_f, chr, digits, ceil, floor, round, abs, Integer.sqrt |
    | `integer-iterate.md` | times, upto, downto, succ, pred |
    | `float.md` | Creation, constants |
    | `float-convert.md` | to_f, Kernel#Float, safe parse, format, predicates |
    | `enumerable.md` | Overview, include, each requirement |
    | `enumerable-query.md` | all?, any?, none?, one?, include?, count, find |
    | `enumerable-filter.md` | select, reject, grep, grep_v, partition |
    | `enumerable-group.md` | group_by |
    | `enumerable-tally.md` | tally |
    | `enumerable-map.md` | map, flat_map, filter_map |
    | `enumerable-slice.md` | each_slice, each_cons |
    | `enumerable-take.md` | first, take, drop |
    | `enumerable-iterate.md` | each_with_index, map.with_index, reverse_each, cycle |
    | `enumerable-sort.md` | sort, sort_by, min, max, minmax |
    | `enumerable-reduce.md` | reduce/inject, each_with_object |
    | `enumerable-chain.md` | chunk, slice_before, slice_after, slice_when |
    | `enumerable-uniq.md` | uniq |
    | `enumerable-zip.md` | zip |
    | `enumerable-to-hash.md` | to_h |
    | `enumerable-lazy.md` | lazy chains |
    | `file.md` | File.open, modes |
    | `file-read.md` | File.read, readlines, foreach, ARGF |
    | `file-write.md` | File.write, puts, print, Tempfile |
    | `file-path.md` | Pathname, Dir.glob, File.join, FileUtils |
    | `file-query.md` | exist?, file?, directory?, size, zero?, fnmatch? |
    | `file-meta.md` | File::Stat, chmod, rename, link |
    | `file-io-seek.md` | seek, tell, pos, rewind |
    | `file-io-binary.md` | pack, unpack, binread, binwrite |
    | `file-io-encoding.md` | encoding modes, transcoding |
    | `file-io-copy.md` | IO.copy_stream |
    | `regexp.md` | Creation, options, interpolation, timeout, ReDoS |
    | `regexp-match.md` | =~, match, match?, MatchData, $~, $& |
    | `regexp-capture.md` | Named, non-capturing, lookahead/behind, atomic, absence |
    | `regexp-sub.md` | sub, gsub, backreferences, block, hash, captures |
    | `regexp-scan.md` | scan, split, partition, rpartition |
    | `regexp-char.md` | \d \w \s, POSIX, Unicode properties, dot, classes |
    | `regexp-quant.md` | Greedy, lazy, possessive quantifiers |
    | `regexp-anchor.md` | ^ $ \A \z \b, lookaround, multi-line mode |
    | `exception.md` | Hierarchy, Exception vs StandardError, rescue default |
    | `exception-raise.md` | raise, fail, cause chaining, re-raise |
    | `exception-rescue.md` | rescue, specific types, inline rescue, retry |
    | `exception-ensure.md` | ensure, else, nested begin/end |
    | `exception-methods.md` | message, backtrace, cause, full_message, inspect |
    | `exception-types.md` | Common subclasses, custom exceptions |

1. Reference official Ruby docs for deeper detail: `docs.ruby-lang.org/en/3.4/{Class}.html`

2. Cross-reference with `CMD.ANCHOR.WORKFLOW` — prefer Playwright to fetch official docs when needed

**Gotchas**

- `knowledge/ruby/` is the authoritative source for atomic concepts — do not guess
- Each file covers one concern per MAX.ATOMIC.CONCERN
- Official docs at `docs.ruby-lang.org` are the canonical reference for method signatures and edge cases
