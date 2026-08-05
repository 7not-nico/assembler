// mcp-romsfun — MCP wrapper exposing the codex romsfun flows as
// agent tools. One tool per shared instantiator implementation:
//   inst_acquire → wrapper/acquire-game.sh   (IMAGE=/SIZE=/STATUS=)
//   inst_stop     → wrapper/stop-process.sh   (STOPPED=)
//   inst_fetch    → wrapper/fetch-download.sh (SAVEDPATH=)
//   inst_browse   → wrapper/browse-romsfun.sh (GAME/VARIANTS:)
//   inst_build    → wrapper/build-cmake.sh    (BUILD=pass/BINARY=/SIZE=)
//   inst_launch   → wrapper/launch-emulator.sh (LAUNCH=/RUN=pid=)
//   inst_verify   → wrapper/verify-archive.sh (OK=/IMAGE=/SIZE=)
//   inst_trace    → wrapper/trace-evidence.sh (LINES=/EVIDENCE=)
// Each delegates to the shared wrapper, which resolves _codex from its own
// location and executes the canonical instantiator implementation. Keyed
// result lines pass through; failures surface as ERROR text + non-zero exit.

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js"
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js"
import { z } from "zod"
import { runScript } from "./_lib/inst-query.ts"

const server = new McpServer({ name: "mcp-romsfun", version: "1.0.0" })

function runAndReturn(script: string, args: string[], tool: string): { content: { type: "text"; text: string }[] } {
  const outcome = runScript(script, args)
  const text = outcome.ok ? outcome.stdout : `ERROR ${outcome.stderr || outcome.stdout}`
  return { content: [{ type: "text" as const, text }] }
}

server.registerTool(
  "inst_acquire",
  {
    description: "Acquire a game archive through the shared instantiator: extract (7z/zip/rar/tar) or pass through a bare image, verify with file, slugify, stage into the target dir. Result lines: IMAGE=, SIZE=, STATUS=.",
    inputSchema: {
      archive: z.string().describe("Path to the archive (zip/7z/rar/tar) or bare image file"),
      target_dir: z.string().describe("Directory to stage the extracted image into"),
    },
  },
  async ({ archive, target_dir }) => runAndReturn("acquire-game.sh", [archive, target_dir], "inst_acquire"),
)

server.registerTool(
  "inst_stop",
  {
    description: "Stop a running process chain by binary name (pgrep -x exact match, pkill the matched pids). Result line: STOPPED=1 on success.",
    inputSchema: {
      binary_name: z.string().describe("Exact binary/process name (e.g. snes9x, mgba, PPSSPPSDL)"),
    },
  },
  async ({ binary_name }) => runAndReturn("stop-process.sh", [binary_name], "inst_stop"),
)

server.registerTool(
  "inst_fetch",
  {
    description: "Download a file via the shared browser (CDP 9222): open URL, click the first direct-download anchor (default a[href*='token=']), save with a slugified name. Result line: SAVEDPATH=.",
    inputSchema: {
      url: z.string().describe("URL of the file to download"),
      timeout: z.number().int().positive().optional().describe("Fetch timeout in seconds (shell default applies when absent)"),
      out: z.string().optional().describe("Output directory (shell default applies when absent)"),
      selector: z.string().optional().describe("CSS selector for the download anchor (shell default applies when absent)"),
    },
  },
  async ({ url, timeout, out, selector }) => {
    const args = [url]
    if (timeout !== undefined) args.push("--timeout", String(timeout))
    if (out) args.push("--out", out)
    if (selector) args.push("--selector", selector)
    return runAndReturn("fetch-download.sh", args, "inst_fetch")
  },
)

