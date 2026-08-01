// exports: DANGEROUS_PATTERNS, isSafe
// purity: pure
// depends-on: none

export interface DangerousPattern {
  regex: RegExp;
  label: string;
}

export const DANGEROUS_PATTERNS: DangerousPattern[] = [
  { regex: /^rm\s+(-rf?|-[a-z]*r[a-z]*f[a-z]*)\s+\//,    label: "recursive-rm-root" },
  { regex: /\bdd\s+if=/,                                   label: "disk-overwrite" },
  { regex: /\bmkfs\b/,                                     label: "filesystem-create" },
  { regex: /^chmod\b.*\b(777|000)\b.*\s+\//,                label: "permission-destruction" },
  { regex: /^chown\b.*\s+\/\s*$/,                          label: "ownership-destruction" },
  { regex: /(curl|wget)\s+.*\|\s*(sh|bash|zsh)/,           label: "pipe-to-shell" },
  { regex: /:\s*\(\s*\)\s*\{/,                              label: "fork-bomb" },
  { regex: /^mv\s+\/\s+\/dev\/null/,                       label: "null-move" },
]

export function isSafe(command: string): boolean {
  for (const p of DANGEROUS_PATTERNS) {
    if (p.regex.test(command.trim())) return false
  }
  return true
}
