#![allow(non_snake_case)]
//! Table and List formatters — port of _rb/report.rb
//! ring: 0 (PURE)
//! contract: table() renders rows into aligned columns. list() renders items as bullet list.
//! purity: pure (no I/O)

pub fn formatTable(rows: &[Vec<String>], headers: &[&str]) -> String {
    if rows.is_empty() {
        return "(empty)".to_string();
    }
    let mut widths: Vec<usize> = headers.iter().map(|h| h.len()).collect();
    for row in rows {
        for (i, val) in row.iter().enumerate() {
            if i < widths.len() {
                widths[i] = widths[i].max(val.len());
            }
        }
    }
    let head: Vec<String> = headers
        .iter()
        .enumerate()
        .map(|(i, h)| format!("{:<width$}", h, width = widths[i]))
        .collect();
    let sep: Vec<String> = widths.iter().map(|w| "-".repeat(*w)).collect();
    let body: Vec<String> = rows
        .iter()
        .map(|row| {
            row.iter()
                .enumerate()
                .map(|(i, v)| format!("{:<width$}", v, width = widths[i]))
                .collect::<Vec<_>>()
                .join(" | ")
        })
        .collect();
    format!(
        "{}\n{}\n{}",
        head.join(" | "),
        sep.join("-|-"),
        body.join("\n")
    )
}

pub fn formatList(items: &[String]) -> String {
    items
        .iter()
        .map(|i| format!("- {}", i))
        .collect::<Vec<_>>()
        .join("\n")
}
