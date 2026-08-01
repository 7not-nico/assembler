// ring: 0 (PURE)
//! Table and list formatters

pub fn table(rows: &[Vec<String>], headers: &[&str]) -> String {
    if rows.is_empty() { return "(empty)".to_string(); }
    let col_count = headers.len().max(rows.iter().map(|r| r.len()).max().unwrap_or(0));
    let mut widths: Vec<usize> = headers.iter().map(|h| h.len()).collect();
    for row in rows {
        for (i, val) in row.iter().enumerate() {
            if i < col_count {
                if i < widths.len() { widths[i] = widths[i].max(val.len()); }
                else { widths.push(val.len()); }
            }
        }
    }
    let head: Vec<String> = headers.iter().enumerate()
        .map(|(i, h)| format!("{:<width$}", h, width = widths[i])).collect();
    let sep: Vec<String> = widths.iter().map(|w| "-".repeat(*w)).collect();
    let body: Vec<String> = rows.iter().map(|row| {
        row.iter().enumerate()
            .map(|(i, v)| format!("{:<width$}", v, width = widths[i]))
            .collect::<Vec<_>>().join(" | ")
    }).collect();
    format!("{}\n{}\n{}", head.join(" | "), sep.join("-|-"), body.join("\n"))
}

pub fn list(items: &[String]) -> String {
    items.iter().map(|i| format!("- {}", i)).collect::<Vec<_>>().join("\n")
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn test_table() {
        let r = table(&[vec!["a".to_string()]], &["A"]);
        assert!(r.contains("a"));
    }
}
