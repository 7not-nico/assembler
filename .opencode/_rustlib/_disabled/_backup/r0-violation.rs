// ring: 0 (PURE)
//! Defect and audit logic

use crate::report;

#[derive(Debug, Clone)]
pub struct Defect {
    pub id: String,
    pub entitytype: String,
    pub field: String,
    pub value: String,
    pub problem: String,
}

pub fn defectreport(defect: &[Defect]) -> String {
    if defect.is_empty() { return "ok — 0 defect".to_string(); }
    let header = vec!["ID", "Type", "Field", "Value", "Problem"];
    let row: Vec<Vec<String>> = defect.iter().map(|v| {
        vec![v.id.clone(), v.entitytype.clone(), v.field.clone(), v.value.clone(), v.problem.clone()]
    }).collect();
    format!("Defect ({}):\n{}", defect.len(), report::table(&row, &header))
}

pub fn defectsequence<F>(entry: &[crate::structs::EntityEntry], mut check: F) -> Vec<Defect>
where
    F: FnMut(&crate::structs::EntityEntry, &mut Vec<Defect>),
{
    let mut list = Vec::new();
    for e in entry {
        check(e, &mut list);
    }
    list
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn defectreport_empty() {
        assert_eq!(defectreport(&[]), "ok — 0 defect");
    }

    #[test]
    fn defectreport_withdata() {
        let d = Defect { id: "MAX.DRY".to_string(), entitytype: "maxims".to_string(), field: "source".to_string(), value: "".to_string(), problem: "absent".to_string() };
        let list = vec![d];
        let r = defectreport(&list);
        assert!(r.contains("MAX.DRY"));
    }
}
