// ring: 0 (PURE)
//! Dangerous shell pattern

use regex::Regex;

pub struct DangerousPattern {
    pub regex: &'static str,
    pub label: &'static str,
}

pub const DangerRegistry: &[DangerousPattern] = &[
    DangerousPattern { regex: r"^rm\s+(-rf?|-[a-z]*r[a-z]*f[a-z]*)\s+\/", label: "recursive-rm-root" },
    DangerousPattern { regex: r"\bdd\s+if=", label: "disk-overwrite" },
    DangerousPattern { regex: r"\bmkfs\b", label: "filesystem-create" },
    DangerousPattern { regex: r"^chmod\b.*\b(777|000)\b.*\s+\/", label: "permission-destruction" },
    DangerousPattern { regex: r"^chown\b.*\s+\/\s*$", label: "ownership-destruction" },
    DangerousPattern { regex: r"(curl|wget)\s+.*\|\s*(sh|bash|zsh)", label: "pipe-to-shell" },
    DangerousPattern { regex: r":\s*\(\s*\)\s*\{", label: "fork-bomb" },
    DangerousPattern { regex: r"^mv\s+\/\s+\/dev\/null", label: "null-move" },
];

pub fn gate(command: &str) -> bool {
    let input = command.trim();
    for entry in DangerRegistry {
        if let Ok(pattern) = Regex::new(entry.regex) {
            if pattern.is_match(input) { return false; }
        }
    }
    true
}

#[cfg(test)]
mod test {
    use super::*;
    #[test]
    fn safecommand() {
        assert!(gate("ls -la"));
        assert!(!gate("rm -rf /"));
    }
}