server.registerTool(
  "inst_browse",
  {
    description: "Browse the romsfun catalog for a game on a console section and list its download variants. Machine lines: SEARCH, GAME <url> | <title>, OPEN, DL, VARIANTS: N <url> | <name>.",
    inputSchema: {
      game: z.string().describe("Game name or slug to search romsfun for"),
      timeout: z.number().int().positive().optional().describe("Browse timeout in seconds (shell default applies when absent)"),
      console: z.string().describe("romsfun console section slug — required, validated by browse-romsfun.sh (e.g. super-nintendo, game-boy-advance, nintendo-ds, playstation-portable)"),
    },
  },
  async ({ game, timeout, console }) => {
    const args = [game, console]
    if (timeout !== undefined) args.push("--timeout", String(timeout))
    return runAndReturn("browse-romsfun.sh", args, "inst_browse")
  },
)

server.registerTool(
  "inst_build",
  {
    description: "Build a cmake tree and verify the produced binary. Result lines: BUILD=pass, BINARY=, SIZE=.",
    inputSchema: {
      build_dir: z.string().describe("Build directory containing a configured cmake tree (CMakeCache.txt)"),
      timeout: z.number().int().positive().optional().describe("Build timeout in seconds"),
      binary: z.string().optional().describe("Relative path of the expected binary inside the build dir"),
      log: z.string().optional().describe("Bitacora log name (routes through wrapper/run-bitacora.sh)"),
    },
  },
  async ({ build_dir, timeout, binary, log }) => {
    const args = [build_dir]
    if (timeout) args.push("--timeout", String(timeout))
    if (binary) args.push("--binary", binary)
    if (log) args.push("--log", log)
    return runAndReturn("build-cmake.sh", args, "inst_build")
  },
)

server.registerTool(
  "inst_launch",
  {
    description: "Detach-launch an emulator binary on a ROM (setsid + nohup) and health-check the process. Result lines: LAUNCH=, RUN=pid= log=<path>.",
    inputSchema: {
      binary: z.string().describe("Absolute path to the emulator binary"),
      rom: z.string().describe("Path to the ROM file"),
      log: z.string().optional().describe("Launch log path (default /tmp/opencode/emulator-launch.log)"),
      env: z.array(z.string()).optional().describe("Extra environment assignments, KEY=VALUE (e.g. ['DISPLAY=:0'])"),
    },
  },
  async ({ binary, rom, log, env }) => {
    const args = [binary, rom]
    if (log) args.push("--log", log)
    if (env) for (const kv of env) args.push("--env", kv)
    return runAndReturn("launch-emulator.sh", args, "inst_launch")
  },
)

server.registerTool(
  "inst_verify",
  {
    description: "Verify a downloaded game archive: file type detection, listing via the matching extractor, exactly-one image expected, size sanity, optional title probe. Result lines: OK=, IMAGE=, SIZE=, TITLE=.",
    inputSchema: {
      file: z.string().describe("Path to the archive (zip/7z/tar/rar) or bare image"),
      image_ext: z.string().optional().describe("Comma-separated expected image extensions (default sfc,smc,iso,cso)"),
    },
  },
  async ({ file, image_ext }) => {
    const args = [file]
    if (image_ext) args.push("--image-ext", image_ext)
    return runAndReturn("verify-archive.sh", args, "inst_verify")
  },
)

server.registerTool(
  "inst_trace",
  {
    description: "Extract evidence lines from an emulator trace log by pattern. Default patterns cover boot, disc load, SDK replacements, stdout, media codecs. Result lines: TRACE=, LINES=, EVIDENCE=.",
    inputSchema: {
      trace_file: z.string().describe("Path to the trace/launch log"),
      patterns_file: z.string().optional().describe("File with one regex per line (defaults apply when absent)"),
      head: z.number().int().positive().optional().describe("Max evidence lines to print (shell default applies when absent)"),
    },
  },
  async ({ trace_file, patterns_file, head }) => {
    const args = [trace_file]
    if (patterns_file) args.push("--patterns", patterns_file)
    if (head !== undefined) args.push("--head", String(head))
    return runAndReturn("trace-evidence.sh", args, "inst_trace")
  },
)

async function main(): Promise<void> {
  const transport = new StdioServerTransport()
  await server.connect(transport)
}

main().catch((err) => {
  console.error("mcp-romsfun fatal:", err)
  process.exit(1)
})
