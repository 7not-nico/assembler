//! Entity directory discovery — port of _rb/paths.rb
//! ring: io (filesystem reads)
//! purity: io (filesystem access via WalkDir, read_dir)

use std::path::{Path, PathBuf};
use std::sync::LazyLock;
use walkdir::WalkDir;

pub static _Root: LazyLock<PathBuf> = LazyLock::new(|| {
    // Walk upward from the crate dir until an ancestor contains .opencode/entities.
    // Handles both layouts: assembler/_scripts/_rs and assembler/.opencode/_scripts/_rs.
    let manifest = Path::new(env!("CARGO_MANIFEST_DIR"));
    let mut candidate = manifest.to_path_buf();
    loop {
        if candidate.join(".opencode").join("entities").is_dir() {
            return candidate;
        }
        if !candidate.pop() {
            break;
        }
    }
    panic!("assembler root not found — no .opencode/entities ancestor of {}", manifest.display());
});

pub static _Entities: LazyLock<PathBuf> = LazyLock::new(|| _Root.join(".opencode").join("entities"));

pub fn entityGlob(entity_type: &str) -> String {
    _Entities.join(entity_type).join("**").join("*.md").to_string_lossy().to_string()
}

pub fn entityFiles(entity_type: &str) -> Vec<PathBuf> {
    let base = _Entities.join(entity_type);
    if !base.exists() { return vec![]; }
    WalkDir::new(&base)
        .max_depth(2).into_iter()
        .filter_map(|directoryResult| directoryResult.ok())
        .filter(|de| de.file_type().is_file() && de.path().extension().is_some_and(|ext| ext == "md"))
        .map(|de| de.path().to_path_buf())
        .collect()
}

pub fn entityTypes() -> Vec<String> {
    let mut types: Vec<String> = Vec::new();
    if let Ok(entries) = std::fs::read_dir(_Entities.as_path()) {
        for entry in entries.flatten() {
            let path = entry.path();
            if path.is_dir() {
                let has_md = std::fs::read_dir(&path)
                    .map(|readDir| readDir.flatten().any(|dirEntry| dirEntry.path().extension().is_some_and(|extension| extension == "md")))
                    .unwrap_or(false);
                if has_md {
                    if let Some(dir_name) = path.file_name().and_then(|n| n.to_str()) {
                        types.push(dir_name.to_string());
                    }
                }
            }
        }
    }
    types.sort();
    types
}
