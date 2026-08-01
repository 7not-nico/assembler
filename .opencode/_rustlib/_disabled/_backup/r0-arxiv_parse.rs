// ring: 0 (PURE)
//! Arxiv Atom entry extraction

use regex::Regex;

fn tagcontent(text: &str, tag: &str) -> String {
    let pattern = Regex::new(&format!("<{tag}(?:\\s[^>]*)?>([\\s\\S]*?)</{tag}>")).ok();
    match pattern {
        Some(r) => r.captures(text).and_then(|c| c.get(1)).map(|m| m.as_str().trim().to_string()).unwrap_or_default(),
        None => String::new(),
    }
}

fn whitespace(text: &str) -> String {
    Regex::new(r"\s+").unwrap().replace_all(text, " ").trim().to_string()
}

pub fn entry(block: &str) -> crate::arxivTypes::ArxivEntry {
    let id = tagcontent(block, "id");
    let heading = whitespace(&tagcontent(block, "title"));
    let overview = whitespace(&tagcontent(block, "summary"));
    let date = {
        let p = tagcontent(block, "published");
        if p.is_empty() { tagcontent(block, "updated") } else { p }
    };

    let authorpattern = Regex::new(r"<author[\s>][\s\S]*?<name>([\s\S]*?)</name>[\s\S]*?</author>").unwrap();
    let authorlist: Vec<String> = authorpattern.captures_iter(block)
        .filter_map(|c| c.get(1))
        .map(|m| m.as_str().trim().to_string())
        .collect();

    let category = {
        let categorypattern = Regex::new(r"<arxiv:primary_category[^>]*term=\"([^\"]*)\"").unwrap();
        categorypattern.captures(block).and_then(|c| c.get(1)).map(|m| m.as_str().to_string()).unwrap_or_default()
    };

    let linkpattern = Regex::new(r#"<link[^>]*href="([^"]*)"[^>]*/?>"#).unwrap();
    let mut absurl = String::new();
    let mut pdfurl: Option<String> = None;
    for group in linkpattern.captures_iter(block) {
        let link = group.get(1).map(|m| m.as_str()).unwrap_or("");
        if link.contains("/abs/") { absurl = link.to_string(); }
        else if link.contains("/pdf/") { pdfurl = Some(link.to_string()); }
    }

    crate::arxivTypes::ArxivEntry {
        id: arxivid(&id),
        title: heading,
        summary: overview,
        published: date,
        authors: authorlist,
        category,
        pdfUrl: pdfurl,
        absUrl: if absurl.is_empty() { id } else { absurl },
    }
}

pub fn arxivid(url: &str) -> String {
    let pattern = Regex::new(r"arxiv\.org/(?:abs|pdf)/([\w.-]+)").unwrap();
    pattern.captures(url)
        .and_then(|c| c.get(1))
        .map(|m| m.as_str().to_string())
        .unwrap_or_else(|| url.to_string())
}

pub fn resultcount(xml: &str) -> u32 {
    let value = tagcontent(xml, "opensearch:totalResults");
    let value = if value.is_empty() { tagcontent(xml, "totalResults") } else { value };
    value.parse::<u32>().unwrap_or(0)
}

pub fn entrylist(xml: &str) -> Vec<crate::arxivTypes::ArxivEntry> {
    let entrypattern = Regex::new(r"<entry[\s>][\s\S]*?</entry>").unwrap();
    entrypattern.captures_iter(xml)
        .filter_map(|c| c.get(0))
        .map(|m| entry(m.as_str()))
        .collect()
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn arxivid_case() {
        let id = arxivid("https://arxiv.org/abs/2507.01103");
        assert_eq!(id, "2507.01103");
    }

    #[test]
    fn resultcount_case() {
        let xml = r#"<feed><opensearch:totalResults>42</opensearch:totalResults></feed>"#;
        assert_eq!(resultcount(xml), 42);
    }
}
