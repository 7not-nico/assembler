// @toolclass TRNS
import { tool } from "@opencode-ai/plugin"
import { initDB } from "../_lib/db"
import { crashOnError } from "../_lib/errors"
import { syncAll } from "../_lib/sync"

export default tool({
  description: "Sync pattern, term, skill, rule, command, protocol, abstraction, linguistics, person, precept files into patlib.db",
  args: {
    type: tool.schema.string().optional().describe("Entity type: patterns, terms, skills, rules, commands, protocols, abstractions, nexus, linguistics, persons, illustrations, maxims, precepts, or all (default)"),
  },
  async execute(args) {
    crashOnError()
    const db = initDB()
    const result = syncAll(db, args.type)
    db.close()
    return result
  },
})
