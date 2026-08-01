// ring: 0 (PURE)
//! Arxiv entry formatter

    use crate::arxiv_types::ArxivEntry;

fn snippet(text: &str, max: usize) -> String {
    if text.len() <= max { text.to_string() }
    else { format!("{}…", &text[..max.saturating_sub(1)]) }
}

pub fn entrylist(entry: &[ArxivEntry], limit: usize, totalcount: Option<u32>) -> String {
    if entry.is_empty() { return "No result found.".to_string(); }

    let total = totalcount.unwrap_or(entry.len() as u32);
    let displaycount = entry.len().min(limit);
    let mut line: Vec<String> = vec![
        format!("Found {} paper(s) (showing top {})", total, displaycount),
        String::new(),
    ];

    for (i, e) in entry.iter().take(limit).enumerate() {
        let pubdate = if e.published.len() >= 10 { &e.published[..10] } else { "unknown" };
        let author = if e.authors.len() > 3 {
            format!("{} et al.", e.authors[..3].join(", "))
        } else {
            e.authors.join(", ")
        };

        line.push(format!("{}. {}", i + 1, e.title));
        line.push(format!("   ID: {}  |  {}  |  {}", e.id, pubdate, e.category));
        line.push(format!("   Author(s): {}", author));
        if !e.summary.is_empty() {
            line.push(format!("   {}", snippet(&e.summary, 200)));
        }
        line.push(format!("   {}", e.absurl));
        if let Some(ref pdf) = e.pdfurl {
            line.push(format!("   PDF: {}", pdf));
        }
        line.push(String::new());
    }

    line.join("\n")
}

#[cfg(test)]
mod test {
    use super::*;
use crate::arxiv_types::ArxivEntry;

    fn sampleentry() -> ArxivEntry {
        ArxivEntry {
            id: "2507.01103".to_string(),
            title: "Test Paper".to_string(),
            summary: "A summary.".to_string(),
            published: "2025-07-01".to_string(),
            authors: vec!["Alice".to_string(), "Bob".to_string()],
            category: "cs.IR".to_string(),
            pdfurl: None,
            absurl: "https://arxiv.org/abs/2507.01103".to_string(),
        }
    }

    #[test]
    fn entrylist_empty_case() {
        assert_eq!(entrylist(&[], 10, None), "No result found.");
    }

    #[test]
    fn entrylist_case() {
        let result = entrylist(&[sampleentry()], 10, None);
        assert!(result.contains("Test Paper"));
        assert!(result.contains("2507.01103"));
    }

    #[test]
    fn snippet_case() {
        let long = "a".repeat(100);
        let short = snippet(&long, 10);
        assert!(short.len() <= 10);
        assert!(short.ends_with('…'));
    }
}
