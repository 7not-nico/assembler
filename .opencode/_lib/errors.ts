// exports: crash
// purity: io
// depends-on: none

export function crash(): void {
  process.on("unhandledRejection", (err) => {
    console.error(err)
    process.exit(1)
  })
  process.on("uncaughtException", (err) => {
    console.error(err)
    process.exit(1)
  })
}
