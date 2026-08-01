// ring: 0 (PURE)
//! Entity text for embedding and fts

use std::collections::HashMap;

pub fn embedtextmeta(row: &HashMap<String, String>, entitytype: &str) -> String {
    let mut segment: Vec<String> = Vec::new();
    let heading = row.get("title").cloned().unwrap_or_default();
    if !heading.is_empty() { for _ in 0..4 { segment.push(heading.clone()); } }
    match entitytype {
        "patterns" | "maxims" => {
            if let Some(s) = row.get("summary") { for _ in 0..3 { segment.push(s.clone()); } }
            if let Some(p) = row.get("principle") { for _ in 0..2 { segment.push(p.clone()); } }
        }
        "skills" | "commands" => {
            if let Some(d) = row.get("description") { for _ in 0..2 { segment.push(d.clone()); } }
        }
        "illustrations" => {
            if let Some(s) = row.get("summary") { for _ in 0..3 { segment.push(s.clone()); } }
        }
        _ => {}
    }
    segment.join("\n")
}

pub fn embedtextbody(row: &HashMap<String, String>, entitytype: &str) -> String {
    let mut segment: Vec<String> = Vec::new();
    if let Some(body) = row.get("body") { segment.push(body.clone()); }
    if entitytype == "protocols" { if let Some(p) = row.get("protocol") { segment.push(p.clone()); } }
    segment.join("\n")
}

pub fn embedtext(row: &HashMap<String, String>, entitytype: &str) -> String {
    let meta = embedtextmeta(row, entitytype);
    let body = embedtextbody(row, entitytype);
    if meta.is_empty() && body.is_empty() { String::new() }
    else { format!("{}\n{}", meta, body) }
}

pub fn ftstextmeta(row: &HashMap<String, String>) -> String {
    ["title", "protocol", "description", "summary", "principle"].iter()
        .filter_map(|f| row.get(*f))
        .filter(|s| !s.is_empty())
        .cloned()
        .collect::<Vec<_>>()
        .join("\n")
}

pub fn ftstextbody(row: &HashMap<String, String>) -> String {
    row.get("body").cloned().unwrap_or_default()
}

pub fn ftstext(row: &HashMap<String, String>) -> String {
    let meta = ftstextmeta(row);
    let body = ftstextbody(row);
    if meta.is_empty() && body.is_empty() { String::new() }
    else { format!("{}\n{}", meta, body) }
}

#[cfg(test)]
mod test {
    use super::*;

    fn record(heading: &str, summary: &str) -> HashMap<String, String> {
        let mut m = HashMap::new();
        m.insert("title".to_string(), heading.to_string());
        m.insert("summary".to_string(), summary.to_string());
        m
    }

    #[test]
    fn embedtextmeta_case() {
        let r = record("DRY", "Single source");
        let result = embedtextmeta(&r, "maxims");
        assert!(result.contains("DRY"));
    }
}
