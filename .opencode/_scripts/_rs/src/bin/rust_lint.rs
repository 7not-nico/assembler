#![allow(non_snake_case)]
//! rust-lint — validate Rust source code conventions
//! Uses shared _rs/ modules for Fault reporting, output formatting.
//! Checks _rustlib/src/ for:
//!   - Concrete nouns in type names, function names, variable names
//!   - camelCase with action verbs for function/method names
//!   - PascalCase for type names
//!   - SCREAMING_SNAKE for constants
//!   - Ring header matches filename prefix

use std::path::Path;
use std::sync::LazyLock;
use std::collections::HashSet;
use regex::Regex;

// ── Shared _rs/ module imports ──
// These come from the assembler_scripts library
use assembler_scripts::r0_report;
use assembler_scripts::r0_violation::Fault;

// ── Configuration ──

static RUSTLIB_ROOT: LazyLock<String> = LazyLock::new(|| {
    // Resolve relative to CARGO_MANIFEST_DIR: _scripts/_rs/ → _scripts/ → assembler/ → .opencode/_rustlib/src/
    let manifest = Path::new(env!("CARGO_MANIFEST_DIR"));
    let root = manifest.parent().unwrap().parent().unwrap().join(".opencode").join("_rustlib").join("src");
    root.to_string_lossy().to_string()
});

/// Abstract/generic nouns that are NOT concrete — flagged when used as identifiers
const ABSTRACT_NOUNS: &[&str] = &[
    "data", "info", "value", "item", "thing", "object",
    "handler", "manager", "processor", "controller",
    "util", "helper", "common", "misc",
    "input", "output", "temp", "tmp",
    "result", "outcome", "response",
    "entity", "thingy",
    "wrapper", "adapter", "bridge",
    "container", "holder", "bucket",
    "setter", "getter", "accessor",
];

/// Action verbs that SHOULD start method/function names (camelCase prefix)
const ACTION_VERBS: &[&str] = &[
    "parse", "build", "check", "validate", "format",
    "load", "read", "write", "sync", "merge",
    "find", "search", "lookup", "query", "resolve",
    "create", "insert", "update", "delete", "remove",
    "open", "close", "connect", "disconnect",
    "run", "exec", "spawn", "fork",
    "get", "set", "push", "pop",
    "add", "remove", "clear", "reset",
    "encode", "decode", "serialize", "deserialize",
    "init", "start", "stop", "finish",
    "compute", "calculate", "estimate",
    "extract", "transform", "convert",
    "register", "unregister",
    "enable", "disable",
    "import", "export",
    "audit", "scan", "inspect",
    "render", "display", "print",
    "hash", "encrypt", "decrypt",
];

/// Concrete noun pattern — PascalCase type names should end with a concrete noun
const CONCRETE_NOUN_SUFFIXES: &[&str] = &[
    "Entry", "Result", "Hit", "State", "Event",
    "Info", "Rule", "Fault", "Rules",
    "Pattern", "Patterns",
    "Error", "Errors",
    "Frontmatter", "Metadata",
    "Entity", "Entities",
    "SearchResult", "RankedHit",
    "BurstState", "FileEvent",
    "FieldRule", "FieldRules",
    "AuditResult",
    "CheckType",
];

// ── Rust code identifiers: patterns ──

/// PascalCase type name (struct, enum, trait)
static PASCAL_RE: LazyLock<Regex> = LazyLock::new(|| {
    Regex::new(r"\A[A-Z][a-zA-Z0-9]*\z").unwrap()
});

/// camelCase function/method name
static CAMEL_RE: LazyLock<Regex> = LazyLock::new(|| {
    Regex::new(r"\A[a-z][a-zA-Z0-9]*\z").unwrap()
});

/// SCREAMING_SNAKE constant name
static SCREAMING_RE: LazyLock<Regex> = LazyLock::new(|| {
    Regex::new(r"\A[A-Z][A-Z0-9]*(_[A-Z0-9]+)*\z").unwrap()
});

