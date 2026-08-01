// ring: 0 (PURE)
//! Audit entry and duplicate check

#[derive(Debug, Clone)]
pub struct AuditEntry {
    pub file: String,
    pub message: String,
}

pub fn entryduplicate(prior: &mut std::collections::HashSet<String>, id: &str, file: &str) -> Option<AuditEntry> {
    if prior.contains(id) {
        Some(AuditEntry { file: file.to_string(), message: format!("Duplicate ID: {}", id) })
    } else {
        prior.insert(id.to_string());
        None
    }
}

pub fn auditreport(filecount: usize, entry: &[AuditEntry], entitylabel: &str) -> String {
    if entry.is_empty() {
        return format!("Audit {} {}. All OK.", filecount, entitylabel);
    }
    let defectlist: Vec<String> = entry.iter()
        .map(|v| format!("  {}: {}", v.file, v.message))
        .collect();
    format!("Audit {} {}. {} defect{}:\n{}",
        filecount, entitylabel, entry.len(),
        if entry.len() == 1 { "" } else { "s" },
        defectlist.join("\n"))
}

#[cfg(test)]
mod test {
    use super::*;
    use std::collections::HashSet;

    #[test]
    fn entryduplicate_detected_case() {
        let mut prior = HashSet::new();
        prior.insert("MAX.DRY".to_string());
        let outcome = entryduplicate(&mut prior, "MAX.DRY", "test.md");
        assert!(outcome.is_some());
        assert!(outcome.unwrap().message.contains("Duplicate"));
    }

    #[test]
    fn entryduplicate_new_case() {
        let mut prior = HashSet::new();
        let outcome = entryduplicate(&mut prior, "MAX.DRY", "test.md");
        assert!(outcome.is_none());
        assert!(prior.contains("MAX.DRY"));
    }

    #[test]
    fn auditreport_clean_case() {
        assert!(auditreport(5, &[], "maxim").contains("All OK"));
    }

    #[test]
    fn auditreport_issue_case() {
        let entry = vec![AuditEntry { file: "a.md".to_string(), message: "error".to_string() }];
        let report = auditreport(5, &entry, "maxim");
        assert!(report.contains("1 defect"));
        assert!(report.contains("a.md"));
    }
}
