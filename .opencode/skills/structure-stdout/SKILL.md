---
name: structure-stdout
description: Use this skill when writing or composing scripts whose stdout feeds another step, a log wrapper, or a human terminal — structure stdout pipes so downstream consumers extract the most value. Reference NEX.ACQUIRE.PIPELINE for keyed-line stage handoff and NEX.TOOL.SEQUENCE for the audit output contract
state-profile: stateless
related: ["NEX.ACQUIRE.PIPELINE", "NEX.TOOL.SEQUENCE"]
---

**Purpose**

Structure stdout so every pipe consumer extracts maximum value. Emit keyed result lines (`KEY=value`) as the machine contract. Write diagnostics to stderr. Keep human text separate. Design every output stream for its consumer: orchestrator, log wrapper, or terminal.

**Design principles**

Apply these to every script's output:

1. **Emit one keyed result line** — print `KEY=value` as the final stdout line. Let the orchestrator parse it with `tail -1 | cut -d= -f2`. Print one line per script; use one key per run.

2. **Keep stdout machine-clean** — write parseable data to stdout. Stream progress text, banners, and summaries to stderr or a `--verbose` flag. Clean stdout keeps downstream parsing deterministic.

3. **Stream diagnostics to stderr** — route errors, warnings, and progress notes to stderr. Capture them with `2>` apart from the keyed line. Exit non-zero on failure.

4. **End with the result line** — print the keyed line last. Deterministic order lets `tail -1` find the contract every time. Prefix debug output earlier in the stream.

5. **Name keys for the consumer** — match key names to what the next step expects (`ROM=`, `PATH=`, `PID=`). Consistent keys across stages compose into pipelines per `NEX.ACQUIRE.PIPELINE`.

6. **Query with ripgrep** — use `rg` to extract keyed lines from logs and streams. `rg '^KEY=' log` finds the contract; `rg -P -o '^KEY=\K.*' log` yields the value (PCRE2 `\K`); `rg '^KEY=' log | cut -d= -f2` stays portable. Let `rg` replace `grep` in every extraction path — its regex engine, binary-skip, and exit-code semantics keep queries deterministic.

7. **Support log-wrapper streaming** — flow live output through `run-logged.sh` / `bitacora-log.sh`. Let the wrapper write the `# CMD:` header and append the exit status. Structure output so the header reads first, data streams, status lands last.

8. **Compute metrics with qalc** — emit raw numeric values as keys, then derive metrics with qalc. `qalc '256 * 4'` yields `1024`; `qalc '1024 / 896'` yields the aspect ratio. Verify derived figures against the raw keys — qalc output carries units and precision, so metric claims stay grounded. Structure metrics as `KEY=raw_value` lines plus a qalc-verified derived table.

**Procedure**

1. **Identify the consumers** — name who reads the stdout: orchestrator (keyed line), log wrapper (live stream), human (readable summary), or audit (pass/fail table). Shape each output part for its consumer.

2. **Separate the streams** — assign data to stdout, diagnostics to stderr, and human text to a flag or final summary. Give one purpose to each stream.

3. **Pick the key** — choose the `KEY` the next stage consumes. Use the same key name the downstream script reads. Emit the value as a single line free of `=` signs.

4. **Print the keyed line last** — emit the result line as the final stdout write. Guard it with the exit code: on failure print a diagnostic to stderr and exit non-zero before the line prints.

5. **Verify the pipe** — run the script piped into the consumer: `bash script.sh arg | tail -1` yields the keyed line; `2>err.log` captures diagnostics; the exit code propagates. Query the result with `rg '^KEY='`.

6. **Compose the pipeline** — feed the keyed line into the next stage per `NEX.ACQUIRE.PIPELINE`:
   ```bash
   key="$(bash scripts/{step}.sh "$ARG" | tail -1 | cut -d= -f2)" || exit 1
   ```
   Stop the chain when a stage fails; pass the extracted key forward. Extract keys from logs with `rg -P -o '^KEY=\K.*' log`.

7. **Compute the metrics** — run qalc on the raw keys to produce derived metrics:
   ```bash
   width="$(rg -P -o '^WIDTH=\K.*' "$LOG")"
   height="$(rg -P -o '^HEIGHT=\K.*' "$LOG")"
   qalc "$width * $height"        # total pixels
   qalc "$width / $height"        # aspect ratio
   qalc "$height * 4 / 3"         # TV-equivalent width
   ```
   Record each qalc result beside its raw keys; the derived metric cites the key it came from.

8. **Match the audit contract** — for audit-style output, follow `NEX.TOOL.SEQUENCE`: inventory lines, per-item pass/fail marks, summary counts, and a final score line.

**Output shape reference**

```
Consumer        stdout                          stderr
--------------  ------------------------------  -------------------------
orchestrator    KEY=value last line             diagnostics
log wrapper     streamed data                   appended status
human terminal  readable summary                progress notes
audit           pass/fail table + score         violation details
```

**Verification checklist**

- [ ] stdout carries parseable data; the final line reads `KEY=value`
- [ ] Diagnostics stream to stderr, captured with `2>`
- [ ] Failure exits non-zero before the keyed line prints
- [ ] `tail -1 | cut -d= -f2` extracts the key reliably
- [ ] `rg '^KEY='` queries the keyed line from any log
- [ ] Key names match the next stage's expectations
- [ ] Log wrapper writes the header, streams live, appends the status
- [ ] The pipeline feeds the keyed line forward; the chain stops on failure
- [ ] Raw values emit as keys; derived metrics compute with qalc
- [ ] Each qalc result cites the raw key it derives from

**Gotchas**

- Keep one keyed line per run so `tail -1` parsing stays deterministic
- Query logs with `rg`, the ripgrep binary — its exit codes signal match/no-match cleanly
- Reveal human banners with a `--verbose` flag; keep stdout parseable
- Replace newlines and `=` signs in values before emission
- Reuse the same key names across stages so pipelines compose with direct handoff
- Compute derived metrics with `qalc`, the Qalculate! CLI — raw keys feed it; verified results cite their source keys