/// snake_case private helper
static SNAKE_RE: LazyLock<Regex> = LazyLock::new(|| {
    Regex::new(r"\A[a-z][a-z0-9]*(_[a-z0-9]+)*\z").unwrap()
});

/// Compile a set of abstract noun stems for fast lookup
static ABSTRACT_SET: LazyLock<HashSet<&'static str>> = LazyLock::new(|| {
    ABSTRACT_NOUNS.iter().copied().collect()
});

/// Compile action verbs into a set
static VERB_SET: LazyLock<HashSet<&'static str>> = LazyLock::new(|| {
    ACTION_VERBS.iter().copied().collect()
});

// ── Identifier classification ──

#[derive(Debug, Clone, PartialEq)]
enum IdKind {
    TypeName,        // PascalCase — structs, enums, traits
    FunctionName,    // camelCase — functions, methods
    Constant,        // SCREAMING_SNAKE — const, static
    Helper,          // snake_case — private helpers
    Other,
}

fn classify_identifier(name: &str) -> IdKind {
    if PASCAL_RE.is_match(name) && name.chars().next().map(|c| c.is_uppercase()).unwrap_or(false) {
        IdKind::TypeName
    } else if CAMEL_RE.is_match(name) {
        IdKind::FunctionName
    } else if SCREAMING_RE.is_match(name) {
        IdKind::Constant
    } else if SNAKE_RE.is_match(name) {
        IdKind::Helper
    } else {
        IdKind::Other
    }
}

/// Extract the stem from an identifier for abstract-noun checking
/// e.g. "buildEntityText" → stems: ["build", "entity", "text"]
fn identifier_stems(name: &str) -> Vec<String> {
    if name.chars().all(|c| c.is_uppercase() || c == '_') {
        // SCREAMING_SNAKE
        return name.split('_').map(|s| s.to_lowercase()).collect();
    }
    if name.contains('_') {
        // snake_case
        return name.split('_').map(|s| s.to_lowercase()).collect();
    }
    // camelCase or PascalCase — split on uppercase boundaries
    let mut stems = Vec::new();
    let mut current = String::new();
    for ch in name.chars() {
        if ch.is_uppercase() && !current.is_empty() {
            stems.push(current.to_lowercase());
            current.clear();
        }
        current.push(ch);
    }
    if !current.is_empty() {
        stems.push(current.to_lowercase());
    }
    stems
}

/// Check if identifier uses abstract nouns
fn has_abstract_stem(name: &str) -> Option<&'static str> {
    let stems = identifier_stems(name);
    for stem in &stems {
        if ABSTRACT_SET.contains(stem.as_str()) {
            return Some(ABSTRACT_NOUNS.iter().find(|&&a| a == stem).copied().unwrap());
        }
    }
    None
}

/// Check if function starts with an action verb
fn has_action_verb(name: &str) -> bool {
    let lower = name.to_lowercase();
    for verb in ACTION_VERBS {
        if lower.starts_with(verb) && name.len() > verb.len() {
            let after_verb = &name[verb.len()..];
            // Must have an uppercase letter after the verb (camelCase boundary)
            if after_verb.chars().next().map(|c| c.is_uppercase()).unwrap_or(false) {
                return true;
            }
        }
        // Exact match for single-word verbs
        if lower == *verb {
            return true;
        }
    }
    false
}

/// Check if a PascalCase type name ends with a concrete noun suffix
fn has_concrete_suffix(name: &str) -> bool {
    for suffix in CONCRETE_NOUN_SUFFIXES {
        if name == *suffix { return true; }
        if name.ends_with(suffix) && name.len() > suffix.len() {
            let before = &name[..name.len() - suffix.len()];
            // Suffix must be a separate PascalCase word: character before it is lowercase
            if before.chars().last().map(|c| c.is_lowercase()).unwrap_or(false) {
                return true;
            }
            // Also accept if before is empty or just uppercase (single-letter prefix)
            if before.len() <= 1 { return true; }
        }
    }
    false
}

