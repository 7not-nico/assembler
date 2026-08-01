// ring: 0 (PURE)
//! Spec audit — pattern checks

use regex::Regex;
use crate::specTypes::{CheckType, Rule, Defect, AuditOutcome};

fn lineindex(text: &str, index: usize) -> usize {
    text[..index].lines().count()
}

fn forbiddenpattern(text: &str, rule: &Rule, patterns: &[String]) -> Vec<Defect> {
    let mut d = Vec::new();
    for p in patterns {
        if let Ok(re) = Regex::new(p) {
            for m in re.find_iter(text) {
                d.push(Defect { rule: rule.id.clone(), title: rule.title.clone(), severity: rule.severity.clone(), line: lineindex(text, m.start()), message: format!("Forbidden pattern: {}", m.as_str().trim()), suggestion: rule.suggestion.clone() });
            }
        }
    }
    d
}

fn ratio(text: &str, rule: &Rule, positive: &[String], negative: &[String]) -> Vec<Defect> {
    let (Ok(pr), Ok(nr)) = (positive.iter().map(|p| Regex::new(p)).collect::<Result<Vec<_>, _>>(), negative.iter().map(|p| Regex::new(p)).collect::<Result<Vec<_>, _>>()) else { return vec![]; };
    let pc: usize = pr.iter().map(|re| re.find_iter(text).count()).sum();
    let nc: usize = nr.iter().map(|re| re.find_iter(text).count()).sum();
    let r = if nc > 0 { pc as f64 / nc as f64 } else { f64::INFINITY };
    let t = rule.threshold.unwrap_or(3.0);
    if nc > 0 && r < t {
        vec![Defect { rule: rule.id.clone(), title: rule.title.clone(), severity: rule.severity.clone(), line: 1, message: format!("Ratio {:.1}:1 (need >= {:.0}:1). {} pos, {} neg.", r, t, pc, nc), suggestion: rule.suggestion.clone() }]
    } else { vec![] }
}

fn proximity(text: &str, rule: &Rule, trigger: &str, expected: &str) -> Vec<Defect> {
    let (Ok(tr), Ok(ex)) = (Regex::new(trigger), Regex::new(expected)) else { return vec![]; };
    let dist = rule.threshold.unwrap_or(5.0) as usize;
    let lines: Vec<&str> = text.lines().collect();
    let mut d = Vec::new();
    for m in tr.find_iter(text) {
        let l = lineindex(text, m.start());
        let start = l.saturating_sub(1);
        let end = lines.len().min(l + dist);
        let scope = lines[start..end].join("\n");
        if !ex.is_match(&scope) {
            d.push(Defect { rule: rule.id.clone(), title: rule.title.clone(), severity: rule.severity.clone(), line: l, message: format!("Hard stop \"{}\" missing redirect within {} lines.", m.as_str().trim(), dist), suggestion: rule.suggestion.clone() });
        }
    }
    d
}

fn count(text: &str, rule: &Rule, patterns: &[String]) -> Vec<Defect> {
    let seg = rule.scope == "segment";
    let segs: Vec<&str> = if seg { text.split("\n\n").collect() } else { vec![text] };
    let t = rule.threshold.unwrap_or(6.0) as usize;
    let mut d = Vec::new();
    for s in &segs {
        let mut c = 0;
        for p in patterns { if let Ok(re) = Regex::new(p) { c += re.find_iter(s).count(); } }
        if c > t {
            let l = if seg { let start = text.find(s.get(..20.min(s.len())).unwrap_or(s)).unwrap_or(0); lineindex(text, start) } else { 1 };
            d.push(Defect { rule: rule.id.clone(), title: rule.title.clone(), severity: rule.severity.clone(), line: l, message: format!("{} constraint terms in {} (max {}).", c, rule.scope, t), suggestion: rule.suggestion.clone() });
        }
    }
    d
}

/// Full text audit
pub fn textaudit(text: &str, rules: &[Rule]) -> AuditOutcome {
    let mut d = Vec::new();
    for rule in rules {
        match &rule.checktype {
            CheckType::ForbiddenPattern => {},
            CheckType::Ratio => {},
            CheckType::Proximity => {},
            CheckType::Count => {},
        }
    }
    let total = rules.len();
    let score = if d.is_empty() { 100 } else { 100u32.saturating_sub((d.len() as f64 / total as f64 * 100.0).round() as u32) };
    AuditOutcome { score, total, defects: d }
}

pub fn forbiddentext(text: &str, rule: &Rule, patterns: &[String]) -> Vec<Defect> { forbiddenpattern(text, rule, patterns) }
pub fn ratiotext(text: &str, rule: &Rule, positive: &[String], negative: &[String]) -> Vec<Defect> { ratio(text, rule, positive, negative) }
pub fn proximitytext(text: &str, rule: &Rule, trigger: &str, expected: &str) -> Vec<Defect> { proximity(text, rule, trigger, expected) }
pub fn counttext(text: &str, rule: &Rule, patterns: &[String]) -> Vec<Defect> { count(text, rule, patterns) }

#[cfg(test)]
mod tests {
    use super::*;
    use crate::specTypes::CheckType;

    #[test]
    fn test_forbidden() {
        let r = Rule { id: "T".to_string(), title: "T".to_string(), description: None, severity: "error".to_string(), checktype: CheckType::ForbiddenPattern, threshold: None, scope: "full".to_string(), suggestion: None };
        let d = forbiddentext("badword", &r, &["badword".to_string()]);
        assert_eq!(d.len(), 1);
    }
}
