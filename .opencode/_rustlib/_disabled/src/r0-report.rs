// ring: 0 (PURE)
//! Table formatter

pub fn table(row: &[Vec<String>], header: &[&str]) -> String {
    if row.is_empty() { return "(empty)".to_string(); }
    let colcount = header.len().max(row.iter().map(|r| r.len()).max().unwrap_or(0));
    let mut width: Vec<usize> = header.iter().map(|h| h.len()).collect();
    for r in row {
        for (i, val) in r.iter().enumerate() {
            if i < colcount {
                if i < width.len() { width[i] = width[i].max(val.len()); }
                else { width.push(val.len()); }
            }
        }
    }
    let head: Vec<String> = header.iter().enumerate()
        .map(|(i, h)| format!("{:<width$}", h, width = width[i])).collect();
    let dash: Vec<String> = width.iter().map(|w| "-".repeat(*w)).collect();
    let body: Vec<String> = row.iter().map(|r| {
        r.iter().enumerate()
            .map(|(i, v)| format!("{:<width$}", v, width = width[i]))
            .collect::<Vec<_>>().join(" | ")
    }).collect();
    format!("{}\n{}\n{}", head.join(" | "), dash.join("-|-"), body.join("\n"))
}

pub fn list(item: &[String]) -> String {
    item.iter().map(|i| format!("- {}", i)).collect::<Vec<_>>().join("\n")
}

#[cfg(test)]
mod test {
    use super::*;
    #[test]
    fn table_case() {
        let r = table(&[vec!["a".to_string()]], &["A"]);
        assert!(r.contains("a"));
    }
}