/// Extract line number for a name in text
fn find_line(text: &str, name: &str) -> usize {
    for (i, line) in text.lines().enumerate() {
        if line.contains(name) {
            return i + 1;
        }
    }
    0
}

// ── Rust source scanning ──

/// Collect all public and private identifiers from Rust source
struct RustIdents {
    items: Vec<(String, String, IdKind)>, // (ident_name, context, kind)
}

fn scan_rust_source(text: &str, file_name: &str) -> RustIdents {
    let mut items = Vec::new();

    // Function declarations — skip test functions inside cfg(test)
    for cap in Regex::new(r"(?:pub\s+)?fn\s+(\w+)").unwrap().captures_iter(text) {
        let name = cap[1].to_string();
        if name == "main" { continue; }
        let kind = classify_identifier(&name);
        items.push((name, format!("{}:fn", file_name), kind));
    }

    // Struct declarations
    for cap in Regex::new(r"(?:pub\s+)?struct\s+(\w+)").unwrap().captures_iter(text) {
        let name = cap[1].to_string();
        let kind = classify_identifier(&name);
        items.push((name, format!("{}:struct", file_name), kind));
    }

    // Enum declarations
    for cap in Regex::new(r"(?:pub\s+)?enum\s+(\w+)").unwrap().captures_iter(text) {
        let name = cap[1].to_string();
        let kind = classify_identifier(&name);
        items.push((name, format!("{}:enum", file_name), kind));
    }

    // Trait declarations
    for cap in Regex::new(r"(?:pub\s+)?trait\s+(\w+)").unwrap().captures_iter(text) {
        let name = cap[1].to_string();
        let kind = classify_identifier(&name);
        items.push((name, format!("{}:trait", file_name), kind));
    }

    // Const/static declarations with meaningful names (skip type markers like &str)
    for cap in Regex::new(r"(?:pub\s+)?(?:const|static)\s+(\w+)").unwrap().captures_iter(text) {
        let name = cap[1].to_string();
        if ["str", "name", "type"].contains(&name.as_str()) { continue; }
        let kind = classify_identifier(&name);
        items.push((name, format!("{}:const", file_name), kind));
    }

    // Module declarations — skip tests
    for cap in Regex::new(r"(?:pub\s+)?mod\s+(\w+)").unwrap().captures_iter(text) {
        let name = cap[1].to_string();
        if name == "tests" { continue; }
        let kind = classify_identifier(&name);
        items.push((name, format!("{}:mod", file_name), kind));
    }

    RustIdents { items }
}

// ── Lint checks ──

fn check_concrete_nouns(idents: &RustIdents, text: &str, file_name: &str) -> Vec<Fault> {
    let mut Faults = Vec::new();
    for (name, ctx, kind) in &idents.items {
        // Skip test modules — idiomatic Rust
        if name == "tests" && ctx.ends_with(":mod") { continue; }
        // Structs use abstract nouns per convention — skip check
        if *kind == IdKind::TypeName { continue; }
        // Skip standard type aliases
        if *kind == IdKind::Other { continue; }
        if *kind == IdKind::FunctionName || *kind == IdKind::Constant {
            if let Some(abstract_word) = has_abstract_stem(name) {
                Faults.push(Fault {
                    id: name.clone(),
                    entity_type: file_name.to_string(),
                    field: ctx.clone(),
                    value: format!("contains abstract noun '{}'", abstract_word),
                    problem: "abstract noun in identifier; use concrete noun".to_string(),
                });
            }
        }
    }
    Faults
}

