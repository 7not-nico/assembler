// @pluginclass TRNS
import { isSafe } from "../_lib/safe-commands"

export const BashGuard = async ({ client }: { client: any }) => {
  return {
    "tool.execute.before": async (input: { tool: string; sessionID: string; callID: string }, output: { args: any }) => {
      if (input.tool !== "bash") return
      const cmd: string = output.args?.command ?? ""
      if (isSafe(cmd)) return

      await client.app.log({
        body: {
          level: "warn",
          service: "bash-guard",
          message: `blocked: session=${input.sessionID} cmd=${cmd.slice(0, 200)}`,
        },
      })

      throw new Error(`bash-guard: blocked dangerous command: ${cmd.slice(0, 120)}`)
    },
  }
}
