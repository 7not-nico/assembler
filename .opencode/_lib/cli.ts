// exports: cli
// purity: io
// depends-on: process

// Minimal argv parser: --key value pairs, --flag booleans.
// value("--type") -> string | undefined; flag("--force") -> boolean

export function cli(argv: string[]) {
  const value = (key: string): string | undefined => {
    const index = argv.indexOf(key)
    return index >= 0 && index + 1 < argv.length ? argv[index + 1] : undefined
  }
  const flag = (key: string): boolean => argv.includes(key)
  return { value, flag }
}