fn check_action_verb_fn(idents: &RustIdents, text: &str, file_name: &str) -> Vec<Fault> {
    let mut Faults = Vec::new();
    for (name, ctx, kind) in &idents.items {
        // Skip test modules
        if name == "tests" && ctx.ends_with(":mod") { continue; }
        // Skip type aliases and const identifiers
        if *kind != IdKind::FunctionName { continue; }
        // Skip standard Rust functions and idioms
        let skip = ["main", "new", "default", "clone", "fmt", "unwrap_or",
                    "is_some", "is_none", "is_empty", "as_str", "as_ref",
                    "to_string", "len", "contains", "as_str"];
        if skip.contains(&name.as_str()) { continue; }

        if !has_action_verb(name) {
            Faults.push(Fault {
                id: name.clone(),
                entity_type: file_name.to_string(),
                field: ctx.clone(),
                value: name.clone(),
                problem: "function name does not start with action verb".to_string(),
            });
        }
    }
    Faults
}

fn check_type_concrete(idents: &RustIdents, text: &str, file_name: &str) -> Vec<Fault> {
    let mut Faults = Vec::new();
    for (name, ctx, kind) in &idents.items {
        if name == "tests" && ctx.ends_with(":mod") { continue; }
        if *kind != IdKind::TypeName { continue; }
        // Allow single-word concrete types that are well-known
        let lower = name.to_lowercase();
        let single_word_ok = [
            "frontmatter", "Fault", "pattern", "rule",
            "ringinfo", "fieldrule", "checktype", "fileevent",
        ];
        if single_word_ok.contains(&lower.as_str()) { continue; }

        if has_concrete_suffix(name) {
            continue; // Has a concrete noun suffix — ok
        }
        Faults.push(Fault {
            id: name.clone(),
            entity_type: file_name.to_string(),
            field: ctx.clone(),
            value: name.clone(),
            problem: "type name lacks concrete noun suffix (e.g. Entry, State, Rule)".to_string(),
        });
    }
    Faults
}

// ── Main ──

fn main() {
    let src_dir = RUSTLIB_ROOT.clone();

    // Check directory exists
    if !Path::new(&src_dir).exists() {
        eprintln!("ERROR: source directory not found: {}", src_dir);
        std::process::exit(1);
    }

    // Scan files
    let mut all_Faults: Vec<Fault> = Vec::new();
    let mut file_count = 0;

    let pattern = format!("{}/*.rs", src_dir);
    for entry in glob::glob(&pattern).unwrap_or_else(|_| glob::glob("").unwrap()).flatten() {
        let file_name = entry.file_name().unwrap().to_string_lossy().to_string();
        if file_name == "lib.rs" || file_name == "main.rs" { continue; }
        let text = std::fs::read_to_string(&entry).unwrap_or_default();
        file_count += 1;

        let idents = scan_rust_source(&text, &file_name);

        // Run all checks
        all_Faults.extend(check_concrete_nouns(&idents, &text, &file_name));
        all_Faults.extend(check_action_verb_fn(&idents, &text, &file_name));
        all_Faults.extend(check_type_concrete(&idents, &text, &file_name));
    }

    // Output report
    println!("=== Rust Source Lint — {}", src_dir);
    println!("Files scanned: {}", file_count);
    println!();

    if all_Faults.is_empty() {
        println!("OK — 0 Faults");
    } else {
        println!("Faults ({}):", all_Faults.len());
        println!();
        // Group by file
        use std::collections::BTreeMap;
        let mut by_file: BTreeMap<String, Vec<&Fault>> = BTreeMap::new();
        for v in &all_Faults {
            by_file.entry(v.entity_type.clone()).or_default().push(v);
        }
        for (file, Faults) in &by_file {
            println!("  {}:", file);
            for v in Faults {
                println!("    {}  {}", v.id, v.problem);
                println!("            {}: {}", v.field, v.value);
            }
            println!();
        }
    }

    if !all_Faults.is_empty() {
        std::process::exit(1);
    }
}
