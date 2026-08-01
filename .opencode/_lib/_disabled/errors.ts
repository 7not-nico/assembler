// exports: crashHandler
// purity: io
// depends-on: none

export function crashOnError(): void {
  process.on("unhandledRejection", (err) => {
    console.error("Unhandled rejection:", err)
    process.exit(1)
  })
  process.on("uncaughtException", (err) => {
    console.error("Uncaught exception:", err)
    process.exit(1)
  })
}

export const crashHandler = crashOnError
